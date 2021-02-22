DATANUM0 equ 0x8200
DATANUM1 equ 0x8416
DATANUM2 equ 0x862C
DATANUM3 equ 0x8842
DATANUM4 equ 0x8A58
DATANUM5 equ 0x8C6E
DATANUM6 equ 0x8E84
DATANUM7 equ 0x909A
DATANUM8 equ 0x92B0
DATANUM9 equ 0x94C6
[org 0x7e00]
  mov bp, 0x7c00 ; stack pointer base
  mov sp,0x7df0  ; stack pointer head
  ;change video to Graphic Mode 320x200x256
  mov ah,0
  mov al,0x13
  int 0x10
  ; set video memory segngment to ES register
  mov bx,0xA000
  mov es,bx
  ;----------------------------------------
  ; draw nuber 
  mov cx,0xFF00
  mov bl,5
  mov dx,30670
again:
  call printInteger  ; DX=Position , CX=number to print, BL=number of digits
  call delay2
  inc cx   ; numero a mostrar
  jz continue
  jmp again  

continue:
  mov cx,0
  push cx
nextProcess:
  mov bl,5
  mov dx,30670
  call printInteger

  mov dx,10
  mov cx,0
  mov cl,[hours]
  mov bl,1
  call printInteger

  mov cl,[color]
  mov dx,70
  call printColon

  mov dx,140
  mov cx,0
  mov cl,[minutes]
  mov bl,2
  call printInteger

  mov cl,[color]
  mov dx,200
  call printColon

  mov dx,270
  mov cx,0
  mov cl,[seconds]
  mov bl,2
  call printInteger  

  call delay

  mov cl,0
  mov dx,70
  call printColon
  mov dx,200
  call printColon

  call delay
  pop cx
  inc cx   ; numero a mostrar
  push cx
  mov al,[seconds]
  inc al
  cmp al,60
  je changeMinutes
  mov [seconds],al
  jmp nextProcess
changeMinutes:
  ; changing color
  mov al,[color]
  inc al
  cmp al,16
  jne setColor
  mov al,1
setColor:
  mov [color],al
  ;---------------
  mov al,0
  mov [seconds],al
  mov al,[minutes]
  inc al
  cmp al,60
  je changeHours
  mov [minutes],al
  jmp nextProcess
changeHours:
  mov al,0
  mov [minutes],al
  mov al,[hours]
  inc al
  cmp al,10
  je resetHours
  mov [hours],al
  jmp nextProcess
resetHours:
  mov al,0
  mov [hours],al
  jmp nextProcess





; --------------------------------------------------------------------
; Functions Definitions
; --------------------------------------------------------------------
printInteger: ; DX=Position , CX=number to print, BL=number of digits
  ; mov dx,30670
  mov [data01],dx
  mov [data02],bl
  push ax
  push bx
  push cx
  push dx
nextIntDigit:
  mov dx,0
  mov ax,cx
  mov bx,10
  div bx
  mov cx,ax
  mov ax,dx
  mov bx,0x216
  mul bx
  push ax
  mov ax,DATANUM0
  pop bx
  add ax,bx
  mov bx,ax
  mov ax,89
  mov dx,[data01]
  call printNumber

  mov al,[data02]
  dec al
  jz endPrintInteger
  mov [data02],al
  mov ax,[data01]
  sub ax,50
  mov [data01],ax
  jmp nextIntDigit

endPrintInteger:
  pop dx
  pop cx
  pop bx
  pop ax
  ret

data01:
  dw 0x0000
data02:
  db 0x05   ; number of digits to print



printColon: ; send color in CL, position dx
  push ax
  push bx
  push dx
  mov bl,2
  push dx
  push dx
  add dx,8000 ; 20480
jp05:
  mov al,8
jp04:
  mov ah,8
jp02:
  mov si,dx
  mov [es:si],byte cl
  dec ah
  jz jp01
  inc dx
  jmp jp02
jp01:
  add dx,313
  dec al
  jz jp03
  jmp jp04
jp03:
  pop dx
  add dx,20480
  dec bl
  jz jp06
  jmp jp05
jp06:
  pop dx
  pop bx
  pop ax
  ret

printNumber:
  push ax
  push bx
  push cx
  push dx
loop3:
  cmp ax,0
  je finishNumber
  dec ax
  push ax
  mov cl,6
loop2:
  mov al,[bx]
  mov ah,8
loop1:
  mov ch,0     ; color black
  rcr al,1
  jnc black
  mov ch,[color]
black:
  mov si,dx
  mov [es:si],byte ch
  inc dx
  dec ah
  jz nextbyte
  jmp loop1
nextbyte:
  dec cl
  jz nextline
  inc bx
  jmp loop2
nextline:
  add dx,272
  inc bx
  pop ax
  jmp loop3
finishNumber:
  pop dx
  pop cx
  pop bx
  pop ax
  ret

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

delay2:
     push dx
     push cx
     push ax
     mov dx,0xA120
     mov cx,0x0000
     mov ah,0x86
     int 0x15
     pop ax
     pop cx
     pop dx
     ret
hours:
  db 0
minutes:
  db 0
seconds:
  db 0


color:
  db 0x02
times 1024-($-$$) db 0