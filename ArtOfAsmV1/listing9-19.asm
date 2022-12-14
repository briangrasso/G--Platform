; Listing 9-19
;
; Real string to floating-point conversion

        option  casemap:none

false       =       0
true        =       1
tab         =       9
nl          =       10

            .const
ttlStr      byte    "Listing 9-19", 0
fmtStr1     byte    "strToR10: str='%s', value=%e", nl, 0
           
fStr1a      byte    "1.234e56",0
fStr1b      byte    "-1.234e56",0
fStr1c      byte    "1.234e-56",0
fStr1d      byte    "-1.234e-56",0
fStr2a      byte    "1.23",0
fStr2b      byte    "-1.23",0
fStr3a      byte    "1",0
fStr3b      byte    "-1",0
fStr4a      byte    "0.1",0
fStr4b      byte    "-0.1",0
fStr4c      byte    "0000000.1",0
fStr4d      byte    "-0000000.1",0
fStr4e      byte    "0.1000000",0
fStr4f      byte    "-0.1000000",0
fStr4g      byte    "0.0000001",0
fStr4h      byte    "-0.0000001",0
fStr4i      byte    ".1",0
fStr4j      byte    "-.1",0

values      qword   fStr1a, fStr1b, fStr1c, fStr1d,
                    fStr2a, fStr2b,
                    fStr3a, fStr3b,
                    fStr4a, fStr4b, fStr4c, fStr4d,
                    fStr4e, fStr4f, fStr4g, fStr4h,
                    fStr4i, fStr4j,
                    0






            align   4
PotTbl      real10  1.0e+4096,
                    1.0e+2048,
                    1.0e+1024,
                    1.0e+512,
                    1.0e+256,
                    1.0e+128,
                    1.0e+64,
                    1.0e+32,
                    1.0e+16,
                    1.0e+8,
                    1.0e+4,
                    1.0e+2,
                    1.0e+1,
                    1.0e+0

            .data
r8Val       real8   ?

            
            .code
            externdef printf:proc
            
; Return program title to C++ program:

            public  getTitle
getTitle    proc
            lea     rax, ttlStr
            ret
getTitle    endp


; Used for debugging:

print       proc
            push    rax
            push    rbx
            push    rcx
            push    rdx
            push    r8
            push    r9
            push    r10
            push    r11
            
            push    rbp
            mov     rbp, rsp
            sub     rsp, 40
            and     rsp, -16
            
            mov     rcx, [rbp+72]   ;Return address
            call    printf
            
            mov     rcx, [rbp+72]
            dec     rcx
skipTo0:    inc     rcx
            cmp     byte ptr [rcx], 0
            jne     skipTo0
            inc     rcx
            mov     [rbp+72], rcx
            
            leave
            pop     r11
            pop     r10
            pop     r9
            pop     r8
            pop     rdx
            pop     rcx
            pop     rbx
            pop     rax
            ret
print       endp

;*********************************************************
;                                                         
; strToR10-                                                   
;                                                         
; RSI points at a string of characters that represent a   
; floating point value.  This routine converts that string
; to the corresponding FP value and leaves the result on  
; the top of the FPU stack.  On return, ESI points at the 
; first character this routine couldn't convert.          
;                                                         
; Like the other ATOx routines, this routine raises an    
; exception if there is a conversion error or if ESI      
; contains NULL.                                          
;                                                         
;*********************************************************


strToR10    proc

sign        equ     <cl>
expSign     equ     <ch>

DigitStr    equ     <[rbp-24]>
BCDValue    equ     <[rbp-34]>
rsiSave     equ     <[rbp-44]>

            push    rbp
            mov     rbp, rsp
            sub     rsp, 44
	            
            push    rbx
            push    rcx
            push    rdx
            push    r8
            push    rax
            
; Verify that RSI is not NULL.
            
            test    rsi, rsi
            jz      refNULL
                    
; Zero out the DigitStr and BCDValue arrays.
            
            xor     rax, rax
            mov     qword ptr DigitStr, rax
            mov     qword ptr DigitStr[8], rax
            mov     dword ptr DigitStr[16], eax
            
            mov     qword ptr BCDValue, rax
            mov     word ptr BCDValue[8], ax
            
; Skip over any leading space or tab characters in the sequence.
            
            dec     rsi
whileDelimLoop:
            inc     rsi
            mov     al, [rsi]
            cmp     al, ' '
            je      whileDelimLoop
            cmp     al, tab
            je      whileDelimLoop
                    
            
            
; Check for + or -
            
            cmp     al, '-'
            sete    sign
            je      doNextChar
            cmp     al, '+'
            jne     notPlus
doNextChar: inc     rsi             ; Skip the '+' or '-'
            mov     al, [rsi]

notPlus:
            
; Initialize edx with -18 since we have to account
; for BCD conversion (which generates a number *10^18 by
; default). EDX holds the value's decimal exponent.
            
            mov     rdx, -18
            
; Initialize ebx with 18, the number of significant
; digits left to process and also the index into the
; DigitStr array.
            
            mov     ebx, 18         ;Zero extends!
            
; At this point we're beyond any leading sign character.
; Therefore, the next character must be a decimal digit
; or a decimal point.

            mov     rsiSave, rsi    ; Save to look ahead 1 digit.
            cmp     al, '.'
            jne     notPeriod

; If the first character is a decimal point, then the
; second character needs to be a decimal digit.
                            
            inc     rsi
            mov     al, [rsi]
                    
notPeriod:
            cmp     al, '0'
            jb      convError
            cmp     al, '9'
            ja      convError
            mov     rsi, rsiSave    ; Go back to orig char
            mov     al, [rsi]
            jmp     testWhlAL0

; Eliminate any leading zeros (they do not affect the value or
; the number of significant digits).
            
            
whileAL0:   inc     rsi
            mov     al, [rsi]
testWhlAL0: cmp     al, '0'
            je      whileAL0
            
; If we're looking at a decimal point, we need to get rid of the
; zeros immediately after the decimal point since they don't
; count as significant digits.  Unlike zeros before the decimal
; point, however, these zeros do affect the number's value as
; we must decrement the current exponent for each such zero.
            
            cmp     al, '.'
            jne     testDigit
            
            inc     edx     ;Counteract dec below   
repeatUntilALnot0:
            dec     edx
            inc     rsi
            mov     al, [rsi]
            cmp     al, '0'
            je      repeatUntilALnot0
            jmp     testDigit2
            
        
; If we didn't encounter a decimal point after removing leading
; zeros, then we've got a sequence of digits before a decimal
; point.  Process those digits here.
;
; Each digit to the left of the decimal point increases
; the number by an additional power of ten.  Deal with
; that here.
            
whileADigit:
            inc     edx     

; Save all the significant digits, but ignore any digits
; beyond the 18th digit.
            
            test    ebx, ebx
            jz      Beyond18
            
            mov     DigitStr[ rbx*1 ], al
            dec     ebx
                    
Beyond18:   inc     rsi
            mov     al, [rsi]
                    
testDigit:  
            sub     al, '0'
            cmp     al, 10
            jb      whileADigit

            cmp     al, '.'-'0'
            jne     testDigit2

            inc     rsi             ; Skip over decimal point.
            mov     al, [rsi]
            jmp     testDigit2
            
; Okay, process any digits to the right of the decimal point.
            
            
whileDigit2:
            test    ebx, ebx
            jz      Beyond18_2      
            
            mov     DigitStr[ rbx*1 ], al
            dec     ebx
                    
Beyond18_2: inc     rsi
            mov     al, [rsi]
                    
testDigit2: sub     al, '0'
            cmp     al, 10
            jb      whileDigit2
                            
                    
; At this point, we've finished processing the mantissa.
; Now see if there is an exponent we need to deal with.

            mov     al, [rsi]       
            cmp     al, 'E'
            je      hasExponent
            cmp     al, 'e'
            jne     noExponent
            
hasExponent:
            inc     rsi
            mov     al, [rsi]       ; Skip the "E".
            cmp     al, '-'
            sete    expSign
            je      doNextChar_2
            cmp     al, '+'
            jne     getExponent;
            
doNextChar_2:
            inc     rsi             ;Skip '+' or '-'
            mov     al, [rsi]
                    
            
; Okay, we're past the "E" and the optional sign at this
; point.  We must have at least one decimal digit.
            
getExponent:
            sub     al, '0'
            cmp     al, 10
            jae     convError
            
            xor     ebx, ebx        ; Compute exponent value in ebx.
ExpLoop:    movzx   eax, byte ptr [rsi] ;Zero extends to rax!
            sub     al, '0'
            cmp     al, 10
            jae     ExpDone
            
            imul    ebx, 10
            add     ebx, eax
            inc     rsi
            jmp     ExpLoop
            
            
; If the exponent was negative, negate our computed result.
            
ExpDone:
            cmp     expSign, false
            je      noNegExp
            
            neg     ebx
                    
noNegExp:

; Add in the BCD adjustment (remember, values in DigitStr, when
; loaded into the FPU, are multiplied by 10^18 by default.
; The value in edx adjusts for this).
            
            add     edx, ebx
            
noExponent:
                    
; verify that the exponent is between -4930..+4930 (which
; is the maximum dynamic range for an 80-bit FP value).

            cmp     edx, 4930
            jg      voor            ; Value out of range
            cmp     edx, -4930
            jl      voor
            
            
; Now convert the DigitStr variable (unpacked BCD) to a packed
; BCD value.

            mov     r8, 8
for8:       mov     al, DigitStr[ r8*2 + 2]
            shl     al, 4
            or      al, DigitStr[ r8*2 +1 ]
            mov     BCDValue[ r8*1], al

            dec     r8
            jns     for8

            fbld    tbyte ptr BCDValue
            
            
; Okay, we've got the mantissa into the FPU.  Now multiply the
; Mantissa by 10 raised to the value of the computed exponent
; (currently in edx).
;
; This code uses power of 10 tables to help make the 
; computation a little more accurate.
;
; We want to determine which power of ten is just less than the
; value of our exponent.  The powers of ten we are checking are
; 10**4096, 10**2048, 10**1024, 10**512, etc.  A slick way to
; do this check is by shifting the bits in the exponent
; to the left.  Bit #12 is the 4096 bit.  So if this bit is set,
; our exponent is >= 10**4096.  If not, check the next bit down
; to see if our exponent >= 10**2048, etc.

            mov     ebx, -10 ; Initial index into power of ten table.
            test    edx, edx
            jns     positiveExponent
            
; Handle negative exponents here.
            
            neg     edx
            shl     edx, 19 ; Bits 0..12 -> 19..31
            lea     r8, PotTbl
whileEDXne0:
            add     ebx, 10
            shl     edx, 1
            jnc     testEDX0
            
            fld     real10 ptr [r8][ rbx*1 ]
            fdivp
                    
testEDX0:   test    edx, edx
            jnz     whileEDXne0
            jmp     doMantissaSign


; Handle positive exponents here.
                    
positiveExponent:
            lea     r8, PotTbl
            shl     edx, 19 ; Bits 0..12 -> 19..31.
            jmp     testEDX0_2

whileEDXne0_2:
            add     ebx, 10
            shl     edx, 1
            jnc     testEDX0_2
            
            fld     real10 ptr [r8][ rbx*1 ]
            fmulp
            
testEDX0_2: test    edx, edx
            jnz     whileEDXne0_2


; If the mantissa was negative, negate the result down here.

doMantissaSign:
            cmp     sign, false
            je      mantNotNegative
            
            fchs
                    
mantNotNegative:
            clc             ;Indicate Success
            jmp     Exit    

refNULL:    mov     rax, -3
            jmp     ErrorExit

convError:  mov     rax, -2
            jmp     ErrorExit

voor:       mov     rax, -1 ;Value out of range
            jmp     ErrorExit

illChar:    mov     rax, -4

ErrorExit:  stc                     ;Indicate failure
            mov     [rsp], rax      ;Save error code
Exit:       pop     rax
            pop     r8                      
            pop     rdx
            pop     rcx
            pop     rbx
            leave
            ret

strToR10    endp


            
                    
            
; Here is the "asmMain" function.

        
            public  asmMain
asmMain     proc
            push    rbx
            push    rsi
            push    rbp
            mov     rbp, rsp
            sub     rsp, 64         ;Shadow storage
            

; Test floating-point conversion:
            
            lea     rbx, values
ValuesLp:   cmp     qword ptr [rbx], 0
            je      allDone
            
            mov     rsi, [rbx]
            call    strToR10
            fstp    r8Val
            
            lea     rcx, fmtStr1
            mov     rdx, [rbx]
            mov     r8, qword ptr r8Val
            call    printf
            add     rbx, 8
            jmp     ValuesLp            
 

             
allDone:    leave
            pop     rsi
            pop     rbx
            ret     ;Returns to caller
asmMain     endp
            end