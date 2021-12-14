INCLUDE IRVINE32.inc

.data
sysTime SYSTEMTIME <>
ts word ?
th word ?
tm word ?
tday word ?
tmonth word ?
tyear word ?
prompt1 byte "Press 1 for current date and time", 0
prompt2 byte "Press 2 for timer",0
prompttimezone1 byte "Press 3 for current date and time of UK", 0
prompttimezone2 byte "Press 4 for current date and time of India", 0
promptstopwatch byte "Press 5 for stopwatch", 0
prompth byte "Enter hours for timer: ",0
promptm byte "Enter minutes for timer: ",0
prompts byte "Enter seconds for timer: ",0 
promptstop byte "Enter 0 to start: ",0
promptstopstopwatch byte "Press Ctrl+C to stop stopwatch",0
.code
main PROC
mov edx, offset prompt1
call writestring
call crlf
mov edx, offset prompt2
call writestring
call crlf
mov edx, offset prompttimezone1
call writestring
call crlf
mov edx, offset prompttimezone2
call writestring
call crlf
mov edx, offset promptstopwatch
call writestring
call crlf
call readint
.IF eax == 1
	call showMenu
.ELSEIF eax == 2
	call Timerfucn
.ELSEIF eax == 3
	mov ebx, eax
	call showMenu
.ELSEIF eax == 4
	mov ebx, eax
	call showMenu
.ELSEIF eax == 5
	mov ebx, eax
	call stopwatch
.ENDIF

EXIT
main endp

;-----------------------------------------
showMenu PROC 
; displays menu
;-----------------------------------------
L1:
call clrscr
mov dh, 0
mov dl, 50
call gotoxy
INVOKE GetLocalTime, ADDR sysTime
mov ax, sysTime.wHour
mov th, ax
.IF ebx == 3
	sub th, 4
.ELSEIF ebx == 4
	add th, 1
.ENDIF
mov ax, sysTime.wMinute
mov tm, ax
mov ax, sysTime.wSecond
mov ts, ax
call displayTime
call displayDate
mov edx, offset prompt1
call writestring
mov eax, 1000
call delay
Loop L1
ret
showMenu endp

;--------------------------------------
displayTime PROC uses eax
;takes hour in th, minutes in tm and seconds in ts. 
;Then displays time and date
;--------------------------------------
mov eax, 0
mov ax, th
call single
call writedec
mov ax, ":"
call writechar
mov ax, tm
call single
call writedec
mov ax, ":"
call writechar
mov ax, ts
call single
call writedec
ret
displayTime endp

;---------------------------------------
displayDate PROC uses eax edx
; displays current date
;---------------------------------------
mov dh, 0
mov dl, 70
call gotoxy
mov ax, sysTime.wDay
call writedec
mov ax, "/"
call writechar
mov ax, sysTime.wMonth
call writedec
mov ax, "/"
call writechar
mov ax, sysTime.wYear
call writedec
ret
displayDate endp

;--------------------------------------
single PROC uses ax
; recieves time in ax
; adds an extra zero if time is in 1 digit
;--------------------------------------
.IF ax < 10
	mov ax, 0
	call writedec
.endif
ret
single endp

Timerfucn PROC 
mov edx, offset prompth
call writestring
call readint
mov th, ax
mov edx, offset promptm
call writestring
call readint
mov tm, ax
mov edx, offset prompts
call writestring
call readint
mov ts, ax
LongT:
call displayTime
dec ts
.IF ts == -1
	dec tm
	mov ts, 59
	.IF tm == -1
		dec th
		mov tm, 59
		.IF th == -1
			jmp Timerend
		.ENDIF
	.ENDIF
.ENDIF
mov eax, 1000
call delay
call clrscr
jmp LongT
Timerend:
ret
Timerfucn endp

stopwatch Proc
mov edx, offset promptstop
call writestring
call readint

mov th,00
mov tm,00
mov ts,00

LongT:
mov edx, offset promptstopstopwatch
call writestring
call crlf
call displayTime
inc ts
.IF ts == 60
	inc tm
	mov ts, 00
	.IF tm == 60
		inc th
		mov tm, 00
		.IF th == 24
			mov th,00
			mov tm,00
			mov ts,00
			jmp stopwatchend
		.ENDIF
	.ENDIF
.ENDIF
mov eax, 1000
call delay
call clrscr
;MOV AH,0 ;INT 16,0 reads one key input
;INT 10h

;CMP AH,1 ;1 is the scan code for the Escape key
;JE stopwatchend
        
        
    
jmp LongT
stopwatchend:
ret
stopwatch endp


end Main
