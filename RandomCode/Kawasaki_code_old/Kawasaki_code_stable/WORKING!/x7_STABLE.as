.***************************************************************************
.*=== AS GROUP ===         : AS_01B0030Y 2007/05/14 19:29
.*USER IF AS               : UAS01B0030Y 2007/05/14 19:14
.*USER IF TP               : UTP01B0030Y 2007/05/14 19:24
.*ARM CONTROL AS           : AAS01B0030Y 2007/05/14 19:27
.*USER IF AS MESSAGE FILE  : MAS1B030YEN 2007/05/14 19:12
.*USER IF TP MESSAGE FILE  : MTP1B030YEN 2007/05/14 19:23
.*ARM DATA FILE            : ARM01B0030Y 2007/05/14 19:46
.*USER IF IPL              : UIP01390000 2006/02/08
.*ARM CONTROL IPL          : AIP01320000 2006/02/08
.*=== SERVO GROUP ===      : SV_0400001R 2007/04/20 17:00
.*ARM CONTROL SERVO        : ASV0400001R 2007/04/20 16:28
.*SRV DATA FILE            : ASP0400001R 2007/04/20 16:56
.*ARM CONTROL SERVO CONT.  : ASC0400001R 2007/04/20
.*   [Shipment setting data] 
.*There is no Shipment setting data.
.***************************************************************************
.NETCONF     192.168.0.2,"",255.255.255.0,0.0.0.0,0.0.0.0,0.0.0.0,""
.PROGRAM x7()
10      JMOVE #[0,0,-90,0,-90,0]
16      BASE NULL
20      HERE homepos
50      speed = 3
60      xx = 0
61      yy = 0
62      zz = 0
63      oo = 0
64      aa = 0
65      tt = 0
66      cmd = 0
100     PROMPT "xyzoats",cmd ,xx ,yy ,zz ,oo ,aa ,tt 
110     PRINT "GOT COMMAND ",cmd
111     IF cmd>99 GOTO 2000
112     IF cmd<0 GOTO 2000
;;;;120 PRINT "ARGUEMENTS: ",XX,YY,ZZ,OO,AA,TT
130     IF cmd==0 GOTO 2000
150     IF cmd==2 GOTO 200  ;ABS XYZ LIN
155     IF cmd==3 GOTO 300  ;ABS XYZ JNT
160     IF cmd==4 GOTO 400  ;REL XYZ
165     IF cmd==5 GOTO 500  ;ABS JNT OFF
170     IF cmd==9 GOTO 800  ;SPEED CHANGE
171     IF cmd==99 GOTO 1200 ; HOME
175     IF cmd==10 GOTO 600  ;STATUS PACK
180     IF cmd==11 GOTO 680  ;CURRENT JOINT POS
183     IF cmd==12 GOTO 690  ;CURRENT LIN POS
185     IF cmd==19 GOTO 1100  ;READ DIG INPUT
190     IF cmd==20 GOTO 700  ;CLAMP ON OFF
195     IF cmd==90 GOTO 1000  ;DIG OUT ON OFF
;--------------------------------------------------
;ABSOLUTE XYZ LINEAR
200     POINT goe = TRANS(xx,-yy,-zz,oo,aa,tt)
210     LMOVE homepos+goe
299     GOTO 2000
;ABSOLUTE XYZ JOINT
300     POINT goe = TRANS(xx,-yy,-zz,oo,aa,tt)
310     JMOVE homepos+goe
399     GOTO 2000
;RELATIVE XYZ
400     DRAW xx,yy,zz,oo,aa,tt
499     GOTO 2000
;ABSOLUTE JOINT OFFSETS
500     JMOVE #PPOINT(xx,yy,zz,oo,aa,tt)
599     GOTO 2000
;STATUS PACKET99
600;MC STATUS
609     GOTO 2000
;GET cURRENT JOINT POS
680;MC WHERE 1
689     GOTO 2000
;GET CURRENT LIN POS
690     HERE currentpose
691     DECOMPOSE zz[0] = currentpose
692     PRINT "XYZ"+$ENCODE(zz[0]),""+$ENCODE(zz[1]),""+$ENCODE(zz[2])
693     PRINT "OAT"+$ENCODE(zz[3]),""+$ENCODE(zz[4]),""+$ENCODE(zz[5])
699     GOTO 2000
;CLAMP OPEN
700     CLAMP xx
799     GOTO 2000
;SPEED CHANGE
800     SPEED xx ALWAYS
810     PRINT "SET SPEED TO ",xx
899     GOTO 2000
;TURN ON OFF DIGITAL OUT
1000    SIGNAL xx,yy,zz,oo,aa,tt
1099    GOTO 2000
;READ DIGITAL IN
1100;DEFSIG INPUT
1199    GOTO 2000
; HOME 
1200    JMOVE #[0,0,0,0,0,0]
1299    GOTO 2000
2000    cmd = 0
2010    GOTO 100
1
.END
