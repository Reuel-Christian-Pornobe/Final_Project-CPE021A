; 'TODO  - loop back to the start if wrong password     (checked)
;        - add a sound 																	(checked)
;	 - add designs using int 10h
 	

.model medium
.stack 100h

.data
	message    db 10,13, 'Enter password please: $'
	passwd     db 'igopkyle'	                        ; correct password
	count      dw 8						; amount of character it will read
	correct    db 'Password verified and Correct$'
	notcorrect db 'Invalid Password$'

	noteC 	   db 'q'					; note c
	noteD	   db 'w'    					; note d
	noteE 	   db 'e'					; note e
	noteF	   db 'r'    					; note f
	noteG 	   db 't'					; note g
	noteA	   db 'y'    					; note a
	noteB 	   db 'u'					; note b
	
	message2   db 10,13, 'WELCOME TO PIANO!$'
	message3   db 10,13, 'Q W E R T Y U$'

.code
main proc
	mov ax, @data
	mov ds, ax

start:
	mov cx, count		      	; cx = 6
	mov bx, offset passwd	      	; bx points to passwd

	mov dx, offset message
	mov ah, 09                      ; output string
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

	; show a white color	
	mov ah,06h
	mov ch, 0 		; Top row
	mov cl, 0 		; Left column
	mov dh, 24 		; Bottom row
	mov dl, 80 		; Right column
	mov bh, 000h		; black color
	int 10h

	jmp piano


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
	mov al, 0B6h		; this makes a square wave, there are more types but this will be used...
	out 43h, al   		; sending it be used in the configured port, in/
				; out will be use to configure these since they
				; are hardware ports.
	mov ax, 1140h   	; this will be the frequency used, modify this
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
	mov al, 2



	jmp delay

incorrectSound:
	; the following plays a beep sound...
	mov al, 0B6h  		; this makes a square wave, there are more types but this will be used...
	out 43h, al   		; sending it be used in the configured port, in/
				; out will be use to configure these since they
				; are hardware ports.
	mov ax, 6449h   	; this will be the frequency used, modify this
				; to change the sounds.
	out 42h, al
	mov al, ah
	out 42h, al

	in al, 61h    		; these two reads the current state of the speaker
	or al, 3      		; to configure and if so, it will turn it to that
	out 61h, al   		; as can be seen here where port 61h is used.

	mov al, 5
	jmp delayIncorrect


do:
	; play sound of do.
	mov al, 0B6h  		; this makes a square wave, there are more types but this will be used...
	out 43h, al   		; sending it be used in the configured port, in/
				; out will be use to configure these since they
				; are hardware ports.
	mov ax, 4560		; this will be the frequency used, modify this
				; to change the sounds.
	out 42h, al
	mov al, ah
	out 42h, al

	in al, 61h    		; these two reads the current state of the speaker
	or al, 3      		; to configure and if so, it will turn it to that
	out 61h, al   		; as can be seen here where port 61h is used.

	
	; color	
	mov ah,06h
	mov ch, 0 		; Top row
	mov dh, 24 		; Bottom row
	mov cl, 0 		; Left column
	mov dl, 11 		; Right column
	mov bh, 020h		; green color
	int 10h
	

	mov al, 5
	jmp delay

re:
	; play sound of re
	mov al, 0B6h  		; this makes a square wave, there are more types but this will be used...
	out 43h, al   		; sending it be used in the configured port, in/
				; out will be use to configure these since they
				; are hardware ports.
	mov ax, 4063    	; this will be the frequency used, modify this
				; to change the sounds.
	out 42h, al
	mov al, ah
	out 42h, al

	in al, 61h    		; these two reads the current state of the speaker
	or al, 3      		; to configure and if so, it will turn it to that
	out 61h, al   		; as can be seen here where port 61h is used.

	; color	
	mov ah,06h
	mov ch, 0 		; Top row
	mov dh, 24 		; Bottom row
	mov cl, 11 		; Left column
	mov dl, 22 		; Right column
	mov bh, 020h		; green color
	int 10h

	mov al, 5
	jmp delay

mi:
	; play sound of mi
	mov al, 0B6h  		; this makes a square wave, there are more types but this will be used...
	out 43h, al   		; sending it be used in the configured port, in/
				; out will be use to configure these since they
				; are hardware ports.
	mov ax, 3619    	; this will be the frequency used, modify this
				; to change the sounds.
	out 42h, al
	mov al, ah
	out 42h, al

	in al, 61h    		; these two reads the current state of the speaker
	or al, 3      		; to configure and if so, it will turn it to that
	out 61h, al   		; as can be seen here where port 61h is used.

	; color	
	mov ah,06h
	mov ch, 0 		; Top row
	mov dh, 24 		; Bottom row
	mov cl, 22 		; Left column
	mov dl, 33 		; Right column
	mov bh, 020h		; green color
	int 10h


	mov al, 5
	jmp delay
do2:             ; just an extension
	jmp do
re2:             ; just an extension
	jmp re

fa:
	; play sound of fa
	mov al, 0B6h  		; this makes a square wave, there are more types but this will be used...
	out 43h, al   		; sending it be used in the configured port, in/
				; out will be use to configure these since they
				; are hardware ports.
	mov ax, 3416    	; this will be the frequency used, modify this
				; to change the sounds.
	out 42h, al
	mov al, ah
	out 42h, al

	in al, 61h    		; these two reads the current state of the speaker
	or al, 3      		; to configure and if so, it will turn it to that
	out 61h, al   		; as can be seen here where port 61h is used.

	; color	
	mov ah,06h
	mov ch, 0 		; Top row
	mov dh, 24 		; Bottom row
	mov cl, 33 		; Left column
	mov dl, 44 		; Right column
	mov bh, 020h		; green color
	int 10h

	mov al, 5
	jmp delay

piano:
	; sing the note C
	mov ah,08			; service number
	int 21h				; reads a char in al without echo
	
	mov bx, offset noteC	      	; bx points to noteC
	cmp al, [bx]                    
	je do2	

	; sing the note D
	mov bx, offset noteD	      	; bx points to noteD
	cmp al, [bx]                    
	je re2

	; sing the note E
	mov bx, offset noteE	      	; bx points to noteE
	cmp al, [bx]                    
	je mi


	; sing the note F
	mov bx, offset noteF	      	; bx points to noteF
	cmp al, [bx]                    
	je fa
	
	; sing the note G
	mov bx, offset noteG	      	; bx points to noteG
	cmp al, [bx]                    
	je sol

	; sing the note A
	mov bx, offset noteA	      	; bx points to noteA
	cmp al, [bx]                    
	je la


	; sing the note B
	mov bx, offset noteB	      	; bx points to noteB
	cmp al, [bx]                    
	je ti


	; exit                   
	jne turnOff


turnOff:
	mov ah,4ch
	int 21h
	main endp



sol:
	; play sound of sol
	mov al, 0B6h  		; this makes a square wave, there are more types but this will be used...
	out 43h, al   		; sending it be used in the configured port, in/
				; out will be use to configure these since they
				; are hardware ports.
	mov ax, 3043		; this will be the frequency used, modify this
				; to change the sounds.
	out 42h, al
	mov al, ah
	out 42h, al

	in al, 61h    		; these two reads the current state of the speaker
	or al, 3      		; to configure and if so, it will turn it to that
	out 61h, al   		; as can be seen here where port 61h is used.

	; color	
	mov ah,06h
	mov ch, 0 		; Top row
	mov dh, 24 		; Bottom row
	mov cl, 44 		; Left column
	mov dl, 55 		; Right column
	mov bh, 020h		; green color
	int 10h

	mov al, 5
	jmp delay

la:
	; play sound of la
	mov al, 0B6h  		; this makes a square wave, there are more types but this will be used...
	out 43h, al   		; sending it be used in the configured port, in/
				; out will be use to configure these since they
				; are hardware ports.
	mov ax, 2711		; this will be the frequency used, modify this
				; to change the sounds.
	out 42h, al
	mov al, ah
	out 42h, al

	in al, 61h    		; these two reads the current state of the speaker
	or al, 3      		; to configure and if so, it will turn it to that
	out 61h, al   		; as can be seen here where port 61h is used.

	; color	
	mov ah,06h
	mov ch, 0 		; Top row
	mov dh, 24 		; Bottom row
	mov cl, 55 		; Left column
	mov dl, 66 		; Right column
	mov bh, 020h		; green color
	int 10h

	mov al, 5
	jmp delay

ti:
	; play sound of ti
	mov al, 0B6h  		; this makes a square wave, there are more types but this will be used...
	out 43h, al   		; sending it be used in the configured port, in/
				; out will be use to configure these since they
				; are hardware ports.
	mov ax, 2415		; this will be the frequency used, modify this
				; to change the sounds.
	out 42h, al
	mov al, ah
	out 42h, al

	in al, 61h    		; these two reads the current state of the speaker
	or al, 3      		; to configure and if so, it will turn it to that
	out 61h, al   		; as can be seen here where port 61h is used.

	; color	
	mov ah,06h
	mov ch, 0 		; Top row
	mov dh, 24 		; Bottom row
	mov cl, 66 		; Left column
	mov dl, 80 		; Right column
	mov bh, 020h		; green color
	int 10h

	mov al, 5
	jmp delay

end main