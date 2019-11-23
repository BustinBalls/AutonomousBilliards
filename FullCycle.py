from telnetlib import IAC, DO, WILL, SB, SE, TTYPE, ECHO, DONT, WONT, NAOFFD
import telnetlib
import socket
import time
import threading
import os
import matlab.engine


def clear_all():
    """Clears all the variables from the workspace of the spyder application."""
    gl = globals().copy()
    for var in gl:
        if var[0] == '_': continue
        if 'func' in str(globals()[var]): continue
        if 'module' in str(globals()[var]): continue

        del globals()[var]

class Kawasaki:
    """
	Python interface to  connect, initite, and control progrmas for Kawasaki
    Robotics. File X6 was originally recieved form James Hudak, Mechatronics 
    Lab assitant for Kennesaw State University, if number folling the 'x' 
    changes it simply reflects modified version.
    
    *TCP port 23 uses the Transmission Control Protocol. TCP is one of the main
    protocols in TCP/IP networks. Whereas the IP protocol deals only with 
    packets, TCP enables two hosts to establish a connection and exchange 
    streams of data. TCP guarantees delivery of data and also guarantees that 
    packets will be delivered on port 23 in the same order in which they were 
    sent. Guaranteed communication over port 23 is the key difference between 
    TCP and UDP. UDP port 23 would not have guaranteed communication in the 
    same way as TCP.  
	"""
    def __init__(self, hostIp='192.168.0.30', port=23):                         # Defines a local IP address connecting to Robot, Port is set to 23 as it is the TCP/IP communications on PC, was recommended to use 10300?
        self.BUFFER_SIZE = 512                                                 # bytes                                                     # seconds # No robot movement should take more than 60 seconds
        self.sock = None
        self.sockjnts = None
        self.hostIp = hostIp                                                   #
        self.port = port
        self.env_term = 'VT100'
        self.user = "as" 
        self.telnet = telnetlib.Telnet()
        #self.connect()
        
    def telnet_process_options(self, socket, cmd, opt):				
        IS = b'\00'
        if cmd == WILL and opt == ECHO:                                        # hex:ff fb 01 name:IAC WILL ECHO description:(I will echo)
            socket.sendall(IAC + DO + opt)                                     # hex(ff fd 01), name(IAC DO ECHO), descr(please use echo)
        elif cmd == DO and opt == TTYPE:                                       # hex(ff fd 18), name(IAC DO TTYPE), descr(please send environment type)		
            socket.sendall(IAC + WILL + TTYPE)                                 # hex(ff fb 18), name(IAC WILL TTYPE), descr(Dont worry, i'll send environment type)
        elif cmd == SB:
            socket.sendall(IAC + SB + TTYPE + IS + self.env_term.encode() + IS + IAC + SE)
            # hex(ff fa 18 00 b"VT100" 00 ff f0) name(IAC SB TTYPE iS VT100 IS IAC SE) descr(Start subnegotiation, environment type is VT100, end negotation)
        elif cmd == SE:                                                        # server letting us know sub negotiation has ended
            pass                                                               # do nothing
        else: print('Unexpected telnet negotiation')
    
    def connect(self):
        print(f'>Connecting to robot, IPv4:{self.hostIp}, port:{self.port}')
        self.telnet.set_option_negotiation_callback(self.telnet_process_options)
        self.telnet.open(self.hostIp, self.port)
        time.sleep(0.5) #Allow TELNET negotaion to finish
        self.telnet.read_until(b"n: ") 
        self.telnet.write(self.user.encode() + b"\r\n")
        self.telnet.read_until(b">")
        print('>Connected succesfully\n')
        
    def disconnect(self):
        #Wrote this a bit different
        print("Disconnecting")
        command = b"signal(-2010)\r\n"
        self.telnet.write(command)
        #time.sleep(1)
        print(self.telnet.read_until(b">").decode())
        self.telnet.close()      
    
    def load_as_file(self, file_location='master.as'):
        max_chars = 492                                                        # Max amount of characters that can be accepted per write to kawa.
        if file_location != None:
            print('>Transfering {} to kawasaki'.format(file_location))
            inputfile = open(file_location, 'r')
            file_text = inputfile.read()                                       # Store Kawasaki-as code from file in local varianle
            text_split = [file_text[i:i+max_chars] for i in range(0, len(file_text), max_chars)] # Split AS code in sendable blocks
            print(f'>File consists of {len(file_text)} characters')
            
            self.telnet.write(b"load master.as\r\n")##########################
            self.telnet.read_until(b".as").decode("ascii")
            self.telnet.write(b"\x02A    0\x17")
            self.telnet.read_until(b"\x17")
            print('>Sending file.... maybe....')
            for i in range(0, len(text_split), 1):
                self.telnet.write(b"\x02C    0" + text_split[i].encode() + b"\x17")
                self.telnet.read_until(b"\x17")
                print('>Loaded {} of {}'.format(i+1,len(text_split)))
            self.telnet.write(b"\x02" + b"C    0" + b"\x1a\x17")
            self.telnet.write(b"\r\n")
            self.telnet.read_until(b"E\x17")
            self.telnet.write(b"\x02" + b"E    0" + b"\x17")
            #Read until command prompt and continue
            self.telnet.read_until(b">")
            print(".... Done, great success!\n        -Borat\n")
        else: print('No file specified\n')                                     #Lastknown check, was built and sent to robot#still True [yes] [no]

    def abort_kill_all(self):
        for command in ["pcabort "]:
            for i in range(1, 6):
                prog_number = str(i) + ":"     
                self.telnet.write(command.encode() + prog_number.encode() + b"\r\n")
                self.telnet.read_until(b">")
        for command in ["abort ", "pckill\r\n1", "kill\r\n1"]:
            self.telnet.write(command.encode() + b"\r\n")
            self.telnet.read_until(b">")

    def kawa_callback(self,strCmd='0 0 0 0 0 0'):
        command=b'exe master\r\n' #Runs pg goat
        self.telnet.write(command)
        print(self.telnet.read_until(b'xyzoats').decode('ascii'))
        command=strCmd.encode() + b"\r\n"
        self.telnet.write(command)
        print(self.telnet.read_until(b'>').decode('ascii'))
    
    def initiate_move(self,strCmd='0 0 0 0 0 0'):
        self.motor_power_on()
        #time.sleep(5)
        command=b'exe master\r\n' 
        self.telnet.write(command)
        print(self.telnet.read_until(b'xyzoats').decode('ascii'))
        command=strCmd.encode() + b"\r\n"
        self.telnet.write(command)
        self.telnet.read_until(b'>Program completed.No = 1').decode('ascii')
        self.asCmd('esc')
        self.motor_power_off()

    def motor_power_on(self):               #kept this to power robot motors    
        command = b"zpow on\r\n"
        self.telnet.write(command)
        self.telnet.read_until(b">")
        
    def motor_power_off(self):
        command = b"zpow off\r\n"
        self.telnet.write(command)
        self.telnet.read_until(b">")
    
    def reset_error(self):                  #Rest error
        command = b'ereset\r\n'
        self.telnet.write(command)
        self.telnet.read_until(b">").decode("ascii")

    def asCmd(self,command=None):
        command=command.encode() + b'\r\n'
        self.telnet.write(command)
        self.telnet.read_until(b'>')
        
    def clampExtend(self):
        self.motor_power_on()
        #time.sleep(1)
        command=b'exe Klampe\r\n' #Runs pg goat
        self.telnet.write(command)
        self.telnet.read_until(b'>Program completed.No = 1').decode('ascii')
        self.asCmd('esc')
        #time.sleep(1)
        #self.motor_power_off()
        
    def clampRetract(self):
        self.motor_power_on()
        #time.sleep(1)
        command=b'exe Klampr\r\n' #Runs pg goat
        self.telnet.write(command)
        self.telnet.read_until(b'>Program completed.No = 1').decode('ascii')
        self.asCmd('esc')
        #self.motor_power_off()
        
    def MasterPart1(self,strCmd='0 0 0 0 0 0'):
        self.motor_power_on()
        #time.sleep(5)
        command=b'exe redhot\r\n' #Runs pg goat
        self.telnet.write(command)
        self.telnet.read_until(b'xyzoats').decode('ascii')
        command=strCmd.encode() + b"\r\n"
        self.telnet.write(command)
        self.telnet.read_until(b'>Program completed.No = 1',timeout=10).decode('ascii')
        #self.telnet.read_until(b'(E1128) Uncoincidence error betw destination and current jt 6 pos.',timeout=10).decode('ascii')
        time.sleep(3)
        self.reset_error()
        self.asCmd('esc')
        #self.motor_power_off()
        
    def MasterPart2(self):
        self.motor_power_on()
        self.reset_error()
        command=b'exe chili\r\n' #Runs pg goat
        self.telnet.write(command)
        self.telnet.read_until(b'>Program completed.No = 1').decode('ascii')
        self.asCmd('esc')
        
        
    def EThome(self):
        self.motor_power_on()
        self.reset_error()
        command=b'exe peppers\r\n' #Runs pg goat
        self.telnet.write(command)
        self.telnet.read_until(b'>Program completed.No = 1').decode('ascii')
        self.asCmd('esc')
        
        
        
        
if __name__ == "__main__":    
    eng=matlab.engine.start_matlab()
    eng.InitiateMatLabParameters(nargout=0)                                 
    FS30L = Kawasaki() 
    FS30L.connect()                                                
    FS30L.reset_error()
    FS30L.abort_kill_all()
    FS30L.MasterPart2()
    while True:#start the loop! 
        try:
            FS30L.clampRetract()
        except OSError:
            FS30L.connect()                                                
            FS30L.reset_error()
            FS30L.abort_kill_all()
            time.sleep(2)
            FS30L.clampRetract()
        eng.Stepper2Front(nargout=0)     
        try:
            FS30L.clampExtend()
        except OSError:
            FS30L.connect()                                                
            FS30L.reset_error()
            FS30L.abort_kill_all()
            time.sleep(2)
            FS30L.clampExtend()
       
        strCmd=eng.ClusterClean(nargout=1)
        eng.Stepper2Back(nargout=0)
        try:
            FS30L.MasterPart1(strCmd)
        except OSError:
            FS30L.connect()                                                
            FS30L.reset_error()
            FS30L.abort_kill_all()
            time.sleep(2)
            FS30L.MasterPart1(strCmd)
        try:
            FS30L.clampRetract()
        except OSError:
            FS30L.connect()                                                
            FS30L.reset_error()
            FS30L.abort_kill_all()
            time.sleep(2)
            FS30L.clampRetract()
        try:
            FS30L.MasterPart2()
        except OSError:
            FS30L.connect()                                                
            FS30L.reset_error()
            FS30L.abort_kill_all()
            time.sleep(2)
            FS30L.MasterPart2()
