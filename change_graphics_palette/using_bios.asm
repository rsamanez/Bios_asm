[org 0x7c00]
    mov bp, 0x7c00 ; stack pointer base
    mov sp,0x7df0  ; stack pointer head
    ; changing to graphics mode 13h 320x200x256
    mov ah,0
    mov al,0x13
    int 0x10
    ; set video memory segngment to ES register
      mov bx,0xA000
      mov es,bx
;=================================================================
    ; showing the current color palette
    ; 32x8 = 256
    mov bx,0
    mov si,bx
    mov cl,0
newRow:    
    mov ah,10 ; 10 rows by color
newColor:
    mov al,10 ; 10 pixel by color
nextPixel:
    mov [es:si],byte cl
    inc si
    dec al
    jz nextColor
    jmp nextPixel
nextColor:
    inc cl
    jz checkfinish  ; go to finish after print 256 colors
loop01:
    inc bl
    cmp bl,32
    je nextRow
    jmp newColor
nextRow:
    mov bx,0
    dec ah
    jz newRow
    push ax
    mov ah,0
    mov al,cl
    sub ax,32
    mov cl,al
    pop ax
    jmp newColor

checkfinish:
    cmp ah,1
    je finish
    jmp loop01
finish:
;=================================================================
; Changing the Palette color
    mov dl,2 ; number of palletes definitions
    mov dh,60 ; red color value (0-63, not 0-255!)
    mov ch, 0 ; green color component (0-63)
    mov cl,30 ; blue color component (0-63)
newPallete:
    call delay
    mov bx,1 ; color number 0 (usually background, black)
nextColorPallete:
    mov ax,1010h ; Video BIOS function to change palette color
    int 10h ; Video BIOS interrupt
    call delay2
    inc bx
    cmp bx,256
    je newPalette
    jmp nextColorPallete
newPalette:
    mov dh,0
    mov ch,63
    mov cl,0
    dec dl
    je endOfprocess
    jmp newPallete
endOfprocess:
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

times 510-($-$$) db 0
dw 0xAA55
