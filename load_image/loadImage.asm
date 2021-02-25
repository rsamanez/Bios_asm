DATA_SPACE equ 0x200
[org 0x7e00]
  pop dx         ; get the [BOOT_DISK] from the old stack
  mov [BOOT_DISK],dl
  mov bp, 0x7c00 ; stack pointer base
  mov sp,0x7df0  ; stack pointer head
  mov bl,[BOOT_DISK]
  call PrintHex
  call PrintNL
; Load the Image data ==>  127 sectors of Disk
  mov ah,0x02   ; read sectors service
  mov al,127     ; number of sectors to read, only read the program NO the data
  mov ch,0      ; cilinder to read
  mov cl,4      ; initial sector number to read
  mov dh,0      ; head to read
  mov dl,[BOOT_DISK]     ; read from Boot Disk
  mov bx,0x800
  mov es,bx     ; ES =0
  mov bx,DATA_SPACE ; ES:BX  <--- Memory to read  0x8200
  int 0x13
  jc errorReading ; jump if Carry set
  ;change video to Graphic Mode 320x200x256
  mov ah,0
  mov al,0x13
  int 0x10
  ; set video memory segngment to ES register
  mov bx,0xA000
  mov es,bx
  mov bx,0
  mov si,bx
  ;----------------------------------------
  ;  START to show the Image
  mov bx,0x800
  mov ds,bx
  mov ax,64000
  mov bx,0x200
nextPixel:
  mov cl,[ds:bx] ; read pixel from image
  mov [es:si],byte cl
  inc si
  inc bx
  dec ax
  jz loadPalette
  jmp nextPixel
loadPalette:
  call delay
  call delay
  call delay
  mov bx,0x1700
  mov es,bx
  mov bx,0xC00     ; first pallete color byte
  mov si,bx        ; ES:SI <-- color data  0x17C00
  mov bx,0         ; palete color number 0..255
nextPalette:
  mov ah,[es:si]
  inc si
  shr ah,2  ; red color value (0-63, not 0-255!)
  mov dh,ah 
  mov ah,[es:si]
  inc si
  shr ah,2  ; green color component (0-63)
  mov ch, ah 
  mov ah,[es:si]
  inc si
  shr ah,2  ; blue color component (0-63)
  mov cl,ah 
  mov ax,1010h ; Video BIOS function to change palette color
  int 10h ; Video BIOS interrupt
  inc bx
  cmp bx,256
  je finish
  jmp nextPalette
finish:
  hlt






; --------------------------------------------------------------------
; Functions Definitions
; --------------------------------------------------------------------
errorReading:
  mov bx,errorReadingMessage
  call PrintString
  hlt

PrintString:
  push ax
  push bx
	mov ah, 0x0e
loop:
  cmp [bx], byte 0
	je exit
	mov al,[bx]
	int 0x10
	inc bx
	jmp loop
exit:
  pop bx
  pop ax
	ret

PrintHex:
        push ax
        mov al,bl
        and al,0xF0
        ror al,4
        add al,0x30   ; add the ascii 0
        mov ah,0x0e
        int 0x10
        mov al,bl
        and al,0x0F
        add al,0x30   ; add the ascii 0
        mov ah,0x0e
        int 0x10
        pop ax
        ret

PrintNL:
        push ax
        mov ah, 0x0e
        mov al,0xa
        int 0x10
        mov al,0xd
        int 0x10
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

BOOT_DISK:
  db 0
errorReadingMessage:
  db "ERROR: Disk data could not be read.",0
times 1024-($-$$) db 0