; 'TODO  - loop back to the start if wrong password     (checked)
;        - add a sound 																	(checked)
;	 - add designs using int 10h
 	

.model small
.stack 100h

.data
	message    db 10,13, 'Enter password please: $'
	passwd     db 'igopkyle'	                        ; correct password
	count      dw 8						; amount of character it will read
	correct    db 'Password verified and Correct$'
	notcorrect db 'Invalid Password$'

.code
main proc
	mov ax, @data
	mov ds, ax

start:
	mov cx, count		      	; cx = 6
	mov bx, offset passwd	      	; bx points to passwd

	mov dx, offset message
	mov ah, 09
	int 21h



again:
	; reads a character in al without echo
	mov ah,08			; service number
	int 21h				; reads a char in al without echo

	cmp al, [bx]                    ; compare the correct password to the right password
	jne error                       
	inc bx
	loop again

	mov dx, offset correct
	mov ah, 09
	int 21h
	jmp correctSound



error:
	mov dx, offset notcorrect
	mov ah, 09h
	int 21h
	jmp incorrectSound



beeploop:
	mov cx, 0FFFFh
delay:
	nop
	loop delay
	dec al
	jnz beeploop

	; the following are similar to the previous in/out operations for port
	; 61 but this time it is turning off the speakers.
	in al, 61h
	and al, 0FCh
	out 61h, al
	jmp turnOff


beeploop2:
	mov cx, 0FFFFh
delayIncorrect:
	nop
	loop delayIncorrect
	dec al
	jnz beeploop2

	; the following are similar to the previous in/out operations for port
	; 61 but this time it is turning off the speakers.
	in al, 61h
	and al, 0FCh
	out 61h, al
	jmp start
	



correctSound:
	; the following plays a beep sound...
	mov al, 0B6h  		; this makes a square wave, there are more types but this will be used...
	out 43h, al   		; sending it be used in the configured port, in/
				; out will be use to configure these since they
				; are hardware ports.
	mov ax, 0A98h   	; this will be the frequency used, modify this
				; to change the sounds.
	out 42h, al
	mov al, ah
	out 42h, al

	in al, 61h    		; these two reads the current state of the speaker
	or al, 3      		; to configure and if so, it will turn it to that
	out 61h, al   		; as can be seen here where port 61h is used.

	; looping the beep sounds, change al to configure the amount of time
	; for the beep to occur since using C register or procedure call keeps
	; looping infinitely...
	mov al, 30
	jmp delay



incorrectSound:
	; the following plays a beep sound...
	mov al, 0B6h  		; this makes a square wave, there are more types but this will be used...
	out 43h, al   		; sending it be used in the configured port, in/
				; out will be use to configure these since they
				; are hardware ports.
	mov ax, 0A98h   	; this will be the frequency used, modify this
				; to change the sounds.
	out 42h, al
	mov al, ah
	out 42h, al

	in al, 61h    		; these two reads the current state of the speaker
	or al, 3      		; to configure and if so, it will turn it to that
	out 61h, al   		; as can be seen here where port 61h is used.

	; looping the beep sounds, change al to configure the amount of time
	; for the beep to occur since using C register or procedure call keeps
	; looping infinitely...
	mov al, 5
	jmp delayIncorrect


turnOff:
	mov ah,4ch
	int 21h
	main endp
end main