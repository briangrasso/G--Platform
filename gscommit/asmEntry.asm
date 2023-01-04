; for use as executable when including external assembly and handling VARIABLES - which DIRECTION?
;		to which running process (attach/cmd module)
; use main in assembly and call .cpp header functionality into assembly
		; to re-arrange/modify/STORE STORE STORE!!!!! functionality and HANDLE VARIABLES
; inclusion file to call assembly functions


			option	casemap:none
			.data

;declare VARIABLES
		fmtStr	byte	'String from Assembly', 10, 0		; formatting string
			
			.code

; Make external declarations
	externdef	printf:proc
	externdef	Login:proc			; to initiate instance of G# Platform - 
							; 	make class member of script in gsharp.cpp
							;	to port program to assembly to handle values
							;	passed from child processes (core, etc)
							; include header files and TRY(catch return as error!!!!) loading the gsharp 
							; executable as lea qword

; Make internal process declarations for CALLS FROM PARENT PROCESSES
	public myProc			
		myProc	proc				; make this call another process
							; make process for calling other asm processes
			ret
		myProc	endp

	public asmFunc
		asmFunc	proc
			call	myProc			; call a process from a process?????????????
			sub	rsp, 56
			lea	rcx, fmtStr
			call	printf
			add	rsp, 56
			ret				; ! if I make myProc call back to asmFunc, it that a FOR LOOP? 
		asmFunc	endp

		main	PROC
			call asmFunc
			ret				; return to caller
		main	ENDP
			end