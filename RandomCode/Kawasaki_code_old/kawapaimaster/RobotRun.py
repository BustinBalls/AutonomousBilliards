# -*- coding: utf-8 -*-
"""
Created on Thu Aug 22 16:16:22 2019

@author: Law
"""
import time
from kawapai import robot

D_controller_robot = robot.KawaBot(host="192.168.0.2", port=23)

D_controller_robot.abort_kill_all()

D_controller_robot.motor_power_off()
D_controller_robot.reset_error()
D_controller_robot.load_as_file("S:\\FromE\SENIORDES\Kawasaki code_old\kawapaimaster\kawapai\kawa.as")
D_controller_robot.motor_power_on()

D_controller_robot.initiate_kawabot()
D_controller_robot.get_status()
D_controller_robot.get_kawa_position()
D_controller_robot.connect_to_movement_server(21)

D_controller_robot.jmove(0, 0, 0, 0, 0, 0)

time.sleep(1)

D_controller_robot.jmove(0, 0, 30, 0, 0, 180)


D_controller_robot.close_movement_server() 
D_controller_robot.disconnect()
