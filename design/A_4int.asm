;*****************************************
;宏定义打印字符串
print macro str_addr
      push dx
      push ds 
      push ax

      mov dx,offset str_addr
      mov ax,seg str_addr
      mov ds,ax
      mov ah,09h
      int 21h

      pop ax
      pop ds
      pop dx
      endm
;---------------------------------------- 

StSeg SEGMENT STACK
    DB 64 dup (?)
StSeg ENDS
CodeSg SEGMENT
    ASSUME CS: CodeSg
    ORG 0100H
Main:
    JMP Load
    old_int_nine DD ? ;存放原来的int 9 handle
    full_screen_D db 1999 dup('D'),'$'   ;全屏D字符串, 共25*80 -1个字符
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

disp_D proc near
    
    call clearScreen
    ;置光标位置
    mov dh,0
    mov dl,0
    mov bh,0
    mov ah,2
    int 10h
    
    print full_screen_D
    ret
disp_D endp 

new_int_nine_proc PROC    ;新中断
    PUSH AX

    IN AL,60H
    CMP AL,0a0h 
    jne final
    call disp_D
final:
    POP AX
    JMP CS:old_int_nine
new_int_nine_proc ENDP

    ASSUME CS:CodeSg,DS:CodeSg
Load PROC NEAR
    push CS
    pop DS
    MOV AH,35H    ;Get Interrupt Vector
    MOV AL,09H
    INT 21H
    MOV WORD PTR old_int_nine,BX
    MOV AX,ES
    MOV WORD PTR old_int_nine+2,AX
    MOV AH,25H    ;Set Interrupt Vector
    MOV AL,09H
    MOV DX,OFFSET new_int_nine_proc
    INT 21H
    MOV DX,(OFFSET Load-OFFSET CodeSg)
    ADD DX,15
    MOV CL,4
    SHR DX,CL
    MOV AH,31H                   ;程序退出并驻留内存
    INT 21H
Load ENDP
CodeSg ENDS
    END Main