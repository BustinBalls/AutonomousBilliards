# acsii code
'''
  IAC   = 255.chr # "\377" # "\xff" # interpret as command

  DONT  = 254.chr # "\376" # "\xfe" # you are not to use option

  DO    = 253.chr # "\375" # "\xfd" # please, you use option

  WONT  = 252.chr # "\374" # "\xfc" # I won't use option

  WILL  = 251.chr # "\373" # "\xfb" # I will use option

  SB    = 250.chr # "\372" # "\xfa" # interpret as subnegotiation

  GA    = 249.chr # "\371" # "\xf9" # you may reverse the line

  EL    = 248.chr # "\370" # "\xf8" # erase the current line

  EC    = 247.chr # "\367" # "\xf7" # erase the current character

  AYT   = 246.chr # "\366" # "\xf6" # are you there

  AO    = 245.chr # "\365" # "\xf5" # abort output--but let prog finish

  IP    = 244.chr # "\364" # "\xf4" # interrupt process--permanently

  BREAK = 243.chr # "\363" # "\xf3" # break

  DM    = 242.chr # "\362" # "\xf2" # data mark--for connect. cleaning

  NOP   = 241.chr # "\361" # "\xf1" # nop

  SE    = 240.chr # "\360" # "\xf0" # end sub negotiation

  EOR   = 239.chr # "\357" # "\xef" # end of record (transparent mode)

  ABORT = 238.chr # "\356" # "\xee" # Abort process

  SUSP  = 237.chr # "\355" # "\xed" # Suspend process

  EOF   = 236.chr # "\354" # "\xec" # End of file

  SYNCH = 242.chr # "\362" # "\xf2" # for telfunc calls



  OPT_BINARY         =   0.chr # "\000" # "\x00" # Binary Transmission

  OPT_ECHO           =   1.chr # "\001" # "\x01" # Echo

  OPT_RCP            =   2.chr # "\002" # "\x02" # Reconnection

  OPT_SGA            =   3.chr # "\003" # "\x03" # Suppress Go Ahead

  OPT_NAMS           =   4.chr # "\004" # "\x04" # Approx Message Size Negotiation

  OPT_STATUS         =   5.chr # "\005" # "\x05" # Status

  OPT_TM             =   6.chr # "\006" # "\x06" # Timing Mark

  OPT_RCTE           =   7.chr # "\a"   # "\x07" # Remote Controlled Trans and Echo

  OPT_NAOL           =   8.chr # "\010" # "\x08" # Output Line Width

  OPT_NAOP           =   9.chr # "\t"   # "\x09" # Output Page Size

  OPT_NAOCRD         =  10.chr # "\n"   # "\x0a" # Output Carriage-Return Disposition

  OPT_NAOHTS         =  11.chr # "\v"   # "\x0b" # Output Horizontal Tab Stops

  OPT_NAOHTD         =  12.chr # "\f"   # "\x0c" # Output Horizontal Tab Disposition

  OPT_NAOFFD         =  13.chr # "\r"   # "\x0d" # Output Formfeed Disposition

  OPT_NAOVTS         =  14.chr # "\016" # "\x0e" # Output Vertical Tabstops

  OPT_NAOVTD         =  15.chr # "\017" # "\x0f" # Output Vertical Tab Disposition

  OPT_NAOLFD         =  16.chr # "\020" # "\x10" # Output Linefeed Disposition

  OPT_XASCII         =  17.chr # "\021" # "\x11" # Extended ASCII

  OPT_LOGOUT         =  18.chr # "\022" # "\x12" # Logout

  OPT_BM             =  19.chr # "\023" # "\x13" # Byte Macro

  OPT_DET            =  20.chr # "\024" # "\x14" # Data Entry Terminal

  OPT_SUPDUP         =  21.chr # "\025" # "\x15" # SUPDUP

  OPT_SUPDUPOUTPUT   =  22.chr # "\026" # "\x16" # SUPDUP Output

  OPT_SNDLOC         =  23.chr # "\027" # "\x17" # Send Location

  OPT_TTYPE          =  24.chr # "\030" # "\x18" # Terminal Type

  OPT_EOR            =  25.chr # "\031" # "\x19" # End of Record

  OPT_TUID           =  26.chr # "\032" # "\x1a" # TACACS User Identification

  OPT_OUTMRK         =  27.chr # "\e"   # "\x1b" # Output Marking

  OPT_TTYLOC         =  28.chr # "\034" # "\x1c" # Terminal Location Number

  OPT_3270REGIME     =  29.chr # "\035" # "\x1d" # Telnet 3270 Regime

  OPT_X3PAD          =  30.chr # "\036" # "\x1e" # X.3 PAD

  OPT_NAWS           =  31.chr # "\037" # "\x1f" # Negotiate About Window Size

  OPT_TSPEED         =  32.chr # " "    # "\x20" # Terminal Speed

  OPT_LFLOW          =  33.chr # "!"    # "\x21" # Remote Flow Control

  OPT_LINEMODE       =  34.chr # "\""   # "\x22" # Linemode

  OPT_XDISPLOC       =  35.chr # "#"    # "\x23" # X Display Location

  OPT_OLD_ENVIRON    =  36.chr # "$"    # "\x24" # Environment Option

  OPT_AUTHENTICATION =  37.chr # "%"    # "\x25" # Authentication Option

  OPT_ENCRYPT        =  38.chr # "&"    # "\x26" # Encryption Option

  OPT_NEW_ENVIRON    =  39.chr # "'"    # "\x27" # New Environment Option

  OPT_EXOPL          = 255.chr # "\377" # "\xff" # Extended-Options-List
'''






from telnetlib import IAC, DO, DONT, WILL, WONT, SB, SE, TTYPE, NAOFFD, ECHO
import telnetlib, socket, time, threading

class KawaBot:
	"""
	Python interface to Kawasaki Robotics. 
	inspired by:
	http://code.activestate.com/recipes/52228-remote-control-with-telnetlib/
	"""
	def __init__(self, host="192.168.0.1", port=10000):
		# If connecting to K-roset D+ controller or earlier controller connect through port: 9105
		# If connecting to K-roset E controller or later controller connect through one of ports: 10000, 10300
		# NOTE: Simulated D+ controller or earlier does NOT support opening additional tcp-ip ports over localhost
		# Movement server will therfor NOT work on D+
		#self.logger = logging.getLogger("kawa")
		self.host = host
		self.port = port
		self.env_term = "VT100"
		self.user = "as" # khidl also possible, effect unknown. different permissions?
		self.telnet = telnetlib.Telnet()
		self.connect()

	def telnet_process_options(self, socket, cmd, opt):			
		IS = b'\00'
		# Inspired by
		# https://github.com/rapid7/metasploit-framework/blob/master/lib/msf/core/exploit/telnet.rb
		# https://github.com/jquast/x84/blob/cf3dff9be7280f424f6bcb0ea2fe13d16e7a5d97/x84/default/telnet.py
		if cmd == WILL and opt == ECHO: #hex:ff fb 01 name:IAC WILL ECHO description:(I will echo)
				socket.sendall(IAC + DO + opt) #hex(ff fd 01), name(IAC DO ECHO), descr(please use echo)
		elif cmd == DO and opt == TTYPE: #hex(ff fd 18), name(IAC DO TTYPE), descr(please send environment type)
				socket.sendall(IAC + WILL + TTYPE) #hex(ff fb 18), name(IAC WILL TTYPE), descr(Dont worry, i'll send environment type)
		elif cmd == SB:
			socket.sendall(IAC + SB + TTYPE + IS + self.env_term.encode() + IS + IAC + SE)
			# hex(ff fa 18 00 b"VT100" 00 ff f0) name(IAC SB TTYPE iS VT100 IS IAC SE) descr(Start subnegotiation, environment type is VT100, end negotation)
		elif cmd == SE: # server letting us know sub negotiation has ended
			pass # do nothing
		else: print("Unexpected telnet negotiation")

	def connect(self):
		print("Connecting to kawasaki robot")
		self.telnet.set_option_negotiation_callback(self.telnet_process_options)
		self.telnet.open(self.host, self.port, 1)
		time.sleep(0.5) #Allow TELNET negotaion to finish
		self.telnet.read_until(b"n: ") 
		self.telnet.write(self.user.encode() + b"\r\n")
		self.telnet.read_until(b">")
		print("Connected succesfully\n")

	def disconnect(self):
		print("Disconnecting")
		command = b"signal(-2010)\r\n"
		self.telnet.write(command)
		time.sleep(1)
		print(self.telnet.read_until(b">").decode())
		self.telnet.close()

	def AS_command(self, command=None):
		if command == None:
			print("No command specified, check kawa documentation")
			return
		command = command.encode + b"\r\n"
		self.telnet.write(command)
		self.telnet.read_until(b">")

	def load_as_file(self, file_location=None):
		max_chars = 492 # Max amount of characters that can be accepted per write to kawa.
		if file_location != None:
			print("Transfering {} to kawasaki".format(file_location))
			inputfile = open(file_location, 'r')
			file_text = inputfile.read() # Store Kawa-as code from file in local varianle
			text_split = [file_text[i:i+max_chars] for i in range(0, len(file_text), max_chars)] #Split AS code in sendable blocks
			print("File consists of {} characters".format(len(file_text)))
			self.telnet.write(b"load kawa.as\r\n")
			self.telnet.read_until(b'.as').decode("ascii")
			self.telnet.write(b'\x02A    0\x17')
			self.telnet.read_until(b"\x17")
			print("Sending file.... ")
			for i in range(0, len(text_split), 1):
				self.telnet.write(b'\x02C    0' + text_split[i].encode() + b'\x17')
				self.telnet.read_until(b"\x17")
			self.telnet.write(b'\x02' + b'C    0' + b'\x1a\x17')
			#Finish transfering .as file and start confirmation
			self.telnet.read_until(b"Confirm !")
			self.telnet.write(b'\r\n')
			self.telnet.read_until(b"E\x17")
			self.telnet.write(b'\x02' + b'E    0' + b'\x17')
			#Read until command prompt and continue
			self.telnet.read_until(b">")
			print(".... Done, great success!\n")
		else: print("No file specified\n")
        #Lastknown check, was built and sent to robot

	def abort_kill_all(self):
		for command in ["pcabort "]:
			for i in range(1, 6):
				prog_number = str(i) + ":"      #should include socket connection ending
				self.telnet.write(command.encode() + prog_number.encode() + b"\r\n")
				self.telnet.read_until(b">")
		for command in ["abort ", "pckill\r\n1", "kill\r\n1"]:
			self.telnet.write(command.encode() + b"\r\n")
			self.telnet.read_until(b">")

    #wont work, wrong command syntax
	def payload_weight(self, kg=0, centre_of_mass=(0,0,0)):
		command = 	("weight " + str(kg) + ", " + 
					str(centre_of_mass[0]) + ", " + 
					str(centre_of_mass[1]) + ", " + 
					str(centre_of_mass[2]) + "\r\n").encode()
		self.telnet.write(command)
		print(self.telnet.read_until(b">"))

	def delete_eveything_in_robot_memory(self):
		command = b"sysint\r\n"        #was sysinit=initalize system sysint=Clears the memory and initializes the system parameters 
		self.telnet.write(command)
		self.telnet.read_until(b"(Yes:1, No:0)")
		command = b"1\r\n"
		self.telnet.write(command)
		self.telnet.read_until(b">")

	def motor_power_on(self):
		command = b"External motor Power on\r\n"#pg 13ASGuide
		self.telnet.write(command)
		self.telnet.read_until(b">")

	def motor_power_off(self):
		command = b"External motor Power off\r\n"
		self.telnet.write(command)
		self.telnet.read_until(b">")

	def get_status(self):
		command = b"status\r\n"
		self.telnet.write(command)
		print(self.telnet.read_until(b">").decode("ascii"))

	def get_kawa_position(self):
		command = b"where\r\n"
		self.telnet.write(command)
		print(self.telnet.read_until(b">").decode("ascii"))

	def get_kawa_error(self):
		command = b"errorlog\r\n"#pg 244ASGUIDE
		self.telnet.write(command)
		print(self.telnet.read_until(b">").decode("ascii"))
	
	def reset_error(self):
		command = b"ereset\r\n"
		self.telnet.write(command)
		print(self.telnet.read_until(b">").decode("ascii"))

#cant find command ID 
	def get_kawa_id(self):
		command = b"ID\r\n"
		self.telnet.write(command)
		print(self.telnet.read_until(b">").decode("ascii"))

	def initiate_kawabot(self):
		print("Initiating kawabot")
		command = b"pcexecute init_kawa\r\n"#CALLS TO .AS!!! PCEXECUTE [program, cycle, step]
		self.telnet.write(command)
		print(self.telnet.read_until(b"completed").decode("ascii"))
		command = b"\r\n"
		self.telnet.write(command)
		#time.sleep(0.1)
		print(self.telnet.read_until(b">").decode("ascii"))

	def connect_to_movement_server(self, movement_server_port=9811):
		print("Connecting to movement server")
		command = b"pcexecute 1: recv_tcp_serv\r\n"#CALLS TO .AS
		self.telnet.write(command)
		self.telnet.read_until(b">").decode("ascii")
		self.movement_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		self.movement_server.connect((self.host, movement_server_port))
		self.movement_seq_num = 0
		print("Activating movement server")
		command = b"pcexecute 2: read_tcp_buffer\r\n"
		self.telnet.write(command)
		self.telnet.read_until(b">").decode("ascii")
		print("Start moving robot")
		command = b"execute move_kawa\r\n"#CALLS TO .AS
		self.telnet.write(command)
		self.telnet.read_until(b">").decode("ascii")
		print("Connected to and activated movement server succesfully!\n")

	def jmove(self, joint_0, joint_1, joint_2, joint_3, joint_4, joint_5, speed=100, accuracy=10, acceleration=100, deceleration=100, break_cp=0):
		# EXAMPLE joint_trajectory_point = "\x02|\x01|45|11|00|10|400|100|100|0|-40|20|-50|0|10|100|\x03"
		msg_start = "\x02|\x01|"
		msg_seq_num = "|11|" + str(self.movement_seq_num).zfill(2) 
		msg_end = msg_seq_num + "|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|\x03".format(
			speed, accuracy, acceleration, deceleration, break_cp, 
			joint_0, joint_1, joint_2, joint_3, joint_4, joint_5)
		joint_trajectory_point = msg_start + str(len(msg_end)) + msg_end
		try:
			self.movement_server.send(joint_trajectory_point.encode())		
			if self.movement_seq_num == 99:
				self.movement_seq_num = 0
			else:
				self.movement_seq_num += 1
		except socket.error:
			print("No chooch")
#Define each joint seperately? DRIVE jointnum,angle[speed] 
	def close_movement_server(self):
		self.movement_server.close()
		#close socket?
	def close_pose_update_server(self):
		self.pose_server.close()
        #close socket?
	def connect_to_pose_update_server(self, pose_update_server_port=23):
		print("Connecting to pose update server")
		command = b"pcexecute 4: send_pos_serv\r\n"
		self.current_pose = 0
		self.telnet.write(command)
		self.telnet.read_until(b">").decode("ascii")
		self.pose_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		self.pose_server.connect((self.host, pose_update_server_port))
		self.pose_server.settimeout(1)
		print("Connected to pose update server succesfully!\n")

	def get_current_pose(self):
		return self.pose_server.recv(1024)

#################################################
############### Testing functions ###############
#################################################

	def connect_to_tcp_test(self):
		print("Connecting to tcp server")
		command = b"pcexe 1: recv_traj_serv\r\n"
		self.telnet.write(command)
		self.telnet.read_until(b">").decode("ascii")
		command = b"pcexe 2: read_per_char\r\n"
		self.telnet.write(command)
		self.telnet.read_until(b">").decode("ascii")

		movement_server_port = 23
		self.tcp_test_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		self.tcp_test_server.connect((self.host, movement_server_port))
		print("Connected succesfully!\n")

	def send_tcp_test_message(self, message="hello!"):	
		try:
			print(message)
			self.tcp_test_server.send(message.encode())		
		except socket.error:
			print("No chooch")

	def close_to_tcp_test(self):
		command = b"signal(-2010)\r\n"
		self.telnet.write(command)
		time.sleep(1)
		print(self.telnet.read_until(b">").decode())
		self.tcp_test_server.close()