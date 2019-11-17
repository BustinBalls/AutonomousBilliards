# -*- coding: utf-8 -*-
"""
Created on Thu Aug 22 16:16:22 2019

@author: Law
"""

from kawapai import robot
#import time
D_controller_robot = robot.KawaBot(host="127.0.0.1", port=10000)

D_controller_robot.abort_kill_all()

D_controller_robot.motor_power_off()
D_controller_robot.reset_error()
D_controller_robot.load_as_file("kawasaki_side.as")
D_controller_robot.motor_power_on()

D_controller_robot.initiate_kawabot()
D_controller_robot.connect_to_movement_server()

D_controller_robot.jmove(0,0,0,0,0,0)

time.sleep(1)

D_controller_robot.jmove(0,0,-90,0,0,180,speed=30)

D_controller_robot.close_movement_server() 
D_controller_robot.disconnect()
