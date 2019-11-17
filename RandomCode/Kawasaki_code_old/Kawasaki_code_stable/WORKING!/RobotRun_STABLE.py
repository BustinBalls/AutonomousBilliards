# -*- coding: utf-8 -*-
"""
Created on Thu Aug 22 16:16:22 2019

@author: Law
"""
import time
import Control_STABLE as Control
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

FS30L.reset_error()#would assume this also works then 
FS30L.abort_kill_all()
FS30L.motor_power_off()
FS30L.reset_error()
#FS30L.load_as_file('x7.as')
FS30L.motor_power_on()#Works without loading program
#Allow add program load and run



FS30L.kawa_callback() #currently callbacks x6 which was changed for photo shoot some point
#When this is called it enters a loop. With this loop i want to establish a stdIN and STDout to call to and from externally

