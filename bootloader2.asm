[org 0x7c00]
mov bp, 0x7c00
mov sp,0x7f00
selectDisplayActivePage:
   mov ah,0x05
   mov al,0x01   ; page=1
   int 0x10
hideCursor:
   mov ah,0x01
   mov cx,0x2607
   int 0x10
   mov bx,CheckDrire
   call PrintString
chekhhd:
   ; clc
   ; mov ah,0x10
   ; mov dl,0x80
   ; int 0x13
   ; jc  hdd_error
writeToHHD:
   mov ah,0x03
   mov al,1    ; number of sectors to write
   mov ch,0    ; low 8 bits Cylinder starting in 0
   mov cl,1    ; sector number start in 1 to 63
   mov dh,0    ; head number starting in 0
   mov dl,0x80  ; 80h for first hhd
   mov bx,0     
   mov es,bx
   mov bx,0x7c00  ; ES:BX --> data buffer
   int 0x13
   jc hdd_error   ; CF =set when ERROR
   jmp loop0
hdd_error:
   mov bx,HddError
   call PrintString
   jmp $
loop0:
   mov dh,0      ; row=0
   mov dl,0      ; column=0
loop1:
   call MoveCursor
   mov cl,0xdc
   call PrintString
   call delay
   call MoveCursor
   mov cl,0x20
   call PrintChar
   call PrintChar
   call PrintChar
   call PrintChar
   call delay
   inc dl
   cmp dl,80
   je next
   jmp loop1
next:
   inc dh
   mov dl,0
   cmp dh,20
   je next2
   jmp loop1
next2:
   jmp loop0

mov bx,TestString
call PrintString

jmp $

MoveCursor:   ; row=dh  column=dl
	push ax
	push bx
	mov ah,0x02
	mov bh,0x01
	int 0x10
	pop bx
	pop ax
	ret

PrintChar:    ; char in  cl
     push ax
     mov al,cl
     mov ah,0x0e
     int 0x10
     pop ax
     ret

delay:
     push dx
     push cx
     push ax
     mov dx,0xC350
     mov cx,0x0000
     mov ah,0x86
     int 0x15
     pop ax
     pop cx
     pop dx
     ret
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
HddError:
   db "HHD Error, is not Ready",0
CheckDrire:
   db "Checking HHD Disk...",0
TestString:
	db "===>",0

times 510-($-$$) db 0
dw 0xAA55
