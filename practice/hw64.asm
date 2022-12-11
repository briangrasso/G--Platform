includelib kernel32.lib

	extrn __imp_GetStdHandle:proc	; HERE IS THE WINDOW!!!!!!!
	extrn __imp_WriteFile:proc		; HERE IS WRITING TO THAT WINDOW - THINK VB IN C# TURORIAL
									; THINK NATIVE CODE IN BUMBLEBEE

	.CODE
hwStr	byte	"Hello World!"
hwLen	=	$-hwStr

main	PROC

; On entry, stack is aligned at 8 mod 16. Setting aside 8
; bytes for "bytesWritten" ensures that calls in main have
; their stack aligned to 16 bytes (8 mod 16 inside function).

	lea	rbx, hwStr
	sub	rsp, 8
	mov	rdi, rsp	; Hold # of bytes written here

; Note: must set aside 32 bytes (20h) for shadow registers for
; parameters (just do this once for all functions);
; Also, WriteFile has a 5th argument (which is NULL),
; so we must set aside 8 bytes to hold that pointer (and
; initialize it to zero). Finally, the stack must always be
; 16-byte-aligned, so reserve another 8 bytes of storage
; to ensure this.

; Shadow storage for args (always 30h bytes).

	sub	rsp, 030h

; Handle = GetStdHandle(-11);
; Single argument passed in ECX.
; Handle returned in RAX.

	mov	rcx, -11	; STD_OUTPUT Is is to a pin??????????????????? Like arduino/trinket?
	call	qword ptr __imp_GetStdHandle

	mov	qword ptr [rsp + 4 * 8], 0	; 5th argument on stack !!!!!!!!!!! important????????? 
	
	mov	r9, rdi		; Address of "bytesWritten" in R9 - address location of stdout????????? FD 0, 1, 2????
	mov	r8d, hwLen	; Length of string to write in R8D
	lea	rdx, hwStr	; Ptr Ptr POINTER!!!!!!!!!!!!! to string data in RDX
	mov	rcx, rax	; FILE HANDLE (== FILE DESCRIPTOR) passed in RCX
	call	qword ptr __imp_WriteFile
	add	rsp, 38h
	ret
main	ENDP
	END