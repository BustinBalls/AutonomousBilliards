.PROGRAM init_kawa()
  
  ;Initiate driver
  ONE shutdown_kawa 							;Calls program when error occurs
  keep_active_signal = 2010 					;Define signal number
  signal keep_active_signal 					;Set signal to TRUE, range_2001-2128
  
  ;Initiate movement pose queue
  queue_size = 50
  queue_front = 0
  queue_rear = 0
  
  ;Initiate tcp string buffer
  $tcp_buffer = ""
  seq_num_old = 0
  
.END








.PROGRAM recv_tcp_serv () ; 
  ;
$recv_tcp_serv_state = "0, initiating"
.recv_port = 9814
.timeout_recv = 0.01
.num = 0
.ret_listen = -1
;.recv_sockid = -1
$recv_tcp_serv_state = "Connecting on port " + $ENCODE(.recv_port)
;
DO
  TCP_LISTEN .ret_listen, .recv_port
  IF .ret_listen < 0 THEN
    TWAIT 0.1
  END
UNTIL .ret_listen >= 0
;
DO
  TCP_ACCEPT .recv_sockid, .recv_port, 1
UNTIL .recv_sockid > 0
 ; 
$recv_tcp_serv_state = "Connected and can start receiving poses through sockid: " + $ENCODE(.recv_sockid)
  ;
WHILE sig(keep_active_signal) DO
  .num = 0
  tcp_recv .ret, .recv_sockid, .$tcp_message[1], .num, .timeout_recv, 1
  ;$recv_tcp_serv_state = "Current state tcp comms: " + $ERROR(.ret)
  IF .ret >= 0 THEN ;If we received stuff, add message to internal tcp_buffer    
    IF .num > 0 THEN
      for .i = 1 to .num
        $tcp_buffer = $tcp_buffer  + .$tcp_message[.i]   
      END
    END
  ELSE
    TWAIT 0.01
  END 
END

$recv_tcp_serv_state = "Closing connection"

TCP_CLOSE .ret, .recv_sockid
IF .ret < 0 THEN
  $recv_tcp_serv_state = "Closing connection error: " + $ERROR(.ret)
  TCP_CLOSE .ret, .recv_sockid
END
TCP_END_LISTEN .ret, .recv_port 

$recv_tcp_serv_state = "Closed succesfully"

.END












.PROGRAM send_pos_serv()
; 
$send_server_state = "Initiating"
.send_port = 12014
.send_msgs_per_sec = 10
.timeout_recv = 0.1
.num = 0
.ret_listen = -1
.ret_sockid = -1
;
$send_server_state =  "Listening on port " + $ENCODE(.send_port)
;
DO
  TCP_LISTEN .ret_listen, .send_port
  IF .ret_listen < 0 THEN
    TWAIT 0.1
  END
UNTIL .ret_listen >= 0
;
DO
  TCP_ACCEPT .send_sockid, .send_port, 1
UNTIL .send_sockid > 0
;
$send_server_state =  "Connected and can start sending current poses through sockid" + $ENCODE(.send_sockid)
; 
WHILE sig(keep_active_signal) DO
  CALL encode_pose(.$pose)
  .$send_buf[1] = .$pose
  TCP_SEND .ret, .send_sockid, .$send_buf[1], 1, .timeout_recv
  TWAIT (1 / .send_msgs_per_sec)
END
;
$send_server_state =  "Closing connection"
;
TCP_CLOSE .ret, .send_sockid
IF .ret < 0 THEN
  $recv_tcp_serv_state = "Closing connection error: " + $ERROR(.ret)
  TCP_CLOSE .ret, .send_sockid
END
TCP_END_LISTEN .ret, .send_port 
;
.END















.PROGRAM read_tcp_buffer()
  ;
  $read_tcp_buffer_state = "Initiating"
   ;
  .$start_of_msg0 = $CHR(2)
  .$start_of_msg1 = $CHR(1)
  .$end_of_msg = $CHR(3)
  .$temp = "init"
  ;
  start:
  WHILE sig(keep_active_signal) DO
    WAIT len($tcp_buffer) > 0
    ;PRINT "Message: ", $msg
    .$temp = $DECODE($tcp_buffer, .$start_of_msg0, 0) ;Delete everything up to first start_of_message
    IF len($tcp_buffer) > 0 THEN ;Check if TCP buffer is not empty, can be empty of no start_of_message available.
      .$temp = $DECODE($tcp_buffer, "|", 0) ;Store characters upto seperator as variable
      .$seperator = $DECODE($tcp_buffer, "|", 1) ;Remove pipe seperator 
      IF .$temp == .$start_of_msg0 THEN ;Check if start_of_message was indeed found
        WAIT len($tcp_buffer) > 2
        ;PRINT "yes1!"
        .$temp = $DECODE($tcp_buffer, "|", 0) ;Store characters upto seperator as variable
        .$seperator = $DECODE($tcp_buffer, "|", 1) ;Remove pipe seperator
        IF .$temp == .$start_of_msg1 THEN ;Check if start_of_heading was found
          WAIT len($tcp_buffer) > 3
          ;PRINT "yes2!"
          .$temp = $DECODE($tcp_buffer, "|", 0) ;Store characters upto seperator as variable
          .msg_length = VAL(.$temp)
          WAIT len($tcp_buffer) >= .msg_length
          ;print "Message length: ", .msg_length         
          .$full_message = $DECODE($tcp_buffer, .$end_of_msg, 0) ;store everything up to end_of_message
          ;print .$full_message
          IF len(.$full_message) == (.msg_length - 1) THEN
            ; print "YES!!!!!", .$full_message
            CALL decode_traj_pt(.$full_message, .msg_id, .prog_speed, .prog_acc, .prog_accel, .prog_decel, .prog_break, .joint0, .joint1, .joint2, .joint3, .joint4, .joint5)
            CALL ins_rear_queue(.msg_id, .prog_speed, .prog_acc, .prog_accel, .prog_decel, .prog_break, .joint0, .joint1, .joint2, .joint3, .joint4, .joint5)
          ELSE
            $read_tcp_buffer_state = "error"
            PRINT "oh no :( 3"
            ;call shutdown error!
          END
        ELSE
          $read_tcp_buffer_state = "error"
          PRINT "oh no :( 2"
          ;call shutdown error!
        END
      ELSE
        $read_tcp_buffer_state = "error"
        PRINT "oh no :( 1"
        ;call shutdown error!
      END
    ELSE
      $read_tcp_buffer_state = "error"
      ;print "TCP buffer empty!"
      TWAIT 0.5
    END
  END
.END


















.PROGRAM encode_pose (.$pose) ; 
HERE .#CP
DECOMPOSE .CP[0] = .#CP
.$S = "|"
.$pose = $CHR (2) + $ENCODE (/L, .$S, .CP[0], .$S, .CP[1], .$S, .CP[2], .$S, .CP[3], .$S, .CP[4], .$S, .CP[5], .$S) + $CHR (3) + $CHR (10)
.END
.PROGRAM decode_traj_pt (.$full_message,.msg_id,.prog_speed,.prog_acc,.prog_accel,.prog_decel,.prog_break,.joint0,.joint1,.joint2,.joint3,.joint4,.joint5) ; 
  ;
  .$temp = $DECODE(.$full_message, "|", 1) ; remove seperator
  .$msg_id = $DECODE(.$full_message, "|", 0) ; read until next seperator
  .msg_id = VAL(.$msg_id)
  ;
  IF not .msg_id == 11 and not .msg_id == 12 THEN
    $shutdown_reason = "Trajectory decoding failed at ID"
    CALL shutdown_kawa
    RETURN
  END
  ;    
  .$temp = $DECODE(.$full_message, "|", 1)
  .$seq_num = $DECODE(.$full_message, "|", 0)
  .seq_num = VAL(.$seq_num)
  ;
  IF NOT .seq_num == seq_num_old + 1 THEN
    $shutdown_reason = "Sequence number of received trajectory points mismatch. Expected:" + $ENCODE(seq_num_old) + " but got:" + $ENCODE(.seq_num)
    CALL shutdown_kawa

    RETURN
  ELSE
    seq_num_old = .seq_num
  END
  ;  
  .$temp = $DECODE(.$full_message, "|", 1)
  .$prog_speed = $DECODE(.$full_message, "|", 0)
  .prog_speed = VAL(.$prog_speed)
    ;
  .$temp = $DECODE(.$full_message, "|", 1)
  .$prog_acc = $DECODE(.$full_message, "|", 0)
  .prog_acc = VAL(.$prog_acc)
    ;
  .$temp = $DECODE(.$full_message, "|", 1)
  .$prog_accel = $DECODE(.$full_message, "|", 0)
  .prog_accel = VAL(.$prog_accel)
   ; 
  .$temp = $DECODE(.$full_message, "|", 1)
  .$prog_decel = $DECODE(.$full_message, "|", 0)
  .prog_decel = VAL(.$prog_decel)
    ;
  .$temp = $DECODE(.$full_message, "|", 1)
  .$prog_break = $DECODE(.$full_message, "|", 0)
  .prog_break = VAL(.$prog_break)
    ;
  .$temp = $DECODE(.$full_message, "|", 1)
  .$joint0 = $DECODE(.$full_message, "|", 0)
  .joint0 = VAL(.$joint0)
    ;
  .$temp = $DECODE(.$full_message, "|", 1)
  .$joint1 = $DECODE(.$full_message, "|", 0)
  .joint1 = VAL(.$joint1)
    ;
  .$temp = $DECODE(.$full_message, "|", 1)
  .$joint2 = $DECODE(.$full_message, "|", 0)
  .joint2 = VAL(.$joint2) 
     ;
  .$temp = $DECODE(.$full_message, "|", 1)
  .$joint3 = $DECODE(.$full_message, "|", 0)
  .joint3 = VAL(.$joint3)
    ;
  .$temp = $DECODE(.$full_message, "|", 1)
  .$joint4 = $DECODE(.$full_message, "|", 0)
  .joint4 = VAL(.$joint4)
  ;  
  .$temp = $DECODE(.$full_message, "|", 1)

  .$joint5 = $DECODE(.$full_message, "|", 0)
  .joint5 = VAL(.$joint5)
   ; 
.END












.PROGRAM ins_rear_queue (.msg_id,.prog_speed,.prog_acc,.prog_accel,.prog_decel,.prog_break,.joint0,.joint1,.joint2,.joint3,.joint4,.joint5) ; 
; GOTO command is necessary because AS language does not support ifelse statements
  ;
IF queue_front == 1 AND queue_rear == queue_size -1 OR queue_front == queue_rear + 1 THEN ;Queue is full, shutdown
  $shutdown_reason = "Queue overload"
  CALL shutdown_kawa
  RETURN
END
IF queue_rear == 0 THEN ; Queue is empty, set front and rear pointers
  queue_rear = queue_rear + 1
  queue_front = queue_front + 1
  GOTO add_queue
END
IF queue_rear == queue_size - 1 AND queue_front > 1 THEN ;if the rear queue pointer is at max size, loop to front
  queue_rear = 1
  GOTO add_queue
ELSE ; Move the rear one back
  queue_rear = queue_rear + 1
  GOTO add_queue
END
  ;
add_queue:
queue[queue_rear, 0] = .msg_id
queue[queue_rear, 1] = .prog_speed 
queue[queue_rear, 2] = .prog_acc 
queue[queue_rear, 3] = .prog_accel 
queue[queue_rear, 4] = .prog_decel 
queue[queue_rear, 5] = .prog_break 
queue[queue_rear, 6] = .joint0 
queue[queue_rear, 7] = .joint1 
queue[queue_rear, 8] = .joint2 
queue[queue_rear, 9] = .joint3 
queue[queue_rear, 10]= .joint4 
queue[queue_rear, 11] = .joint5
;
exit:  
.END















.PROGRAM del_front_queue()
; GOTO command is necessary because AS language does not support ifelse statements
if queue_front == 0 THEN ;Queue is empty, nothing to delete
  GOTO exit
END
if queue_front == queue_rear AND queue_front != 0 THEN ; Queue has one object, reset queue
  queue_front =  0
  queue_rear =  0
  GOTO exit
END
if queue_front == queue_size - 1 THEN ; Front is at the rear of the circular queue, Loop front pointer of queue back to the front of the circular queue
  queue_front = 1
  GOTO exit
ELSE
  queue_front = queue_front + 1 ; Move front one back
  GOTO exit
END
exit:
  
.END



.PROGRAM goat()
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



.PROGRAM shutdown_kawa () ; 
    ;$shutdown_reason = "Something went wrong :( ERROR"
    ;PRINT $shutdown_reason
    ;PRINT $recv_tcp_serv_state
    ;PRINT $movement_state
  
  PRINT "Shutting down!"
  signal -keep_active_signal 
    
.END




.PROGRAM Comment___ () ; Comments for IDE. Do not use.
	; @@@ PROJECT @@@
	; @@@ HISTORY @@@
	; @@@ INSPECTION @@@
	; @@@ PROGRAM @@@
	; 0:init_kawa
	; 0:recv_tcp_serv
	; 0:send_pos_serv
	; 0:read_tcp_buffer
	; 0:encode_pose
	; 0:decode_traj_pt
	; 0:ins_rear_queue
	; 0:del_front_queue
	; 0:goat
	; 0:shutdown_kawa
	; @@@ TRANS @@@
	; @@@ JOINTS @@@
	; @@@ REALS @@@
	; @@@ STRINGS @@@
	; @@@ INTEGER @@@
	; @@@ SIGNALS @@@
	; @@@ TOOLS @@@
	; @@@ BASE @@@
	; @@@ FRAME @@@
	; @@@ BOOL @@@
.END