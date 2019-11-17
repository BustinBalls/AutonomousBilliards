# -*- coding: utf-8 -*-
"""
Spyder Edito
x(mm)y,z
785, 679,68
This is a temporary script file.
"""
#should create
line='2 200 0 -300 0 0 0'
outF = open("F:\\robotLog.txt", "w")
#for line in textList:
# write line to output file
outF.write(line)
outF.close()


'''
with open('F:\\robotLog.txt', 'r') as f:
    lines = f.read().splitlines()
    last_line = lines[-1]
    print (last_line)
'''