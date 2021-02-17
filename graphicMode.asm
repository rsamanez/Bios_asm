[org 0x7c00]
  mov bp, 0x7c00 ; move to Program Memory Start
  mov sp,0x7f00  ; Set the Stack pointer
  ;change to Graphic Mode 300x200x256
  mov ah,0
  mov al,0x13
  int 0x10
  ; write Pixels by Pixel
  mov bx,3; lines by color
  mov al,0   ; color inicial
  mov cx,0   ; x=0
nextLine:
  mov dx,0   ; y=0
loop:
  mov ah,0x0C
  push bx
  mov bh,0   ; set page0
  int 0x10
  pop bx
  inc dx     ; y++
  cmp dx,200
  je loop2
  jmp loop
loop2:
  inc cx     ; x++
  cmp bx,cx
  je loop3
  jmp nextLine
loop3:
  call delay
  inc al     ; next color
  add bx,3   
  cmp bx,321
  je reset
  jmp nextLine
reset:
  ;hlt
  mov bx,3
  mov cx,0
  jmp nextLine

delay:
     push dx
     push cx
     push ax
     mov dx,0xA120
     mov cx,0x0001
     mov ah,0x86
     int 0x15
     pop ax
     pop cx
     pop dx
     ret


times 510-($-$$) db 0
dw 0xAA55
