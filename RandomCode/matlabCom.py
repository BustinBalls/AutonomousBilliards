# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import cv2
import numpy as np
import matlab.engine
eng=matlab.engine.start_matlab()
#ret=eng.MatLab_grabPiImg(nargout=1)
#print(ret)
#img=ret[0]
np.array([img])=cv2.imread("E://ClusterFuck/FS30L_Control/maskedImg.png")
cv2.imshow("img",img)
'''
In this example, x exists only as a Python variable. Its value is assigned to 
a new entry in the engine workspace, called y, creating a MATLAB variable. 
You can then call the MATLAB eval function to execute the sqrt(y) statement in
 MATLAB and return the output value, 2.0, to Python.


eng=matlab.engine.start_matlab()
x = 4.0
eng.workspace['y'] = x
a = eng.eval('sqrt(y)')
print(a)


This example shows how to call a MATLAB® script to compute the area of a triangle from Python®.
In your current folder, create a MATLAB script in a file named triarea.m.

ret=eng.triarea(1.0,5.0)
#print(ret)
#or if just script eng.triarea(nargout=0)

Create an array in Python and put it into the MATLAB workspace.
px is a MATLAB array, but eng.linspace returned it to Python. To use it in 
MATLAB, put the array into the MATLAB workspace.
When you add an entry to the engine workspace dictionary, you create a MATLAB 
variable, as well. The engine converts the data to a MATLAB data type.

px = eng.linspace(0.0,6.28,1000)
eng.workspace['mx'] = px

get pi from matlab workspace

eng.eval('a = pi;',nargout=0)
mpi = eng.workspace['a']
print(mpi)

'''
vv=input("key to exit")
cv2.destroyAllWindows()