; inclusion file to call assembly functions
			
			.code

			option	casemap:none

	public myProc			
		myProc	proc
			ret
		myProc	endp

	public asmFunc
		asmFunc	PROC
			ret
		asmFunc	ENDP
			END