;'TODO  - loop back to the start if wrong password     (checked)
;       - add a sound (if possible)
;	- add designs using int 10h
 	

.model small
.stack 100h

.data
	message db 10,13, 'Enter password please: $'
	passwd db 'igopkyle'				; correct password
	count dw 8					; amount of character it will read       
	correct db 'Password verified and Correct$'
	notcorrect db 'Invalid Password$'

.code
main proc
	mov ax, @data
	mov ds, ax

start:
	mov cx, count		; cx = 6
	mov bx, offset passwd	; bx points to passwd

	mov dx, offset message
	mov ah, 09
	int 21h

again:
	; reads a character in al without echo
	mov ah,08		; service number
	int 21h			; reads a char in al without echo

	cmp al, [bx]
	jne error
	inc bx
	loop again

	mov dx, offset correct
	mov ah, 09
	int 21h
	jmp over

error:
	mov dx, offset notcorrect
	mov ah, 09h
	int 21h
	loop start

over:
	mov ah,4ch
	int 21h

main endp
end main



