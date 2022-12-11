; Listing 16-1.asm

; A stand-alone assembly language version of "Hello, World!"

; Link in the Windows Win32 API:
	
			includelib kernel32.lib

; Here are the two Windows functions we will need
; to send "Hello, world!" to the standard console device:

			extrn __imp_GetStdHandle:proc
			extrn __imp_WriteFile:proc

			.code

		hwStr	byte	"Hello, World!"
		hwLen	=	$-hwStr

;complete main script

main		proc

; stack alignment 8 mod 16
; sets aside 8 bytes for "bytesWritten"
; makes sure CALLS (systemcall) in main have THEIR stacks aligned to 16 bytes (8 mod 16 INSIDE function)
; as REQUIRED by the Windows API (which __imp_GetStdHandle and
; __imp_WriteFile use. They are written in C\C++)

			lea	rbx, hwStr
			sub	rsp, 8
			mov	rdi, rsp		; Hold # of bytes written here RDI!!!!!!!!

; MUST set aside 32 bytes (20h) for shadow registers 
; for parameters (just do this once FOR ALL ARGUMENTS - i.e struct memory???)
; Also, WriteFile has a 5th argument (WHICH IS NULL!!!!!!!!!!!!!!!!!!!!!!)
; we MUST set aside 8 bytes to hold that pointer (initialize to zero)
; STACK MUST ALWAYS BE 16-BYTE-ALIGNED, SO RESERVE ANOTHER 8 BYTES OF STORAGE TO ENSURE THIS

			sub	rsp, 030h		; Shadow storage for args!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

; Handle = GetHandle(-11);
; Single argument passed in ECX.
; !!!!!!! HANDLE RETURNED IN RAX !~BITCOIN~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

			mov	rcx, -11				; STD_OUTPUT
			call	qword ptr __imp_GetStdHandle		; Returns Handle!!!!!!!!!!!!!
			
; WriteFile(handle, "Hello, World!", 12, &bytesWritten, NULL);
; Zero out (set to NULL) "lpOverlapped" argument:

			xor	rcx, rcx
			mov	[rsp + 4 * 8], rcx

			mov	r9, rdi			; Address of "bytesWritten" in R9
			mov	r8d, hwLen		; Length of string to write in R8D
			lea	rdx, hwStr		; Ptr to string data in RDX
			mov	rcx, rax		; File handle passed in RCX !!!!!!!!!!!!!!!!!
			call	qword ptr __imp_WriteFile

; Clean up stack and return:
			
			add	rsp, 38h
			ret
main			endp
			end