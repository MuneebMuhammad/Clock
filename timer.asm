INCLUDE IRVINE32.inc

.data
totalsec dword 3800
ts byte ?
th byte ?
tm byte ?

.code
main PROC
mov eax, totalsec


exit
main endp

;-----------------------------------------------------------------
findTime PROC uses ecx edx
; recieves total number of seconds in eax
; returns seconds, minutes and hour in ts, tm and th respectively
;-----------------------------------------------------------------

mov edx, 0
mov ecx, 60
div ecx
mov ts, dl
mov edx, 0
div ecx
mov tm, dl
mov th, al

ret
findTime endp
end Main