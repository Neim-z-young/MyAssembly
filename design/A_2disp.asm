

.model small
.data 
    text db 'Welcome to CSU'
    text_len equ $-text
    columns dw 80
    rows dw 25
    colors dw 16
    front_color db 00000101B
    cursor_x db 40
    cursor_y db 10
.stack 
.code 
main proc far
    mov ax,@data
    mov ds,ax
    lea bx,text
continue:
    ;随机数
    push bx
    
    mov bx,rows
    call rand
    mov cursor_y,bl
    
    push cx
    mov cx,65535
waiting0:
    push cx
    mov cx,30
waiting1:
    loop waiting1
    pop cx
    loop waiting0
    pop cx

    ;清屏
    mov ah,6
    mov al,0
    mov bh,7
    mov ch,0
    mov cl,0
    mov dh,24
    mov dl,79
    int 10h

    mov bx,columns
    call rand
    mov cursor_x,bl

    push cx
    mov cx,143
delay:
    loop delay
    pop cx

    mov bx,colors
    call rand
    
    mov front_color,bl
    pop bx
    
    
    ;设置字符串属性
    ;显示字符串
    mov bp,seg text
    mov es,bp
    mov bp,offset text
    mov cx,text_len
    mov dh,cursor_y
    mov dl,cursor_x
    mov bh,0
    mov al,0
    mov bl,front_color
    mov ah,13h
    int 10h
    
    ;判断键入
    mov ah,0bh
    int 21h
    cmp al,00
    jz continue
exit:
    mov ax,4c00h
    int 21h
main endp

rand proc near
    ;用时钟计数低8位循环位移后，除以最大值所得的余数作为随机数
    ;input bx
    ;return bx
    push ax 
    push cx
    push dx  
    ;(1) 
    mov ah,0
    int 1ah   ;时钟计数

    mov ax,dx  
    mov cl,dl
    rcr ax,cl
    mov dx,0

    div bx
    mov bx,dx

    pop dx
    pop cx
    pop ax
    ret
rand endp

end main