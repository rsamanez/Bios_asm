[org 0x7c00]
  mov bp, 0x7c00 ; move to Program Memory Start
  mov sp,0x7f00  ; Set the Stack pointer
  ;change to Graphic Mode 300x200x256
  mov ah,0
  mov al,0x13
  int 0x10
  ; write Pixels Directly to memory
  mov bx,0xA000
  mov es,bx
  mov bx,64000
  mov cx,322
  mov si,0
  mov ax,0
loop:
  mov [es:si],ax
  inc si
  inc si
  inc al
  mov ah,al
  cmp si,bx
  je next
  cmp al,160
  je reset
  jmp loop
reset:
  mov ax,0
  jmp loop
next:
  call delay
  mov si,0
  ;add bx,3200
  ; cmp bx,64000
  ; je finish
  inc al
  mov ah,al
  jmp loop
finish:
  hlt
delay:
     push dx
     push cx
     push ax
     mov dx,0xA120
     mov cx,0x000F
     mov ah,0x86
     int 0x15
     pop ax
     pop cx
     pop dx
     ret


times 510-($-$$) db 0
dw 0xAA55
