.PROGRAM Master()
1		ACCURACY 1 ALWAYS
7       POINT toolTipper = TRANS(0,-165.6,112.2,0,0,180)
9       TOOL toolTipper
10      JMOVE #[49.690,3.400,-119.081,0.000,-57.519,-49.690]
15		BASE NULL
16		HERE homepos
40      speed = 9     
60      xx = 0
61      yy = 0
62      zz = 0
63      oo = 0
64      aa = 0
65      tt = 0
100     PROMPT "xyzoats",xx ,yy ,zz ,oo ,aa ,tt 
200     POINT goe = TRANS(xx,yy,0,oo,aa,tt)
201		POINT loewer = TRANS(0,0,zz,0,0,0)
205		LMOVE homepos
207		TWAIT 1
210     LMOVE homepos+goe
212		TWAIT 1
215		LMOVE homepos+goe+loewer
217		TWAIT 4
220		CLAMP 1
230		TWAIT 3
240		CLAMP -1
250     LMOVE homepos+goe
253		TWAIT 1
255		LMOVE homepos
260		JMOVE #[47.473,5.196,-121.063,0.002,-53.741,-47.466]
.END