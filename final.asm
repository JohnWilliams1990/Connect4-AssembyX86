Title final.asm
;John F. Williams
;105201054
;Description: this is a menu driven program that manipulates squares to play a game called connect 4. This Game was orinaly built by Milton_Bradley 
;I am making the connect 3 version for the final in csci 2525

; Thank you Diane for a wonderfully complex semester    :)



include irvine32.inc

; goes above .data 
clearEAX textequ <mov eax, 0>					; clear registers macros
clearEBX textequ <mov ebx, 0>
clearECX textequ <mov ecx, 0>
clearEDX textequ <mov edx, 0>
clearESI textequ <mov esi, 0>
clearEDI textequ <mov edi, 0>

.data
;prompts -> write it all as one really long string
prompt1 byte "MAIN MENU",0ah,0dh,								;main menu prompt 
			 "---------",0ah,0dh,
			 "1. Computer VS Computer",0ah,0dh,
			 "2. Player VS Computer",0ah,0dh,
			 "3. Player VS Player",0ah,0dh,
			 "4. Quit",0ah,0dh,0h

oops byte "Invalid Entry. Please Try again",0ah,0dh,0ah,0dh,0h	;error prompt to user

rules byte 09h,09h,09h,"CONNECT 3:",0ah,0dh,0ah,0dh,
		   "RULES:",0ah,0dh,0ah, 0dh,"The object of the game is to get 3 pieces of the same color in a row, column or diagonal.",0ah, 0dh,
		   "Who ever accomplishes this first wins",0ah,0dh,
		   "Who ever gets the blue piece gets to go first.", 0ah, 0dh,
		   "Pieces are inserted into individual columns and fall to the net available position.",0ah, 0dh,0

		   	


userInput byte 0h												; menu choice from user						
theString byte 50 dup(0h),0h									; the string that will hold the user input
; get length after the user enters it

array byte 4 dup(07h);07h
	row_size = ($-array)
	byte 12 dup(07h);0E0h
	;sizeofboard = ($-array)
	;byte 16 dup(0)

boardAddress dword offset array									; put the offset of the array into the variable 
sizeofboard byte 16

	playerColor byte 0
	computerColor byte 0 


	tabcrlf byte 0ah,0dh,09h,0
	Pwinner byte "PLAYER WINS",0ah,0dh,0
	Cwinner byte "COMPUTER WINS",0ah,0dh,0
	P1winner byte "PLAYER1 WINS",0ah,0dh,0
	P2winner byte "PLAYER2 WINS",0ah,0dh,0
	C1winner byte "COMPUTER1 WINS",0ah,0dh,0
	C2winner byte "COMPUTER2 WINS",0ah,0dh,0
	tie byte 0ah,0dh,09h,09h,09h,"<<<<<< TIE GAME >>>>>>>"
	gofirst byte 0
	gamemode byte 0

	gametally byte 0
	PlayerPromt byte "games won by Player1: ",0
	gametally1 byte 0

.code

DisplayPrimes PROTO C, BAddres:DWORD, sizeofit:byte, compColor: byte,plyColor: byte, mode: byte

PlayGame PROTO C, BAddress:DWORD, sizeofit:word, PlayeroneColor:byte

ComputerPlay PROTO C, Gaddress:DWORD, sizeofit:word, ComptColor: byte

Check PROTO C,
	BAddress:DWORD, sizeofit:word, PlayeroneColor:byte

Zeroit PROTO C, PrimeAddress:DWORD, sizeofit:word

	SWAPem PROTO C, AddressA:DWORD, AddressB:DWORD


main Proc

mov edx, offset rules 
call writestring 

call crlf 
call waitmsg



clearEAX									; clear registers 
clearEBX 
clearECX 
clearEDX 
clearESI 
clearEDI 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call randomize								
	mov eax, 45
	call randomrange									; determine what color is the players 
	mov ebx, 2
	div bl
cmp ah, 0
je playerBlue

mov playerColor , 0E0h
mov computerColor, 090h									; set the specific colors in one way 



jmp overit												
playerBlue:
mov gofirst, 090h										
mov playerColor , 090h
mov computerColor,0E0h

overit:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




startHere:
invoke SWAPem, offset playerColor, offset computerColor			; at the beginning of the loop randomize the colors 
invoke Zeroit, boardAddress, sizeofboard						; zero out the table for all elements being equal to 07h for regular background color


call clrscr														; clear the screen 
mov edx, offset prompt1											; put offset of message in edx
call writestring												; write the string 

call readdec													; call function that gathers user data
mov userInput, al												; put the use'r choice in al

								; logical conditionals that form the menu 
Opt1:															
cmp userinput,1													; if user input = 1
jne Opt2														; else jump to 2	
;-----------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov gamemode, 3												; set the gamemode for printing of the headers in the Printing array function

mov eax, offset array
mov boardAddress, eax										; set the boardaddress up 

cmp playerColor, 90h
jne computerStart2											; determine who is blue and who to go first


mov ecx, 8													; SET THE LOOP TO 8
L00:
push ecx													;PUSH THE REGISTERS FOR THE COUNT 

	call clrscr 

														;DISPLAY THE BOARD
Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor, playerColor,gamemode
													;LET THE COMPUTER TAKE A TURN
invoke ComputerPlay, boardAddress, sizeofboard, playerColor

mov eax, 2000
call delay														;WAIT TWO SECONDS


cmp dl, playerColor												;SEE IF THE COMPUTER WON AND JUMP IF SO TO THEN END OF THIS GAME
je playerWins2

jmp goagain2													;MOVE ON AND LET THE 2ND COMPUTER TAK A TURN
backintoit2:
pop ecx													;POP THE COUNT FOR THE LOOP 
loop L00

jmp ties												; IF HERE THEN WE TIED SO MOVE ON TO DISPLAY THIS

goagain2:													;THIS DOSENT FIT IN THE LOOP SO i PUT IT OUTSIDE AND JUMP BACK AND FORTH

	
	call clrscr 
														;DISPLAY THE BOARD 
Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor,gamemode ; count the number of primes neede to display annd return the variable in countofit

mov eax, 2000												; WAIT 2 SECONDS 
call delay


													;LET COMPUTER 1 PLAY 
invoke ComputerPlay, boardAddress, sizeofboard, computerColor


cmp dl, computerColor													;CHECK EDX FOR WIN 
je computerWins2													;IF EQUAL THEN JUMP TO END OF GAME

jmp backintoit2

;;;------------------------------------------------------------------------------------------
computerStart2:										; IF COMPUTER1 SHOULD START BECAUSE BLUE ALWAYS STARTS

mov ecx, 8
L01:
push ecx													;PUSH LOOP COUNT 

	call clrscr 
														;DISPLAY BOARD 
Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor, playerColor,gamemode; count the number of primes neede to display annd return the variable in countofit
													;LET COMPUTER1 PLAY FIRST
invoke ComputerPlay, boardAddress, sizeofboard, computerColor

mov eax, 2000													;DELAY 2 SECONDS 
call delay


cmp dl, computerColor													;CHECK TO SEE WHO WON IF SO 
je computerWins2

jmp goagain3													;JUMP OUT OF LOOP AND BACK IN TO IT TO LET COMPUTER TWO PLAY 
backintoit3:
pop ecx													;POP LOOP COUNT
loop L01													;LOOP THE LOOP 

jmp ties													;IF TIE THEN JUMP

goagain3:

	
	call clrscr 
														;DISLAY THE BOARD
Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor,gamemode ; count the number of primes neede to display annd return the variable in countofit

mov eax, 2000												;wait two seconds 
call delay


												;let the computer play 
invoke ComputerPlay, boardAddress, sizeofboard, playerColor

												;did the last mov e for the computer win? if so then end game
cmp dl, playerColor
je playerWins2

jmp backintoit3									;redo event loop 





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

playerWins2:											;if computer won

call clrscr 


												;crlf and tab 
	mov edx, offset tabcrlf 
	call writestring

													;set the background to the winning color and the forground 
	movzx eax, playerColor
	add eax,10
	call settextcolor
	

	mov edx, offset C2winner ; P1winner					;print who won the game				
	call writestring 

	mov eax, 07h
	call settextcolor
													; mov back to the default color

	
		

		call crlf 											;display the board 
Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor, gamemode
	call crlf 
		call waitmsg

				 											;redo and jump back to the menu
jmp startHere

computerWins2: 											;if the other computer  won

call clrscr 

	mov edx, offset tabcrlf 
	call writestring


	movzx eax, computerColor 											;change the background color to their color and forground to green
	add eax,10
	call settextcolor
	

	mov edx, offset C1winner								;>>>>>>>>>>>>>>>; was P2winner<<<<<<<<<<<<<<<
	call writestring  											;print the message of who one

	mov eax, 07h 											;reset the console colors to default
	call settextcolor


call crlf 
 											;display the board 
Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor, gamemode

		call crlf 
call waitmsg
jmp startHere

ties:
 											;if the game was a tie say so and end the game


call clrscr 
mov edx, offset tie
call writestring 

call crlf 
call waitmsg






;;;;;;;;;;;;;;;;;;
JMP startHere													; restart the menu 

	

;-------------------
Opt2:
cmp userInput,2														; if user input = 2
jne Opt3															; else jump to 3

mov gamemode, 1

mov eax, offset array
mov boardAddress, eax											;set the board address ;

cmp playerColor, 90h
jne computerStart1	 											;determine who is blue and there by who goes first
 											;


mov edx, offset PlayerPromt ;"games won by Player1: ",0
call writestring
movzx eax, gametally 											;write out the game tally 
call writedec 

call crlf 
call waitmsg





mov ecx, 8
L9: 											;if the player gets to go first
push ecx


	call clrscr 
	 											;display the board 
Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor, playerColor,gamemode; count the number of primes neede to display annd return the variable in countofit
 											;let the player take a turn 
invoke PlayGame, boardAddress, sizeofboard, playerColor

cmp dl, playerColor 							;determine if the player won on the last turn 
je playerWins1

jmp goagain 									; let the computer go and then display the board and see if it won 
backintoit:
pop ecx								
loop L9

jmp ties									;if the loop runs out then we ran out of moves we are tied so jump to the tie senario

goagain:				 							;let the computer have a turn

	
	call clrscr 
	 											;display the board 
Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor,gamemode ; count the number of primes neede to display annd return the variable in countofit

mov eax, 2000
call delay


 											;computers turn 
invoke ComputerPlay, boardAddress, sizeofboard, computerColor

 											;see if the computer won 
cmp dl, computerColor
je computerWins1

jmp backintoit 								;if not then restart the loop 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

computerStart1: 											;if the computer needs to start

mov ecx, 8
L10:
push ecx 											;push registers



	call clrscr
	 											;display the board 
	Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor, playerColor,gamemode; count the number of primes neede to display annd return the variable in countofit

	mov eax, 2000
	call delay 											;wait for it 
	 											;let the computer play first 
	invoke ComputerPlay, boardAddress, sizeofboard, computerColor

	call clrscr 

	cmp dl, computerColor 											;see if the computer won 
	je computerWins1

	jmp goagain1 											;if not then let the player go and see if he won
	backintoit1:
pop ecx
loop L10

jmp ties 											;if we are here the loop ran out so we tied

goagain1:

 											;display the board 
Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor,gamemode ; count the number of primes neede to display annd return the variable in countofit


	 											;let the palyer go for a turn 
invoke PlayGame, boardAddress, sizeofboard, playerColor

cmp dl, playerColor 											;see if the player won the game
je playerWins1

jmp backintoit1 											;repeat the loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
playerWins1: 											;if the player actually won

	call clrscr 

	inc gametally	 											;incrament his game tally
	mov edx, offset tabcrlf  											;crlf and then tab 
	call writestring

	movzx eax, playerColor	 											;change the background color for the user who won the game
;	shl al, 4
	add eax,10
	call settextcolor 											;make the forground green
	
	
	mov edx, offset Pwinner ; P1winner 
	call writestring  											;print out who won the game

		mov eax, 07h
	call settextcolor 											;reset the console colorsto default
	
		

		call crlf 
		 											;display the board 
Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor, gamemode
	call crlf 
		call waitmsg


jmp startHere 											;return to menu

computerWins1:

	call clrscr 

	mov edx, offset tabcrlf  											;crlf and then tab 
	call writestring

	movzx eax, computerColor 											;make background the computer's color
	add eax,10	 												;forground is green 
	call settextcolor	

	mov edx, offset Cwinner								;>>>>>>>>>>>>>>>; was P2winner<<<<<<<<<<<<<<<
	call writestring 

	mov eax, 07h 											;reset the console colors to default
	call settextcolor

	call crlf 
	 											;display the board 
	Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor, gamemode

	call crlf 
	call waitmsg
	jmp startHere 											;return to menu



	jmp startHere									;jump back to main menu

Opt3:									;Remove all non letter elements 
cmp userInput,3														; if user input = 3
jne Opt4															; else jump to 4

mov edx, offset PlayerPromt ;"games won by Player1: ",0
call writestring
movzx eax, gametally1
call writedec 

call crlf 
call waitmsg


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Player2 is the computer in this part of the game<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	mov gamemode, 2 											;set the game mode to 2 for diplaying purposes
	cmp playerColor, 90h
	je playerstart 

computerStart:													; otherwise the computer IE player2 starts

	mov ecx, 8 											;length of the game
	looping1:
		push ecx
		call clrscr 
		 											;display the board 
		Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor, gamemode ; count the number of primes neede to display and return the variable in countofit
		 											;let palyer2 go first
		invoke PlayGame, boardAddress, sizeofboard, computerColor 

		jmp swap1  											;go outside the loop and let palyer one go and see if either player won the game 
		back1:
			pop ecx 											;pop the loop count
	loop looping1

	jmp ties 											;if we end up here then we tied the game

swap1:							; computers turn

	cmp dl, computerColor  											;did player 2 win
	je playerWins

	call clrscr 
	 											;display the board 
	Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor, gamemode ; count the number of primes neede to display annd return the variable in countofit
	 											;let player 1 go 
	invoke PlayGame, boardAddress, sizeofboard, playerColor 

	cmp dl, playerColor 											;did player 1 win
	je computerWins

	jmp back1 

	jmp done


playerstart:  											;if playerone starts the game

	mov ecx, 8 											;set the loop count
	looping:
	push ecx

	call clrscr 
	 											;display the board 
	Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor, gamemode ; count the number of primes neede to display and return the variable in countofit
	 											;let player one go first
	invoke PlayGame, boardAddress, sizeofboard, playerColor 

	jmp swap  											;jump to swap to let payer 2 go and see if either player won 
	back:
	pop ecx
	loop looping

	jmp ties 											;if no one won then print this out

	swap:							; computers turn/ player2 

		cmp dl, playerColor 						;see if player 2 won 
		je computerWins


		call clrscr 
		 											;display the board 
		Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor, gamemode ; count the number of primes neede to display annd return the variable in countofit

		 											;let palyer 2 go 
		invoke PlayGame, boardAddress, sizeofboard, computerColor 

		cmp dl, computerColor				;see if player1  won 
		je playerWins

		jmp back 

playerWins: 											;if player1 wins

	inc gametally1									;mark this in the game tally

	call clrscr 

	mov edx, offset tabcrlf										;tab and crlf 
	call writestring


	movzx eax, computerColor
	add eax,10										;set the background and forground colors for who won
	call settextcolor
	

	mov edx, offset P1winner ; P1winner 			; print out who won
	call writestring 

	mov eax, 07h										;reset the console's colors
	call settextcolor	

	call crlf 
	 											;display the board 
	Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor, gamemode
	call crlf 
	call waitmsg


jmp startHere										;return to the menu

computerWins:										;if player 2 won 

	call clrscr 

	mov edx, offset tabcrlf 
	call writestring							;crlf and tab 


	movzx eax, playerColor							;set the winning colors
	add eax,10
	call settextcolor
	

	mov edx, offset P2winner						;print out who won								
	call writestring 

	mov eax, 07h
	call settextcolor								;reset the console color


	call crlf 
	 											;display the board 
Invoke DisplayPrimes, boardAddress, sizeofboard, computerColor,playerColor, gamemode

		call crlf 
call waitmsg
jmp startHere


done:

jmp startHere


Opt4:
cmp userInput,4													; if user input = 4
je theEnd												;		-je-    allows us to put in a message here 
	; END OF GAME
mov edx, offset oops												; via logic the user has entered an incorrect character
call writestring													; write the string
call waitmsg														; pause
jmp startHere														; redo menu 



theEnd:																; end lable
exit
Main endP
	
	
;-------------------------------------------------------------------------------------------
;Description: 
;	function takes the number of primes to diplay and the array of the primes and writes them to the screen 
;	the respective manner spelled out in the assignment. 
;>>>>>>>>>>>>>>>>>>>>>>>THIS FUNCTION PRINTS OUT THE ARRAY UPSIDE DOWN FOR THE CONVIENCE OF BEING ABLE TO 
;											 OPPERATE ON IT RIGH SIDES UP<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;recieves: 
;	PrimeAddress: the address of the array, sizeofit:the number to display
;returns:  nothing
;------------------------------------------------------------------------------------------

DisplayPrimes PROC C, BAddres:DWORD, sizeofit:byte, compColor: byte, plyColor: byte, mode: byte
	.data
	anchor dword ?
	arraySize byte ?
	row byte 0
	col byte 0 
	mrdash byte "-----------------", 0ah, 0dh, 0
	pipe byte "|"
	yellow1 byte 0E0h
	blue1 byte 090h
	space byte 20h
	default byte 07h

	computerPro byte 09h,"Computer: ",0
	playerPro byte 09h,"Player: ",0

	computerPro1 byte 09h,"Computer1: ",0
	playerPro1 byte 09h,"Player1: ",0
	computerPro2 byte 09h,"Computer2: ",0
	playerPro2 byte 09h,"Player2: ",0


	.code
movzx eax, mode
movzx ebx, plyColor

	cmp mode, 1
	jg mode2										;find out what viewing mode we are in and display the approerate header for that mode
	;PVC

	call crlf 
	mov edx, offset computerPro 										;	write out computer message for header
	call writestring
											;for mode one
	movzx eax, compColor
	call settextcolor 


	mov eax, 20h 
	call writechar 										;write out the color associated with that parson/ computer 
	call writechar 
	call writechar 
	
	
	mov eax, 07h									;reset the textcolor to the default
	call settextcolor 

	mov edx, offset playerPro ;	write out player message for header
	call writestring
	

	movzx eax, plyColor
	call settextcolor 

	
	mov eax, 20h 
	call writechar 										;write out the color associated with that parson/ computer 
	call writechar 
	call writechar 
	mov eax, 07h									;reset the textcolor to the default
	call settextcolor 

	jmp enough
	
	mode2:										;for mode two
	cmp mode, 2
	jg mode3

	call crlf 
	mov edx, offset playerPro1;	write out player1 message for header
	call writestring
	
	movzx eax, compColor
	call settextcolor 


	mov eax, 20h 
	call writechar  										;write out the color associated with that parson/ computer 
	call writechar 
	call writechar 
	
	
	mov eax, 07h									;reset the textcolor to the default
	call settextcolor 


	mov edx, offset playerPro2 ;	write out player2 message for header
	call writestring
	

	movzx eax, plyColor
	call settextcolor 

	
	mov eax, 20h 
	call writechar  										;write out the color associated with that parson/ computer 
	call writechar 
	call writechar 
	mov eax, 07h									;reset the textcolor to the default
	call settextcolor 





		jmp enough

	mode3:										;for mode three

	call crlf 
	mov edx, offset computerPro1 ;	write out computer1 message for header
	call writestring
	
	movzx eax, compColor
	call settextcolor 


	mov eax, 20h 
	call writechar  										;write out the color associated with that parson/ computer 
	call writechar 
	call writechar 
	
	
	mov eax, 07h									;reset the textcolor to the default
	call settextcolor 

	mov edx, offset computerPro2;	write out computer2 message for header
	call writestring
	

	movzx eax, plyColor
	call settextcolor 

	
	mov eax, 20h 
	call writechar  										;write out the color associated with that parson/ computer 
	call writechar 
	call writechar 
	mov eax, 07h
	call settextcolor 									;reset the textcolor to the default


enough:	
	call crlf 
	call crlf 


	mov eax, BAddres									;set the address ofor the variable of the table
	mov anchor, eax
	mov esi, eax
	movzx ecx, sizeofit									;set the lopop count
	mov arraySize, cl 									;get a copy of it

	mov eax, 09h
	call writechar									;inital tab 

	mov edx, offset mrdash 
	call writestring									;dashed line
	
	mov row, 3									; reset the array variables for a repeat of the loop
	mov col, 0
	
	mov eax, 0
	
	
	call gettextcolor
	mov default, al									;set the default 
	mov eax, 09h									;inital tab again 
	call writechar

	L1:

	mov esi, BAddres									;calculate the address 
	movzx eax, row										;(row*rowsize + column )+ base offset
	mov ebx, 4
	mul ebx
	add al, col 
	add esi, eax

	

	movzx eax, pipe 									;write a pipe on the screen 
	call writechar

	movzx eax, byte ptr [esi]							;set the text color from the array
	call settextcolor
		
	mov al, space 
	call writechar 										;write out the color associated with that parson/ computer 
	call writechar
	call writechar
	
	movzx eax, default
	call settextcolor 									;reset the color of the screen 
	

	inc col									;mov to the next column if applicable
	cmp col, 4
	je crlfing										;otherwise reset the columns and incrament the rows

	back:


	loop L1									;loop the loop 

	mov edx, offset mrdash ; at the end print out the dashes line
	call writestring

	jmp done 									;jump to done 

	crlfing: 									;if the loop needed adjusting


	cmp ecx, 16
	je back


	movzx eax, pipe 
	call writechar									;write the last pipe in the row

	call crlf 

	mov eax, 09h									;tab 
	call writechar
	
	mov col, 0									;reset the column to zero 
	dec row 									;decrament the row

	cmp row, 0
	jl done
	;mov col, 0
	;inc row 

	;cmp row, 4
	

	jmp back									;RETURN TO THE LOOP 



	done:									;at the end of the displating 
	mov edx, offset mrdash 
	call writestring					;write out the dased footer 

	CALL CRLF 


	ret 
	DisplayPrimes endp



	
;-------------------------------------------------------------------------------------------
;Description: 
;	function simulates the playes move and places the respective color in the available row at the 
;	specified column. it then invokes the check procedure to see who won the game. if someone wins 
;	then edx will have the return value
;recieves: 
;	BAddress: the address of the array
;	sizeofit:the number in the array 
;	PlayeroneColor: the color being played
;returns:  the color value of the person who won if applicable in edx or 0 
;------------------------------------------------------------------------------------------
	
PlayGame PROC C,
	BAddress:DWORD, sizeofit:word, PlayeroneColor:byte

	.data
	
	row1 byte 0
	col1 byte 0

	playPrompt byte  0ah, 0dh,"Please enter a column number to play", 0ah, 0dh, 0ah, 0dh, 0
	reeoniousContent byte  0ah, 0dh,"Please enter a number  between 1 & 4", 0ah, 0dh, 0ah, 0dh, 0
	sorry byte "Please check the input and try again...",0ah,0dh,0 
	
	playerColor1 byte 0
	computerColor1 byte 0 

	.code
	
 	mov row1, 0
	mov col1, 0
	
	mov esi, BAddress
	movzx ecx, sizeofit

	movzx eax, PlayeroneColor								; set the variables up  
	mov playerColor1, al 

	
	tryagainPlease:
	mov edx, offset playPrompt 								;promp the user for a column number 
	call writestring 
	mov eax, 0 
	call readdec 								;get users choice

	cmp eax, 1
	jl error
	 											;ensure it is within range
	cmp eax, 4
	jg error

	dec eax

	mov col1, al 								;place it into the col variable
	
	mov row1, 0 								;mov row to 0

	;<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	;~~~~~~~~~~~~I am working on the array rightsides up and displaying it upside down~~~~~~~~~~~~~~~~
	;<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	mov ecx, 4 									;we only need to check 4 rows at most
	L2:
	; col is fixed 
	
	movzx eax, row1 
	mov ebx, 4
	mul bl								;calculate the address 
	add al, col1 
	mov esi, BAddress
	add esi, eax
	cmp byte ptr [esi], 07h				;see if it is available 
	je adjust							;if so then deposit the item 
	back:
	inc row1	
	cmp row1, 3							
	jg tryagainPlease					; IF THE COL IS FULL THEN THEY MUST ENTER A DIFFERENT COLUMN

	
	loop L2				;LOOP THE LOOP 


	adjust:

	movzx eax, PlayeroneColor				;PLACE THE ITEM IN THE RESPECTIVE POSITION ON THE ARRAY 
	mov byte ptr [esi], al
	
	jmp endturn				;END THE TURN 
	
	error:
	mov edx, offset reeoniousContent				;IF THE NUMBER IS OUT OF RANGE
	call writestring 

	jmp tryagainPlease				;TRY AGAIN




	endturn:

	
invoke Check, BAddress, sizeofit, PlayeroneColor				;invoke check to see if they won the game


	ret 
	PlayGame endp


;-------------------------------------------------------------------------------------------
;Description: 
;	function simulates the computers move and places the respective color in the available row at the 
;	specified column. it then invokes the check procedure to see who won the game. if someone wins 
;	then edx will have the return value
;recieves: 
;	BAddress: the address of the array
;	sizeofit:the number in the array 
;	PlayeroneColor: the color being played
;returns:  the color value of the person who won if applicable in edx or 0 
;------------------------------------------------------------------------------------------
	ComputerPlay PROC C,
	Gaddress:DWORD, sizeofit:word, ComptColor: byte
	.data
	color byte 0;
	col2 byte 0
	row2 byte 0
	
	.code

	mov esi, Gaddress
	movzx ecx, sizeofit
	movzx eax, ComptColor							; assign the registers variables
	mov color, al  
	
	top:
	mov row2, 0							;select a random column 
	mov col2, 0

	mov eax, 4
	call randomrange
	
	mov col2, AL							;place that number in to the 
	mov ecx, 4

		mov eax, 4
		mov ebx, 4
		mul bl
		add al, col2
		add esi, eax 

		cmp byte ptr [esi], 0E0h							;make sure that there is nothing in that position already at the top of the visual array 
		je top

		cmp byte ptr [esi], 090h
		je top							;



	L1:							;place the item into the array
	movzx eax, row2
	mov ebx, 4
	mul bl
	add al, col2
	mov esi, Gaddress
	add esi, eax

	cmp byte ptr [esi], 07h						;make sure that there is nothing at that position 
	je adjust

							;otherwisw move to the next row at that column
	inc row2

	CMP ROW2, 3						;if at row 3 then jump put and redo 

	JG top
	loop L1

	jmp done
	adjust:								; place the item in the position 

	mov al, ComptColor
	mov byte ptr [esi], al  


	done:
								;;see if the computer won  
invoke Check, Gaddress, sizeofit, ComptColor



	ret 
	ComputerPlay  endp


	
;-------------------------------------------------------------------------------------------
;Description: 
;	this function determines if there are three peiecs in a particular row column or diagonal  
;	it dose this by summing rows, columns & diagonals individually and then seeing if the sum 
;	has an approperate value that shows there are 3 in a row 
;recieves: 
;	BAddress: the address of the array
;	sizeofit:the number in the array 
;	PlayeroneColor: the color being played
;returns:  the color value of the person who won if applicable in edx or 0 
;------------------------------------------------------------------------------------------

	Check PROC C,
	BAddress:DWORD, sizeofit:word, PlayeroneColor:byte
	.data
	columns byte 4 dup (0)
	rows byte 4 dup (0)

	coln byte 0 
	rown byte 0 

	diag1 byte 0
	diag2 byte 0
	diag3 byte 0
	diag4 byte 0
	diag5 byte 0
	diag6 byte 0

	.code
	
	mov eax, 0
	mov ecx, 4
	L:
	mov [rows+ eax], 0						; zero out the 2 arrays for the sum of rows an columns 
	mov [columns+ eax], 0
	inc eax
	loop L



	mov esi, BAddress							; set the variables 
	movzx ecx, sizeofit 
	mov bl, PlayeroneColor
	
	mov rown, 0
	mov coln, 0

	L0:
	movzx eax,rown
	mov ebx, 4								;calculate the address using row reduced form 
	mul bl
	add al,coln	 
	mov esi,BAddress
	add esi, eax
	movzx edx, byte ptr [esi]
	
	; these values will not fit in byte size  4X 0E0h > 0FFh
	; ternary opperator? or 3d array 

	; dub off a copy 
	; rotate it 4 bits to the right E0h ---> 0Eh and will now have for 3 blues 01bh
	; add it in the approperate slot

	
	cmp dl, 07h								;if it is the default value then move on to the next one
	je next

	jmp fitin								;otherwise count it into its respective row and columns

;	ror dl,4

	
	; extra conditionals for 33h and 29h 
	
	next:								;incrament the column and if needed reset it and incrament the row
	
	inc coln							
	cmp coln, 4
	je adjustment 
		back:
	loop L0								;  loop the loop

	jmp overit							; jump over the stuff till to mov on to checking diagonals
	
	fitin:								; if value isnt 07h

	
	ror dl,4							;rotate it to either 0Eh or 09H from 0E0h and 090h

	movzx ebx, rown
	add byte ptr [rows + ebx], dl									; add it to the approperate row
	cmp byte ptr [rows + ebx], 01Bh			
	je BLUEMIXrow							; do comparisons based on all possable values in the rows that are applicable for a win
	cmp byte ptr [rows + ebx], 02Ah
	je YELLOWMIXrow
	cmp byte ptr [rows + ebx], 033h			
	je YELLOWMIXrow
	cmp byte ptr [rows + ebx], 029h
	je BLUEMIXrow
	cmp byte ptr [rows + ebx], 24h
	je BLUEWINS
	cmp byte ptr [rows + ebx], 38h
	je YELLOWWINS
	
	movzx ebx, coln								;add it to the approperate column
	add byte ptr [columns + ebx], dl
	cmp byte ptr [columns + ebx], 02Ah		; do comparisons based on all possable values in the rows that are applicable for a win
	je YELLOWWINS
	cmp byte ptr [columns + ebx], 1Bh
	je BLUEWINS
	cmp byte ptr [columns + ebx], 033h			; 3 of a kind 
	je YELLOWMIXcol
	cmp byte ptr [columns + ebx], 029h
	je BLUEMIXcol
	cmp byte ptr [columns + ebx], 24h
	je BLUEWINS
	cmp byte ptr [columns + ebx], 38h
	je YELLOWWINS
	; connditional for 4 of a kind 
	; rows and columns 

		jmp next							; if here then we need to move on because all of the conditions for no one winning have been meet

	




	adjustment:										; adjust the loop for row major form
	mov coln, 0 
	inc rown 
	cmp rown, 4
	jg done

	jmp back
	done:

	; add up the columns and rows for answer to who won and change the color of the
	; input to indicate this if applicable 
	overit:
	

	jmp vover											;mov one to diagonals 
	BLUEWINS:										;if blue wins then move the color to edx and return 					

	mov edx, 90h	
	ret 

	YELLOWWINS:											; if yellow wins then mov color to edx and return
		
	mov edx, 0E0h
	ret 

	;THESE ARE ALL OF THE POSSABLE COMBINATIONS THAT CAN HAPPEN IN A GAME THAT ARE CHECD AS THEIR SUM IN ANY ROW OR COLUMN IS FOUND 


	YELLOWMIXcol:		; column sums to 33h
	; THIS IS (0Eh*3) + 09h == 33h
	; locate either row or column that this is in being an edge
	 
	 ; see if blue is at position 0 of row 
	;movzx eax,rown
	mov eax, 0 
	mov ebx, 4
	mul bl
	add al,coln	 
	mov esi,BAddress
	add esi, eax
	movzx edx, byte ptr [esi]; see if a blue in position 0 
	
		cmp dl, 90h
		je nice

	mov eax, 3
	mov ebx, 4
	mul bl
	add al,coln	 
	mov esi,BAddress
	add esi, eax
	movzx edx, byte ptr [esi]
	
	cmp edx, 90h ; see if yellow is at row 0 
	jne next



	nice:
	mov edx, 0E0h
	ret

	BLUEMIXcol: ; column sums to 29h

	;3*9h + 0Eh
	;movzx eax,rown
	mov eax, 0
	mov ebx, 4
	mul bl
	add al,coln	 
	mov esi,BAddress
	add esi, eax
	movzx edx, byte ptr [esi]
	

	cmp edx, 0e0h ; see if yellow is at row 0 
	je betterbe

	mov eax, 3
	mov ebx, 4
	mul bl						
	add al,coln	 
	mov esi,BAddress
	add esi, eax
	movzx edx, byte ptr [esi]
	
	cmp edx, 0e0h ; see if yellow is at row 3
	jne next




	betterbe:
	mov edx, 090h
	ret


	YELLOWMIXrow:			; row sums to 33h
	; THIS IS (0Eh*3) + 09h == 33h	
	movzx eax,rown
	mov ebx, 4
	mul bl							
	;add al,coln					; does col[0] == 90h
	mov esi,BAddress
	add esi, eax
	movzx edx, byte ptr [esi]
	
	cmp dl, 90h
	je good1
	

	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	cmp dl, 07h
	je good1

	add esi, 3
	movzx edx, byte ptr [esi]
	
	cmp dl, 090h
	je good2

	cmp dl, 07h
	jne next
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	good1:

	mov edx, 0E0h
	ret
	
	good2:
	mov edx, 0E0h
	ret
	

	BLUEMIXrow:				; row sums to 29h
	; THIS IS (09h*3) + 0Eh == 29h	
	movzx eax,rown
	mov ebx, 4
	mul bl
	;add al,coln				; does col[0] == 0E0h
	mov esi,BAddress
	add esi, eax
	movzx edx, byte ptr [esi]


	cmp dl, 0E0h
	je good
	

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	cmp dl, 07h
	je good


	add esi, 3
	movzx edx, byte ptr [esi]

	cmp dl, 0E0h
	je good
	
	cmp dl, 07h
	jne next
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	good:

	mov edx, 090h
	ret


								; diagonals needed
	vover:
	;[ ][ ][ ][ ]--------->screen
	;[ ][ ][ ][1]
	;[ ][ ][1][ ]
	;[ ][1][ ][ ]

	mov ecx, 3
	mov rown, 0
	mov coln, 1
	mov diag1, 0
	lo:;						sum up all of the items in the diagonal and see if it is the value needed 

	movzx eax, rown
	mov ebx, 4
	mul bl
	add al, coln
	mov esi,BAddress
	add esi, eax
	cmp byte ptr [esi], 07h
	je done1										; if we come across a space in the diagonal then stop and move on 
	movzx eax, byte ptr [esi]
	ror al, 4
	add diag1, al
	inc coln
	inc rown

	loop lo

	cmp diag1, 01Bh									; who wins based on the sum
	je BLUEWINS
	cmp diag1, 02Ah
	je YELLOWWINS
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	done1:
	
	;[ ][ ][1][ ]
	;[ ][1][ ][ ]
	;[1][ ][ ][ ]
	;[ ][ ][ ][ ]

	mov ecx, 3
	mov rown, 1
	mov coln, 0
	mov diag2, 0
	lo1:;						sum up all of the items in the diagonal and see if it is the value needed 

	movzx eax, rown
	mov ebx, 4
	mul bl									 
	add al, coln
	mov esi,BAddress
	add esi, eax
	cmp byte ptr [esi], 07h
	je done2 ; if we come across a space in the diagonal then stop and move on 
	movzx eax, byte ptr [esi]
	ror al, 4
	add diag2, al
	inc coln
	inc rown

	loop lo1

	cmp diag2, 01Bh
	je BLUEWINS
	cmp diag2, 02Ah
	je YELLOWWINS


	done2:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;[ ][ ][ ][1]	;[ ][ ][ ][*]
	;[ ][ ][1][ ]	;[ ][ ][1][ ]
	;[ ][1][ ][ ]	;[ ][1][ ][ ]
	;[*][ ][ ][ ]	;[1][ ][ ][ ]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov ecx, 4
	mov rown, 0
	mov coln, 0
	mov diag3, 0
	lo2:;						sum up all of the items in the diagonal and see if it is the value needed 

	movzx eax, rown
	mov ebx, 4
	mul bl									
	add al, coln
	mov esi,BAddress
	add esi, eax
	cmp byte ptr [esi], 07h
	je done3 ; if we come across a space in the diagonal then stop and move on 
	movzx eax, byte ptr [esi]
	ror al, 4
	add diag3, al
	inc coln
	inc rown
	
	; @ loop == 3 runs then check to see
	cmp diag3, 01Bh;01Bh
	je BLUEWINS
	cmp diag3, 02Ah;02Ah
	je YELLOWWINS


	loop lo2

	; we need to check again here for array[0][0] == yellow or blue
	cmp diag3, 29h;01Bh
	je BLUECHECK
	cmp diag3, 33h;02Ah
	je YELLOWCHECK

	jmp done3

	BLUECHECK:

	mov esi,BAddress
	cmp byte ptr [esi], 0E0H
	je BLUEWINS 

	jmp done3
	YELLOWCHECK:
	
	
	mov esi,BAddress
	cmp byte ptr [esi], 090H
	je YELLOWWINS



	done3:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;[ ][ ][ ][ ]
;[1][ ][ ][ ]
;[ ][1][ ][ ]
;[ ][ ][1][ ]

	mov ecx, 3
	mov rown, 0
	mov coln, 2
	mov diag4, 0
	lo3:;						sum up all of the items in the diagonal and see if it is the value needed 

	movzx eax, rown
	mov ebx, 4
	mul bl
	add al, coln
	mov esi,BAddress
	add esi, eax
	cmp byte ptr [esi], 07h
	je done4 ; if we come across a space in the diagonal then stop and move on 
	movzx eax, byte ptr [esi]
	ror al, 4
	add diag4, al
	dec coln
	inc rown

	loop lo3

	cmp diag4, 01Bh
	je BLUEWINS
	cmp diag4, 02Ah
	je YELLOWWINS



	done4:


;[ ][1][ ][ ]
;[ ][ ][1][ ]
;[ ][ ][ ][1]
;[ ][ ][ ][ ]

	mov ecx, 3
	mov rown, 1
	mov coln, 3
	mov diag5, 0
	lo5:;						sum up all of the items in the diagonal and see if it is the value needed 

	movzx eax, rown
	mov ebx, 4
	mul bl
	add al, coln
	mov esi,BAddress
	add esi, eax
	cmp byte ptr [esi], 07h
	je done5 ; if we come across a space in the diagonal then stop and move on 
	movzx eax, byte ptr [esi]
	ror al, 4
	add diag5, al
	dec coln
	inc rown

	loop lo5

	cmp diag5, 01Bh
	je BLUEWINS
	cmp diag5, 02Ah
	je YELLOWWINS
	
	done5:

;[1][ ][ ][ ]	;[ ][ ][ ][ ]
;[ ][1][ ][ ]	;[ ][1][ ][ ]
;[ ][ ][1][ ]	;[ ][ ][1][ ]
;[ ][ ][ ][ ]	;[ ][ ][ ][1]

	mov ecx, 4
	mov rown, 0
	mov coln, 3
	mov diag6, 0
	lo6:;						sum up all of the items in the diagonal and see if it is the value needed 

	movzx eax, rown
	mov ebx, 4
	mul bl									
	add al, coln
	mov esi,BAddress
	add esi, eax
	cmp byte ptr [esi], 07h
	je done6; if we come across a space in the diagonal then stop and move on 
	movzx eax, byte ptr [esi]
	ror al, 4
	add diag6, al
	dec coln
	inc rown
	
	; @ loop == 3 runs then check to see
	cmp diag6, 01Bh;01Bh
	je BLUEWINS
	cmp diag6, 02Ah;02Ah
	je YELLOWWINS


	loop lo6

	; we need to check again here for array[0][0] == yellow or blue
	cmp diag6, 29h;01Bh
	je BLUECHECK1
	cmp diag6, 33h;02Ah
	je YELLOWCHECK1

	jmp done6

	BLUECHECK1:


	mov esi, BAddress
	add esi, 3

	; are these mismatched for color being checked ????? 
	mov esi,BAddress
	cmp byte ptr [esi], 0E0H
	je BLUEWINS 

	jmp done6
	YELLOWCHECK1:


	mov esi, BAddress
	add esi, 3
	
	mov esi,BAddress
	cmp byte ptr [esi], 090H
	je YELLOWWINS


	done6:

	mov edx, 0						; if we have reached this point then no one has won the game and we can stop 


	ret 
	Check endP

;-------------------------------------------------------------------------------------------
;Description: 
;	this function takes the array of 16 byte and resets each element in it to 07h
;recieves: 
;	PrimeAddress: the address of the array
;	sizeZ:the number in the array 
;	 
	
;returns:  nothing
;------------------------------------------------------------------------------------------

Zeroit PROC C,
	PrimeAddress:DWORD, sizeZ:word
	
	.data
	zeroR byte 0
	zeroC byte 0

	.code
	mov esi, PrimeAddress
	movzx ecx, sizeZ

	mov zeroR, 0
	mov zeroC, 0


	L100:

	movzx eax, zeroR						; mov in row 
	mov ebx, 4	
	mul ebx
	add al, zeroC;							;calculate address via row major form 
	mov esi, PrimeAddress
	add esi, eax 
	
	mov byte ptr [esi], 07h					; change value to 07h
	inc zeroC								; incrament column 

	cmp zeroC, 4							; if at end of column then mov to next row if applicable 
	je adjust
	back:

	loop L100

	adjust:

	mov zeroC, 0							; adjustment for indicies
	inc zeroR
	cmp zeroR, 4
	je done


	jmp back


	done:
	ret
	Zeroit endP

	
;-------------------------------------------------------------------------------------------
;Description: 
;	this function takes the two colors as pointers and swaps their values if randomly chosen to do so 
;recieves: 
;	AddressA: address of one color 
; AddressB:address of the other color 
;	 
	
;returns:  nothing
;------------------------------------------------------------------------------------------

	SWAPem PROC C,
	AddressA:DWORD, AddressB:DWORD

	
	
	mov eax, 300
	call randomrange
	mov ebx, 2
	div bl

	cmp ah, 1
	jne enough ;		pick a random number and see if we should swap


	mov esi, AddressA		

	mov edx, AddressB

	movzx eax, byte ptr [esi]; if so then get the values of the colors 

	movzx ebx, byte ptr [edx]


	mov byte ptr [edx], al; and swap them 
	
	mov byte ptr [esi], bl


	enough:
	ret 
	SWAPem endp




end main
