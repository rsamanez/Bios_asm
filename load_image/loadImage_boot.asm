PROGRAM_SPACE equ 0x7e00
[org 0x7c00]
mov [BOOT_DISK],dl  ; after boot dl save the BOOT_DISK value
mov bx,bootDiskNumber
call PrintString
mov bl,[BOOT_DISK]
call PrintHex
call PrintNL
mov bp, 0x7c00 ; stack pointer base
mov sp,0x7df0  ; stack pointer head
push bx        ; push to stack the [BOOT_DISK]
;Loading the program from Disk --> 2 sectors program 
mov ah,0x02   ; read sectors service
mov al,2     ; number of sectors to read, only read the program NO the data
mov ch,0      ; cilinder to read
mov cl,2      ; initial sector number to read
mov dh,0      ; head to read
mov dl,[BOOT_DISK]     ; read from Boot Disk
mov bx,0
mov es,bx     ; ES =0
mov bx,PROGRAM_SPACE ; ES:BX  <--- Memory to read
int 0x13
jc errorReading ; jump if Carry set
; Jump to the program read from disk
mov bx,programLoaded
call PrintString
call PrintNL
call PrintNL
call delay
jmp PROGRAM_SPACE

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
delay: ; 5 seconds
     push dx
     push cx
     push ax
     mov dx,0x9680
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
programLoaded:
  db "The Program was Loaded...[WAIT]",0
bootDiskNumber:
  db "Boot Disk Number:",0
times 510-($-$$) db 0
dw 0xAA55
