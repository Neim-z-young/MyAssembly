.model small
.data 
    year dw 0
    year_4 dw 4
    year_100 dw 100
    year_400 dw 400
    radix_number db 10
    text_yes db 0dh,0ah,'Yes','$'
    text_no db 0dh,0ah,'No','$'
    maxLen db 10
    actLen db ?
    buffer db 10 dup(?)
.stack
.code
main proc far
    mov ax,@data
    mov ds,ax
    ;输入数字，以换行符结尾
    lea dx,maxlen
    mov ah,0ah
    int 21h
    lea bx,buffer
    mov cx,0
    mov cl,actLen
    call decimal_str_to_num
    mov year,ax
    cwd
    div year_400
    cmp dx,0
    je is_a_leap
    mov ax,year
    cwd
    div year_4
    cmp dx,0
    jne isnt_a_leap
    mov ax,year
    cwd
    div year_100
    cmp dx,0
    jne is_a_leap
isnt_a_leap:
    lea dx,text_no
    mov ah,09h
    int 21h
    jmp exit
is_a_leap:
    lea dx,text_yes
    mov ah,09h
    int 21h
exit:
    mov ax,4c00h
    int 21h
main endp
decimal_str_to_num proc near
    ;不能判断负数
    ;input: bx(buffer)
    ;       cx(actLen)
    ;output: ax
    push dx
    push si
    mov ax,0
    mov si,0
continue_conv:
    mov dx,0
    mov dl,byte ptr[bx+si]
    ;字符串末尾为换行符
    cmp dx,0ah
    je end_of_str
    mul radix_number
    mov dl,byte ptr[bx+si]
    sub dx,30h
    add ax,dx   
    inc si
    cmp si,cx
    jb continue_conv
end_of_str:
    pop si
    pop dx
    ret
decimal_str_to_num endp
end main