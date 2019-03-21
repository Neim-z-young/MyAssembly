.model small
.data 
    num_array dw 37,3,12,28,19,61,42,91,32,98,77,68,69
    array_length equ $-num_array
    radix_number DW 10
.stack
.code
main proc far
    mov ax,@data
    mov ds,ax

    lea bx,num_array
    mov cx,array_length
    mov si,0
    mov ax,0
begin:
    cmp ax,word ptr [bx+si]
    ja continue
    call judge_odd_and_change
continue: 
    add si,2
    cmp si,cx
    jb begin

    call decimal_print

    mov ah,4ch
    int 21h
main endp

judge_odd_and_change proc near
;input ax,bx,si
    push dx
    mov dx,word ptr[bx+si]
    shr dx,1
    jnc is_not_odd
    mov ax,word ptr[bx+si]
is_not_odd:
    pop dx
    ret
judge_odd_and_change endp

;****************************************************************************
; input:ax  
;      
; output: decimal number
decimal_print proc near  
  
    push cx   
    push dx
    mov cx,0  
push_stack:  
    mov dx,0  
    div radix_number  
      
    push dx  
    inc cx  
      
    cmp ax,0  
    jz pop_stack  
      
    jmp push_stack  
      
pop_stack:  
    pop dx  
    add dl,30h  
    mov ah,2              
    int 21h  
             
    loop pop_stack  
      
    pop dx
    pop cx    
      
    ret  
decimal_print endp  
;---------------------------------------------------------------------------
end main