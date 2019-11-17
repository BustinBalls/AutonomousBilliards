"""
Created on Thu Aug 22 16:16:22 2019
@author: Law
"""
import Control
'''
IF cmd==0 GOTO 2000
cmd==2 ;ABS XYZ xx,-yy,-zz,oo,aa,tt (mm mm mm deg deg deg)
cmd==3 ;ABS XYZ xx,-yy,-zz,oo,aa,tt
cmd==4 ;REL XYZ
cmd==5 ;ABS JNT OFF
cmd==9 ;SPEED CHANGE
cmd==99 ;HOME
cmd==11 ;CURRENT JOINT POS
cmd==12 ;CURRENT LIN POS
cmd==19 ;READ DIG INPUT
cmd==20 ;CLAMP ON OFF
cmd==90 ;DIG OUT ON OFF
'''

FS30L = Control.Kawasaki()
FS30L.abort_kill_all()
FS30L.motor_power_off()
FS30L.reset_error()
FS30L.load_as_file('callBack.as')

FS30L.motor_power_on()

FS30L.kawa_callback() 

