; Listing 16-1.asm
; a stand-alone assembly language version of "Hello, World!"

; Link in the Windows Win32 API:

	includelib kernel32.lib

; Calling Windows functions

	extrn __imp_GetStdHandle:proc
	extrn __imp_WriteFile:proc							; think about readwritefile.cpp from Bitcoin src chrome1

			.code
		hwStr	byte	"Hello World!"
		hwLen	=	$-hwStr

; Assembly Main
main			PROC
			lea	rbx, hwStr
			sub	rsp, 8
			mov	rdi, rsp						; Hold # of bytes written here

; MUST set aside 32 bytes (20h) for shadow registers FOR PARAMETERS (do this once FOR_EACH function)
; WriteFile has a 5th argument (which is NULL)
; set aside 8 bytes to hold pointer and initialize to zero
; stack MUST ALWAYS be 16-byte-aligned, so reserve another 8 bytes of storage to do this.

			sub	rsp, 030h						; Shadow storage FOR ARGS

; Handle = GetStdHandle(-11)
; Single argument passed IN ECX!!!!!!!!!!!!!!!!
; Handle RETURNED IN RAX!!!!!!!!!!!!!!!!!!!!!!!

			mov	rcx, -11						; STD_OUTPUT
			call	qword ptr __imp_GetStdHandle				; Returns handle
											; in RAX

; WriteFile(handle, "Hello World!", 12, &bytesWritten, NULL);
; Zero out (set to NULL) "lpOverlapped" argument:
			xor	rcx, rcx
			mov	[rsp + 4 * 8], rcx

			mov	r9, rdi			; Address of bytesWritten" IN R9!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			mov	r8d, hwLen		; Length of string to write in R8D
			lea	rdx, hwStr		; Ptr to string data in RDX
			mov	rcx, rax		; File handle passed in RCX
			call	qword ptr __imp_WriteFile

; Clean up stack and return:
			add	rsp, 38h
			ret
main			endp
			END