INCLUDE IRVINE32.inc

.data
sysTime SYSTEMTIME <>
ts word ?
th word ?
tm word ?
tday word ?
tmonth word ?
tyear word ?
.code
main PROC
call currentTime

EXIT
main endp

;-----------------------------------------
currentTime PROC 
; displays current time and date
;-----------------------------------------
L1:
call clrscr
mov dh, 0
mov dl, 50
call gotoxy
INVOKE GetLocalTime, ADDR sysTime
mov ax, sysTime.wHour
mov th, ax
mov ax, sysTime.wMinute
mov tm, ax
mov ax, sysTime.wSecond
mov ts, ax
call displayTime
mov eax, 1000
call delay
Loop L1
ret
currentTime endp

;--------------------------------------
displayTime PROC uses eax
;takes hour in th, minutes in tm and seconds in ts. Then displays time and date
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
displayTime endp

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

end Main
