; for use in a .cpp executable when including external assembly
; use main in assembly and call .cpp header functionality into assembly
		; to re-arrange/modify/STORE STORE STORE!!!!! functionality and HANDLE VARIABLES
; inclusion file to call assembly functions


			option	casemap:none
; declare MACROS
		nl	=	10			; ASCII code for newline
		maxLen =	256			; Maximum string size + 1	- THINK SHA

			.const

	titleStr	byte	'ToAssemblyFromCppMain', 0

			.data

;declare variables
		prompt	byte	'Enter a string: ', 0
	breakPoint	byte	'Broke', 0
		fmtStr	byte	"User entered: '%s'", nl, 0		; notice use of macro AS ARGUMENT and wrapping for c-inclusion
		input	byte	maxLen dup (?)		; tells MASM to make "maxLen" duplicate copies of 
							; a byte, EACH of which is uninitialized
		dwArray	dword	256 dup (1)
	
			.code

; Make external process declarations
		externdef	printf:proc
		externdef	readLine:proc

; Make internal process declarations
; The C++ function calling this assembly language module
; expects a function named "getTitle" that returns a pointer
; to a string as the function result. This is that function!!!
public getTitle
	getTitle	proc
			lea	rax, titleStr
			ret
	getTitle	endp

; process to flush buffer
public zeroBytes	
	zeroBytes	proc
			mov	eax, 0
			mov	edx, 256
	repeatlp:	mov	[rcx+rdx*4-4], eax
			dec	rdx
			jnz	repeatlp
			ret
	zeroBytes	endp

public myProc			
	myProc		proc
			call 	asmFunc
			ret
	myProc		endp

public asmFunc
	asmFunc		proc
			sub	rsp, 56
			lea	rcx, fmtStr
			call	printf
			add	rsp, 56
			ret
	asmFunc		endp

public	asmMain						; psuedo main - for alignment???
	asmMain		proc
			sub	rsp, 56
			lea	rcx, prompt
			call	printf
			mov	input, 0		; adds a zero to the end of the buffer/string/stack/array

; TO INITIALIZE A VARIABLE WITH USER INPUT
			lea	rcx, input		; SET THE VARIABLE TO BE USED
			mov	rdx, maxLen		; GIVE IT PARAMETERS FROM MACROS
			call	readLine		; use this process to actually COLLECT the input from the user and STORE it	

; PASS THE USER INPUT TO STDOUT using printf()
			lea	rcx, fmtStr	; first argument for upcoming call to process
			lea	rdx, input	; second argument for upcoming call to process
			call	printf

			add	rsp, 56			; "close the file"/clear allocated memory in RAM???

; establish new buffer?
			sub	rsp, 48
			lea	rcx, dwArray
			call	zeroBytes
			add	rsp, 48			; Restore RSP
			ret
	asmMain		endp
			END

















