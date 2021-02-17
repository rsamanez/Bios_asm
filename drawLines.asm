[org 0x7c00]
  mov bp, 0x7c00 ; move to Program Memory Start
  mov sp,0x7f00  ; Set the Stack pointer
  ;change video to Graphic Mode 320x200x256
  mov ah,0
  mov al,0x13
  int 0x10
  ; set video memory segngment to ES register
  mov bx,0xA000
  mov es,bx
  ;----------------------------------------
  ; draw a line
  mov cl,5  ; color line
  mov bx,0
  mov ax,0   ; start line at (0,0)
nextpixel:
  call drawpixel
  inc bx
  inc bx
  inc ax
  cmp bx,200
  je mode2
  jmp nextpixel
mode2:
  ; draw line using subrutine  20,20 -->  200,200
  mov [linedata],word 0
  mov [linedata+2],word 0
  mov [linedata+4],word 100
  mov [linedata+6],word 200
  mov [linedata+8],word 6   ; color 6
  call drawline
  mov [linedata],word 0
  mov [linedata+2],word 0
  mov [linedata+4],word 200
  mov [linedata+6],word 200
  mov [linedata+8],word 6   ; color 6
  call drawline
  mov [linedata],word 0
  mov [linedata+2],word 0
  mov [linedata+4],word 50
  mov [linedata+6],word 200
  mov [linedata+8],word 6   ; color 6
  call drawline
  mov [linedata],word 0
  mov [linedata+2],word 0
  mov [linedata+4],word 25
  mov [linedata+6],word 200
  mov [linedata+8],word 6   ; color 6
  call drawline
  mov [linedata],word 0
  mov [linedata+2],word 0
  mov [linedata+4],word 12
  mov [linedata+6],word 200
  mov [linedata+8],word 6   ; color 6
  call drawline
  jmp $

; Rutine to Draw Pixel(x,y,color) x=bx,y=ax color=cl
drawpixel:  
    push ax
    imul ax,320  ; y = y*320
    add ax,bx    ; ax = y + x
    mov si,ax
    mov [es:si],byte cl
    pop ax
    ret
; Rutine to draw Line(x1,y1,x2,y2,color) (x1,y1)-->(x2,y2) color=cl
; data in linedata:         
drawline:
  ;  dx = x2 - x1
  ;  dy = y2 - y1
  ;  m  = dy / dx
  ;  xi = x0 + dx
  ;  yi = y0 + m(dx)
  push ax
  push bx
  push cx
  push dx
  mov ax,[linedata]  ; ax <-- x1
  mov bx,[linedata+4] ; bx <-- x2
  sub bx,ax           ; dx = x2-x1
  push bx             ; dx --> stack
  mov ax,[linedata+2] ; ax <-- y1
  mov bx,[linedata+6] ; bx <-- y2
  sub bx,ax           ; dy = y2 -y1
  mov ax,bx           ; ax <-- dy
  pop bx              ; bx <-- dx
  div bx              ; al <-- dy / dx
  push ax             ; m --> stack
  mov bx,[linedata]   ; bx <-- x1
  mov ax,[linedata+2] ; ax <-- y1
  mov cx,[linedata+8] ; cl <-- color
  pop dx              ; dl <-- m
_nextPixel:
  call drawpixel
  inc bx
  cmp bx,[linedata+4]
  je lineComplete
  add ax,dx
  jmp _nextPixel
lineComplete:
  pop dx
  pop cx
  pop bx
  pop ax
  ret
linedata: 
  dw 0x0000,0x0000,0x0000,0x0000,0x0000 ; x1,y1,x2,y2,color




    ; si = x+320*y
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
