;*****************************************
;宏定义打印字符串
print macro str_addr
      push dx
      push ax

      mov dx,offset str_addr
      mov ah,09h
      int 21h

      pop ax
      pop dx
      endm
;---------------------------------------- 

.model small
;音阶
n1LL equ 65
n2bLL equ 69
n2LL equ 73
n3bLL equ 78
n3LL equ 82
n4LL equ 87
n5bLL equ 92
n5LL equ 98
n6bLL equ 103
n6LL equ 110
n7bLL equ 116
n7LL equ 123

n1L equ 131
n2bL equ 139  
n2L equ 147
n3bL equ 156  
n3L equ 165 
n4L equ 175
n5bL equ 185  
n5L equ 196
n6bL equ 208  
n6L equ 220
n7bL equ 233 
n7L equ 247

n1 equ 262   ;C
n2b equ 277
n2 equ 294   ;D
n3b equ 311
n3 equ 330   ;E
n4 equ 349   ;F
n5b equ 370
n5 equ 392   ;G
n6b equ 415
n6 equ 440   ;A
n7b equ 466
n7 equ 494   ;B

n1H equ 523
n2bH equ 554
n2H equ 587
n3bH equ 622
n3H equ 659 
n4H equ 698
n5bH equ 740
n5H equ 784
n6bH equ 831
n6H equ 880
n7bH equ 932
n7H equ 988

n1HH equ 1046
n2bHH equ 1109
n2HH equ 1175
n3bHH equ 1244
n3HH equ 1318
n4HH equ 1397
n5bHH equ 1480
n5HH equ 1568
n6bHH equ 1661
n6HH equ 1760
n7bHH equ 1865
n7HH equ 1926
;时值，每小节2s，200*10ms
t1 equ 200  ;一小节
t2 equ 100  ;二分之一节
t3 equ 50  ;四分之一节
t4 equ 25   ;八分之一节
t5 equ 13   ;十六分之一节

;播放状态
STOP_MUSIC equ 0
PLAY_MUSIC equ 1
PAUSE_MUSIC equ 2


SPEED_STEP equ 500             ;速率步进值
SPEED_LOWER_BOUND equ 1500     ;速度最快
SPEED_UPPER_BOUND equ 7000     ;速度最慢

MUSIC_HEAD equ 1     ;第一首歌
MUSIC_TAIL equ 3     ;最后一首歌
.data
    present_status db STOP_MUSIC ;当前状态
    present_music db 1          ;当前音乐
    temp_present_music db 1     ;用来暂存音乐
    ;计数器频率
    timerFreH dw 12h
    timerFreL dw 348ch
    
    timerTwoInit db 10110110b   ;计数器初始化字节
    tenMSDelay dw 3000          ;标准速度
    soundTestF dw 247,262,294,330,350,392,440,494
               dw -1
    soundTestT dw 8 dup(50)

    TaihuLakeBoatF dw 330,392,330,294,330,392,330,294,330
                   dw 330,392,330,294,262,294,330,392,294
                   dw 262,262,220,196,196,220,262,294,330,262
                   dw -1
    TaihuLakeBoatT dw 3 dup(50),25,25,50,25,25,30
                   dw 2 dup(50,50,25,25),100
                   dw 3 dup(50,25,25),100

    BecauseOfLove1F dw 0,n5L,n6L,n1,n1,n6L,n1,n2
                    dw n3,n2,0,n1,n6L
                    dw n3,n2,n6L,n3,n2,0,n1
                    dw n1,n6L,0,n6L,n7L
                    dw n1,n1,n6L,n3,n3,n2
                    dw n3,n2,n2,n2,n3
                    dw n3
                    dw 0
                    dw 0,n5L,n6L,n1,n1,n6L,n1,n2
                    dw -1

    BecauseOfLove1T dw 8 dup(t4)
                    dw t4,t3+t4,t3,2 dup(t4)
                    dw 4 dup(t4),t3,2 dup(t4)
                    dw t4,t3+t4,t3,2 dup(t4)
                    dw 5 dup(t4),t3+t4
                    dw 2 dup(t4,t3),t3
                    dw t1
                    dw t1
                    dw 8 dup(t4)

    ;乐曲谱定义，此处省略大量乐谱定义
    HundouluoF dw n6H,n5H,n3H,n2H,n3H,n2H,n1H,n7,n1H,n7,n6,n5,n6,n2,n3,n5
               dw n6,n6,n3H,0,n2H,n3H,n5bH
               dw n5H,0                                        ;一小节里的全音符改为二分音符加四分休止符
               dw n6,n6,n3H,0,n2H,n3H,n5bH
               dw n1H,0
               dw n6,n6,n3H,0,n2H,n3H,n5bH
               dw n5H,0
               dw n6,n6,n3H,0,n2H,n3H,n5bH
               dw n1H,0
               dw n3H,0,n3H,n5bH,n5H,0,n5H,0,0
               dw n5bH,0,n4H,n5H,n6H,0,n6H,0,n5H,n6H
               dw n3H,0,n3H,n5bH,n5H,0,n5H,0,0
               dw n5bH,0,n4H,n5H,n6H,n2HH
               dw n7H,n6H,n5bHH,n3HH,n2HH,n2bHH,n7H,n6H,n7H,n6H,n5bH,n3H,n4H,n3H,n2H,n2bH
               dw n3,0,n3,n5b,n5,n7,0,n6,0,n5,n4,n2
               dw n3,0              
               dw n2b,n2,n3,n5b,n5,n6
               dw n7,n2bH,n2H,n3H,n5bH,n3H,n3,n5,n6
               dw n7,n6,n7,n3,0,n3,n5,n6,n7,n2H,n2bH,n2H,n1H,n6
               dw n7,0
               dw n2b,n2,n3,n5b,n5,n6                              ;6
               dw n7,n7,n7,0,n7,n2bH,n2H,n5bH,n3H                  ;9
               dw n2H,n2H,n2H,n2H,0,n2H,n2H,n2H,n2H,0,n2H,0,n2bH   ;13
               dw n7,n7,n7,n7,0,n7,n7,n7,n7,0,n7,0,n2bH            ;13
               dw n2H,n2H,n2H,n2H,0,n2H,n2H,n2H,n2H,0,n2H,0,n2bH   ;13
               dw n7,n7,n7,n7,0,n7,n2bH,n2H,n3H,n5bH,n3H,0,n1H     ;13
               dw n5bH,n4H,n4H,n4H,0,n4H,n4H,n4H,n4H,0,n4H,0,n3H   ;13
               dw n2H,n2H,n2H,n2H,0,n2H,n2H,n2H,n2H,0,n2H,0,n3H    ;13
               dw n5bH,n4H,n4H,n4H,0,n4H,n4H,n4H,n4H,0,n4H,0,n5H   ;13
               dw n6H,n6H,n6H,n6H,0,n6H,n6H,n6H,n6H,0,n3,n5,n6     ;13
               dw n7,n6,n7,n3,n3,n5,n6,n7,n6,n7,n2H,n2H,n2bH,n2H   ;14
               dw n7,n6,n7,n3,n3,n5,n6,0,n7,0,n2bH,0,n2H           ;13
               
               dw n6,n6,n3H,0,n2H,n3H,n5bH                         ;7
               dw n5H,0
               dw n6,n6,n3H,0,n2H,n3H,n5bH
               dw n1H,0
               dw n6,n6,n3H,0,n2H,n3H,n5bH
               dw n5H,0
               dw n6,n6,n3H,0,n2H,n3H,n5bH
               dw n1H,0
               dw n3H,0,n3H,n5bH,n5H,0,n5H,0,0
               dw n5bH,0,n4H,n5H,n6H,0,n6H,0,n5H,n6H
               dw n3H,0,n3H,n5bH,n5H,0,n5H,0,0
               dw n5bH,0,n4H,n5H,n6H,n2HH
               dw n7H,n6H,n5bHH,n3HH,n2HH,n2bHH,n7H,n6H,n7H,n6H,n5bH,n3H,n4H,n3H,n2H,n2bH
               dw n3,0,n3,n5b,n5,n7,0,n6,0,n5,n4,n2
               dw n3,0
               dw n2b,n2,n3,n5b,n5,n6
               dw n7,n2bH,n2H,n3H,n5bH,n3H,n3,n5,n6
               dw n7,n6,n7,n3,0,n3,n5,n6,n7,n2H,n2bH,n2H,n1H,n6
               dw n7,0
               dw n2b,n2,n3,n5b,n5,n6                              ;6
               dw n7,n7,n7,0,n7,n2bH,n2H,n5bH,n3H                  ;9
               dw n2H,n2H,n2H,n2H,0,n2H,n2H,n2H,n2H,0,n2H,0,n2bH   ;13
               dw n7,n7,n7,n7,0,n7,n7,n7,n7,0,n7,0,n2bH            ;13
               dw n2H,n2H,n2H,n2H,0,n2H,n2H,n2H,n2H,0,n2H,0,n2bH   ;13
               dw n7,n7,n7,n7,0,n7,n2bH,n2H,n3H,n5bH,n3H,0,n1H     ;13
               dw n5bH,n4H,n4H,n4H,0,n4H,n4H,n4H,n4H,0,n4H,0,n3H   ;13
               dw n2H,n2H,n2H,n2H,0,n2H,n2H,n2H,n2H,0,n2H,0,n3H    ;13
               dw n5bH,n4H,n4H,n4H,0,n4H,n4H,n4H,n4H,0,n4H,0,n5H   ;13
               dw n6H,n6H,n6H,n6H,0,n6H,n6H,n6H,n6H
               dw -1

    HundouluoT dw 16 dup(t5)
               dw t3,t4,3 dup(t5),t4,t5
               dw t2,t3
               dw t3,t4,3 dup(t5),t4,t5
               dw t2,t3
               dw t3,t4,3 dup(t5),t4,t5
               dw t2,t3
               dw t3,t4,3 dup(t5),t4,t5
               dw t2,t3
               dw t5,t5,2 dup(t4+t5),3 dup(t5),t3,t5
               dw t5,t5,2 dup(t4+t5),4 dup(t5),t5,t4+t5
               dw t5,t5,2 dup(t4+t5),3 dup(t5),t3,t5
               dw t5,t5,2 dup(t4+t5),t3,t3
               dw 16 dup(t5)
               dw t4+t5,t5,t5,t4,6 dup(t5),t4,t5
               dw t2,t3
               dw t3,t5,t4+t5,t3,t5,t4+t5
               dw t3,t5,t4,t5,t3,4 dup(t5)
               dw 8 dup(t5),t4,3 dup(t5),t4,t5
               dw t2,t3
               dw t3,t5,t4+t5,t3,t5,t4+t5
               dw 5 dup(t5),t4,t5,t3,t3
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,4 dup(t5),t4+t5,3 dup(t5) ;13
               dw 3 dup(t5),t4,6 dup(t5),t4,3 dup(t5)    ;14
               dw 3 dup(t5),t4,8 dup(t5),t4+t5
               
               dw t2,t4,3 dup(t5),t4,t5
               dw t2,t3
               dw t3,t4,3 dup(t5),t4,t5
               dw t2,t3
               dw t3,t4,3 dup(t5),t4,t5
               dw t2,t3
               dw t3,t4,3 dup(t5),t4,t5
               dw t2,t3
               dw t5,t5,2 dup(t4+t5),3 dup(t5),t3,t5
               dw t5,t5,2 dup(t4+t5),4 dup(t5),t5,t4+t5
               dw t5,t5,2 dup(t4+t5),3 dup(t5),t3,t5
               dw t5,t5,2 dup(t4+t5),t3,t3
               dw 16 dup(t5)
               dw t4+t5,t5,t5,t4,6 dup(t5),t4,t5
               dw t2,t3
               dw t3,t5,t4+t5,t3,t5,t4+t5
               dw t3,t5,t4,t5,t3,4 dup(t5)
               dw 8 dup(t5),t4,3 dup(t5),t4,t5
               dw t2,t3
               dw t3,t5,t4+t5,t3,t5,t4+t5
               dw 5 dup(t5),t4,t5,t3,t3
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,7 dup(t5),t4+t5
               dw 4 dup(t5),t4,4 dup(t5)

    SkyCityF dw n6,n7
             dw n1H,n7,n1H,n3H
             dw n7,n3
             dw n6,n5,n6,n1H
             dw n5,n2,n3
             dw n4,n3,n4,n1H
             dw n3,n2,n3,n1H
             dw n7,n5b,n5b,n7
             dw n7,n6,n7
             dw n1H,n7,n1H,n3H
             dw n7,n3
             dw n6,n5,n5,n1H
             dw n5,n3
             dw n4,n1H,n7,n7,n1H
             dw n2H,n3H,n1H,n1H
             dw n1H,n7,n6,n7,n6b
             dw n6,n1H,n2H
             dw n3H,n2H,n3H,n5H
             dw n2H,n5
             dw n1H,n7,n1H,n3H

             dw n3H
             dw n6,n7,n1H,n7,n1H,n2H
             dw n1H,n5,n5
             dw n4H,n3H,n2H,n1H
             dw n3H,n3H
             dw n6H,n5H
             dw n3H,n2H,n1H
             dw n2H,n1H,n2H,n2H,n5H
             dw n3H,n3H
             dw n6H,n5H
             dw n3H,n2H,n1H
             dw n2H,n1H,n2H,n2H,n7
             dw n6
             dw n6
             dw -1

    SkyCityT dw t4,t4
             dw t3+t4,t4,t3,t3
             dw t3+t3+t3,t3
             dw t3+t4,t4,t3,t3
             dw t3+t3+t3,t4,t4
             dw t3+t4,t4,t4,t3+t4
             dw t3+t4,t4,t4,t3+t4
             dw t3+t4,t4,t3,t3
             dw t3+t3+t3,t4,t4
             dw t3+t4,t4,t3,t3
             dw t3+t3+t3,t3
             dw t3+t4,t4,t3,t3
             dw t3+t3+t3,t3
             dw t3,t4,t4,t3,t3
             dw t3,t4,t4,t3+t3
             dw t4,t4,t3,t3,t3
             dw t3+t3+t3,t4,t4
             dw t3+t4,t4,t3,t3
             dw t3+t3+t3,t3
             dw t3+t4,t4,t3,t3

             dw t1
             dw t4,t4,t3,t4,t4,t3
             dw t3+t4,t4,t2
             dw t3,t3,t3,t3
             dw t3+t3+t3,t3
             dw t2,t2
             dw t4,t4,t3+t3+t3
             dw t3,t4,t4,t3,t3
             dw t3+t3+t3,t3
             dw t2,t2
             dw t4,t4,t3+t3+t3
             dw t3,t4,t4,t3,t3
             dw t1
             dw t2


    HesapiratesF dw 0,0,0
                 dw n6L,n6L,n6L,n6L
                 dw n6L,n6L,n6L,n3L,n5L
                 dw n6L,n6L,n6L,n7L
                 dw n1,n1,n1,n2
                 dw n7L,n7L,n6L,n5L
                 dw n5L,n6L,0,0,n3L,n5L
                 dw n6L,n6L,n6L,n7L
                 dw n1,n1,n1,n2
                 dw n7L,n7L,n6L,n5L
                 dw n6L,0,0,n3L,n5L
                 dw n6L,n6L,n6L,n1
                 dw n2,n2,n2,n3
                 dw n4,n4,n3,n2
                 dw n3,n6L,0,0,n6L,n7L
                 dw n1,n1,n2
                 dw n3,n6L,0,0,n6L,n1
                 dw n7L,n7L,n1,n6L
                 dw n7L,0,0,n3,n5
                 dw n6,n6,n6,n7
                 dw n1H,n1H,n1H,n2H

                 dw n7,n7,n6,n5
                 dw n5,n6,0,0,n3,n5
                 dw n6,n6,n6,n7
                 dw n1H,n1H,n1H,n2H
                 dw n7,n7,n6,n5
                 dw n6,0,0,n3,n5
                 dw n6,n6,n6,n1H
                 dw n2H,n2H,n2H,n3H
                 dw n4H,n4H,n3H,n2H
                 dw n3H,n6,0,0,n6,n7
                 dw n1H,n1H,n2H
                 dw n3H,n6,0,0,n6,n1H
                 dw n7,n7,n6,n6b
                 dw n6,n6,n7

                 dw n1H,n1H,n1H,n2H
                 dw n3H,n6,0,0,n1H,n6
                 dw n3,0,0,0
                 dw n4H,0,0,0,n1H,n6
                 dw n4,0,0,0
                 dw n3L,0,0,n6L,0,0      ;缩短三个低音的时间
                 dw n1,0,0,0,n6L,n7L
                 dw n3H,n3H,n3H
                 dw n4H,n3H,0,0

                 dw n2H,n2H,n2H
                 dw n2H,n3H,0,0
                 dw n3H,n3H,n3H
                 dw n4H,n3H,0,0
                 dw n2H,n1H,n7
                 dw n6,0,0,n6L,n7L
                 dw n1,n2,n3
                 dw n2,n1,n7L
                 dw n1,n2,n3
                 dw n2,0,0,n1,n2
                 dw n3,n2,n1
                 dw n7L,n1,n7L
                 dw n6L,n7L,n5L
                 dw n6L,n6,n7
                 dw n1H,n7,n1H
                 dw n2H,n1H,n2H
                 dw n3H,n2H,n1H

                 dw n6,0,0,n6,n7
                 dw n1H,n2H,n3H
                 dw n4H,n6,n2H     
                 dw n1H,0,n2H,n7  
                 dw n6,0,n7,n6b
                 dw n3H,0,0
                 dw n4H,0,0
                 dw n3H,n3H,n3H
                 dw n3H,n2H,0,0
                 dw n2H,0,0
                 dw n1H,0,0
                 dw n7,n1H,n7
                 dw n7,n6,0,n6,n7,n1H
                 dw n3H,0,0,n6,n7,n1H

                 dw n4H,0,0,n6,n7,n1H
                 dw n3H,n3H,n5H
                 dw n3H,n2H,0,0
                 dw n2H,0,0
                 dw n1H,0,0
                 dw n7,n1H,n7
                 dw n6,0,0

                 dw -1

    HesapiratesT dw t3,t3,t3
                 dw t3,t4,t3,t4
                 dw t3, 4 dup(t4)
                 dw t3,t3,t4,t4
                 dw t3,t3,t4,t4
                 dw t3,t3,t4,t4
                 dw 6 dup(t4)
                 dw t3,t3,t4,t4
                 dw t3,t3,t4,t4
                 dw t3,t3,t4,t4
                 dw t3,4 dup(t4)
                 dw t3,t3,t4,t4
                 dw t3,t3,t4,t4
                 dw t3,t3,t4,t4
                 dw 6 dup(t4)
                 dw t3,t3,t3
                 dw 6 dup(t4)
                 dw t3,t3,t4,t4
                 dw t3,4 dup(t4)
                 dw t3,t3,t4,t4
                 dw t3,t3,t4,t4

                 dw t3,t3,t4,t4
                 dw 6 dup(t4)
                 dw t3,t3,t4,t4
                 dw t3,t3,t4,t4
                 dw t3,t3,t4,t4
                 dw t3,4 dup(t4)
                 dw t3,t3,t4,t4
                 dw t3,t3,t4,t4
                 dw t3,t3,t4,t4
                 dw 6 dup(t4)
                 dw t3,t3,t3
                 dw 6 dup(t4)
                 dw t3,t3,t4,t4
                 dw t3,t3,t3

                 dw t3,t4,t4,t3
                 dw 6 dup(t4)
                 dw t4,t4,t4,t3
                 dw 6 dup(t4)
                 dw t4,t4,t4,t3
                 dw 6 dup(t4)       ;短音
                 dw 6 dup(t4)
                 dw t3,t3,t3
                 dw t4,t4,t4,t3

                 dw t3,t3,t3
                 dw t4,t4,t4,t3
                 dw t3,t3,t3
                 dw t4,t4,t4,t3
                 dw t3,t3,t3
                 dw t3,4 dup(t4)
                 dw t2,t4,t4
                 dw t3,t3,t3
                 dw t3,t3,t3
                 dw t3,4 dup(t4)
                 dw t2,t4,t4
                 dw t3,t3,t3
                 dw t2,t4,t4
                 dw t2,t4,t4
                 dw t2,t4,t4
                 dw t3,t3,t3
                 dw t3,t3,t3

                 dw t3,4 dup(t4)
                 dw t3,t3,t3
                 dw t3,t3,t3
                 dw t3,t4,t4,t3
                 dw t3,t4,t4,t3
                 dw t3,t4,t3
                 dw t3,t4,t3
                 dw t3,t3,t3
                 dw t4,t4,t4,t3
                 dw t3,t4,t3
                 dw t3,t4,t3
                 dw t3,t3,t3
                 dw 6 dup(t4)
                 dw 6 dup(t4)

                 dw 6 dup(t4)
                 dw t3,t3,t3
                 dw t4,t4,t4,t3
                 dw t3,t4,t3
                 dw t3,t4,t3
                 dw t3,t3,t3
                 dw t3,t4,t3


    TwotigerF dw 262,294,330,262,262,294,330,262
              dw 330,349,392,392,330,349,392,392
              dw 392,440,392,349,330,262,392,440,392,349,330,262
              dw 294,196,262,262,294,196,262,262
              dw -1
    TwotigerT dw 8 dup(50)
              dw 8 dup(50)
              dw 2 dup(25,25,25,25,50,50)
              dw 8 dup(50)
    Menu db "************ Welcome to OYoungY's MusicPlayer ************",0dh,0ah
         db "*********** Chose the music you want to listen ***********",0dh,0ah
         db "*                                                        *",0dh,0ah
         db "*                  1.Hundouluo                           *",0dh,0ah
         db "*                  2.Sky City                            *",0dh,0ah
         db "*                  3.He's a pirate                       *",0dh,0ah
         db "*                                                        *",0dh,0ah
         db "********************* Function Key ***********************",0dh,0ah
         db "*             A:play            S:stop                   *",0dh,0ah
         db "*             P:pause           E:exit                   *",0dh,0ah
         db "*             I:speed up        K:slow down              *",0dh,0ah
         db "*             J:next            L:previous               *",0dh,0ah
         db "*                                                        *",0dh,0ah
         db "**********************************************************",0dh,0ah,'$'
    Present_sta_stop db "**     Present status: STOPED ",'$'
    Present_sta_paused db "**     Prsent status:  PAUSED ",'$'
    Present_sta_playing db "**     Prsent status:  PLAYING ",'$'
    Music_one_string db "Hundouluo",0dh,0ah,'$'
    Music_two_string db "Sky City",0dh,0ah,'$'
    Music_three_string db "He's a pirate",0dh,0ah,'$'
.stack
.code 
main proc far
    mov ax,@data
    mov ds,ax
    ;打印菜单
    call clearScreen
    ;置光标位置
    mov dh,0
    mov dl,0
    mov bh,0
    mov ah,2
    int 10h

    print ds:Menu
    print ds:Present_sta_stop
    lea si,HundouluoF
    lea bp,HundouluoT
playing_music:
    ;监测键盘事件
    mov dl,0ffh
    mov ah,6h
    int 21h
    cmp al,0
    je goto_after_print
    cmp al,'e'
    je goto_end_mus
    cmp al,'s'
    jne change_status_to_pause
    mov dl,STOP_MUSIC
    mov present_status,dl
    jmp print_status
change_status_to_pause:
    cmp al,'p'
    jne change_status_to_playing
    mov dl,PAUSE_MUSIC
    mov present_status,dl
    jmp print_status
change_status_to_playing:
        cmp al,'a'
        jne choose_music_one
        mov present_status,1
        jmp print_status
    choose_music_one:
        cmp al,'1'
        jne choose_music_two
        mov dl,1
        mov present_music,1
        mov present_status,1
        jmp print_status
    choose_music_two:
        cmp al,'2'
        jne choose_music_three
        mov dl,2
        mov present_music,2
        mov present_status,1
        jmp print_status
    choose_music_three:
        cmp al,'3'
        jne choose_function_keys
        mov dl,3
        mov present_music,3
        mov present_status,1
        jmp print_status
    choose_function_keys:
        cmp al,'l'
        jne change_music_to_previous
        mov dl,present_music
        cmp dl,MUSIC_TAIL
        jne not_reset_to_one
        mov dl,MUSIC_HEAD-1           ;重置为1
    not_reset_to_one:
        inc dl
        mov present_music,dl
        jmp print_status
;********************
;转接代码区域
goto_end_mus:
    jmp end_mus
goto_after_print:
    jmp after_print
;--------------------
change_music_to_previous:
        cmp al,'j'
        jne change_speed_down
        mov dl,present_music
        cmp dl,MUSIC_HEAD
        jne not_reset_to_three
        mov dl,MUSIC_TAIL+1          ;重置为3
    not_reset_to_three:
        dec dl
        mov present_music,dl
        jmp print_status
change_speed_down:
        cmp al,'k'
        jne change_speed_up
        mov dx,tenMSDelay
        cmp dx,SPEED_UPPER_BOUND
        jne speed_still_down
        mov dx,SPEED_UPPER_BOUND-SPEED_STEP
    speed_still_down:
        add dx,SPEED_STEP
        mov tenMSDelay,dx
        jmp after_print
change_speed_up:
        cmp al,'i'
        jne press_other_keys
        mov dx,tenMSDelay
        cmp dx,SPEED_LOWER_BOUND
        jne speed_still_up
        mov dx,SPEED_LOWER_BOUND+SPEED_STEP
    speed_still_up:
        sub dx,SPEED_STEP
        mov tenMSDelay,dx
        jmp after_print
press_other_keys:
        jmp after_print

print_status:
    mov dl,present_music
    cmp dl,temp_present_music
    je not_call_loadMusic
    call loadMusic     ;加载新音乐
not_call_loadMusic:
    call clearLine
    ;打印状态
    mov al,present_status
    cmp al,STOP_MUSIC
    jne print_pause_status
    print ds:Present_sta_stop
    jmp print_present_music
print_pause_status:
    cmp al,PAUSE_MUSIC
    jne print_playing_status
    print ds:Present_sta_paused
    jmp print_present_music
print_playing_status:    
    print ds:Present_sta_playing
    jmp print_present_music
print_present_music:
    mov al,present_music
    cmp al,1
    jne print_music_two
    print ds:Music_one_string
    jmp after_print   
print_music_two:
    cmp al,2
    jne print_music_three
    print ds:Music_two_string
    jmp after_print
print_music_three:
    print ds:Music_three_string
    jmp after_print

;*******************
;转接代码区域
goto_next_music:
    push cx
    ;切歌延迟2000ms
    mov cx,200
switch_music_delay:
    push cx    
    mov cx,5000
    call waitf
    pop cx
    loop switch_music_delay
    mov al,'l'
    pop cx
    jmp choose_function_keys
;-------------------

after_print:
    mov al,present_status
    cmp al,STOP_MUSIC
    je reset_play_music
    cmp al,PAUSE_MUSIC
    je pause_the_music
    ;播放
    mov di,[si]
    cmp di,-1
    je goto_next_music
    mov bx,ds:[bp]  ;bp前要加段标志
    call soundOut
    add si,2
    add bp,2
    jmp store_music_information
reset_play_music:
    call loadMusic
    mov present_status,PAUSE_MUSIC
    jmp store_music_information
pause_the_music:
    jmp store_music_information
store_music_information:
    ;存储音乐信息
    mov dl,present_music
    mov temp_present_music,dl
    jmp playing_music
end_mus:
    
    mov ax,4c00h
    int 21h
main endp

;(cx) = count of 15.08 miu second
waitf proc near
    push ax
waitf1:
    in al,61h
    and al,10h
    cmp al,ah
    je waitf1
    mov ah,al
    loop waitf1
    pop ax
    ret
waitf endp

;soundOut,delay = 10 ms
; input (di) = frequence,(bx) = counts of 10ms
soundOut proc near
    push ax
    push bx
    push cx
    push dx
    push di

    ;遇到休止符,不发声
    cmp di,0
    je silent_delay


    mov al,timerTwoInit
    out 43h,al
    mov dx,timerFreH
    mov ax,timerFreL
    div di
    out 42h,al
    mov al,ah
    out 42h,al
    
    in al,61h
    mov ah,al
    or al,3
    out 61h,al
    ;发声延续
counts_of_ten_ms:
    mov cx,tenMSDelay
    call waitf
    dec bx
    jnz counts_of_ten_ms
    
    mov al,ah
    out 61h,al
    ;延迟10ms
    mov cx,1
delay_a_little_time:
    push cx
    mov cx,tenMSDelay
    call waitf
    pop cx
    loop delay_a_little_time
    
    jmp exit_soundOut
;无声
silent_delay:
    mov cx,tenMSDelay
    call waitf
    dec bx
    jnz silent_delay

exit_soundOut:
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
soundOut endp

clearScreen proc near
    push ax
    push bx
    push cx
    push dx

    ;清屏
    mov ah,6
    mov al,0
    mov bh,7
    mov ch,0
    mov cl,0
    mov dh,24
    mov dl,79
    int 10h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
clearScreen endp

;清除光标当前行及上一行，并移动光标至上一行
clearLine proc near
    push ax
    push bx
    push cx
    push dx

    ; mov bh,0
    ; mov ah,2
    ; int 10h

    mov al,0
    mov bh,7
   ;固定位置
    mov dh,15
    mov ch,14
    mov dl,79
    mov cl,0
    mov ah,7
    int 10h
    
    mov dh,14
    mov dl,0
    mov bh,0
    mov ah,2
    int 10h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
clearLine endp
;input si,bp,present_music
loadMusic proc near
    push ax
    mov al,present_music
    cmp al,1
    jne loadMusic_two
    lea si,HundouluoF
    lea bp,HundouluoT
    jmp exit_loadMusic
loadMusic_two:
    cmp al,2
    jne loadMusic_three
    lea si,SkyCityF
    lea bp,SkyCityT
    jmp exit_loadMusic
loadMusic_three:
    cmp al,3
    jne exit_loadMusic
    lea si,HesapiratesF
    lea bp,HesapiratesT
    jmp exit_loadMusic
exit_loadMusic:
    pop ax
    ret
loadMusic endp
end main