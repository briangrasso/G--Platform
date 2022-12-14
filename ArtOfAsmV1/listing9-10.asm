; Listing 9-10
;
; Floating-point to string conversion

        option  casemap:none

nl          =       10

            .const
ttlStr      byte    "Listing 9-10", 0
fmtStr1     byte    "f10ToStr: value='%s'", nl, 0
fmtStr2     byte    "fpError: code=%I64d", nl, 0
fmtStr3     byte    "e10ToStr: value='%s'", nl, 0

r10_1       real10  1.2345678901234567
r10_2       real10  0.0000000000000001
r10_3       real10  12345678901234567.0
r10_4       real10  1234567890.1234567
r10_5       real10  994999999999999999.0

e10_1       real10  1.2345678901234567e123
e10_2       real10  1.2345678901234567e-123
e10_3       real10  1.2345678901234567e1
e10_4       real10  1.2345678901234567e-1
e10_5       real10  1.2345678901234567e10
e10_6       real10  1.2345678901234567e-10
e10_7       real10  1.2345678901234567e100
e10_8       real10  1.2345678901234567e-100
e10_9       real10  1.2345678901234567e1000
e10_0       real10  1.2345678901234567e-1000

            .data
r10str_1    byte    32 dup (0)

           
            align   4

; TenTo17 - Holds the value 1.0e+17. Used to get a floating 
;           point number to the range x.xxxxxxxxxxxxe+17

TenTo17     real10  1.0e+17
            
; PotTblN- Hold powers of ten raised to negative powers of two.
            
PotTblN     real10  1.0,
                    1.0e-1,
                    1.0e-2,
                    1.0e-4,
                    1.0e-8,
                    1.0e-16,
                    1.0e-32,
                    1.0e-64,
                    1.0e-128,
                    1.0e-256,
                    1.0e-512,
                    1.0e-1024,
                    1.0e-2048,
                    1.0e-4096                               
                                    
                                            
; PotTblP- Hold powers of ten raised to positive powers of two.
            
            align   4
PotTblP     real10  1.0,
                    1.0e+1,
                    1.0e+2,
                    1.0e+4,
                    1.0e+8,
                    1.0e+16,
                    1.0e+32,
                    1.0e+64,
                    1.0e+128,
                    1.0e+256,
                    1.0e+512,
                    1.0e+1024,
                    1.0e+2048,
                    1.0e+4096
                                    
; ExpTbl- Integer equivalents to the powers in the tables 
;         above.
            
            align   4
ExpTab      dword   0,
                    1,
                    2,
                    4,
                    8,
                    16,
                    32,
                    64,
                    128,
                    256,
                    512,
                    1024,
                    2048,
                    4096
            
            
            .code
            externdef printf:proc
            
; Return program title to C++ program:

            public  getTitle
getTitle    proc
            lea     rax, ttlStr
            ret
getTitle    endp



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
            


;*************************************************************
;
; expToBuf-
;
;  Unsigned integer to buffer.
; Used to output up to 4-digit exponents.
;
; Inputs:
;
;    EAX:   Unsigned integer to convert
;    ECX:   Print width 1-4
;    RDI:   Points at buffer.
;

expToBuf    proc

expWidth    equ     <[rbp+16]>
exp         equ     <[rbp+8]>
bcd         equ     <[rbp-16]>

            push    rdx
            push    rcx     ;At [RBP+16]
            push    rax     ;At [RBP+8]
            push    rbp
            mov     rbp, rsp
            sub     rsp, 16

; Verify exponent digit count is in the range 1-4:

            cmp     rcx, 1
            jb      badExp
            cmp     rcx, 4
            ja      badExp
            mov     rdx, rcx
            
; Verify the actual exponent will fit in the number of digits:

            cmp     rcx, 2
            jb      oneDigit
            je      twoDigits
            cmp     rcx, 3
            ja      fillZeros       ;4 digits, no error
            cmp     eax, 1000
            jae     badExp
            jmp     fillZeros
            
oneDigit:   cmp     eax, 10
            jae     badExp
            jmp     fillZeros
            
twoDigits:  cmp     eax, 100
            jae     badExp
            
            
; Fill in zeros for exponent:

fillZeros:  mov     byte ptr [rdi+rcx*1-1], '0'
            dec     ecx
            jnz     fillZeros
            
; Point RDI at the end of the buffer:

            lea     rdi, [rdi+rdx*1-1]
            mov     byte ptr [rdi+1], 0
            push    rdi                 ;Save pointer to end

; Quick test for zero to handle that special case:

            test    eax, eax
            jz      allDone
            
; The number to convert is non-zero.
; Use BCD load and store to convert
; the integer to BCD:

            fild    dword ptr exp   ;Get integer value
            fbstp   tbyte ptr bcd   ;Convert to BCD
            
; Begin by skipping over leading zeros in
; the BCD value (max 10 digits, so the most
; significant digit will be in the HO nibble
; of byte 4).

            mov     eax, bcd        ;Get exponent digits
            mov     ecx, expWidth   ;Number of total digits
            
OutputExp:  mov     dl, al
            and     dl, 0fh
            or      dl, '0'
            mov     [rdi], dl
            dec     rdi
            shr     ax, 4
            jnz     OutputExp


; Zero-terminte the string and return:
            
allDone:    pop     rdi
            leave
            pop     rax
            pop     rcx
            pop     rdx
            clc
            ret
            
badExp:     leave
            pop     rax
            pop     rcx
            pop     rdx
            stc
            ret
            
expToBuf    endp


;*************************************************************
;                                                                  
; FPDigits-                                                        
;                                                                  
; Used to convert a floating point number on the FPU 
; stack (ST(0)) to a string of digits.                                           
;                                                                  
; Entry Conditions:                                                
;                                                                  
; ST(0)-    80-bit number to convert.                              
; RDI-      Points at array of at least 18 bytes where FPDigits    
;           stores the output string.                      
;                                                                  
; Exit Conditions:                                                 
;                                                                  
; RDI-      Converted digits are found here.                       
; RAX-      Contains exponent of the number.                       
; CL-       Contains the sign of the mantissa (" " or "-").
;                                                                  
;*************************************************************

P10TblN     equ     <real10 ptr [r8]>
P10TblP     equ     <real10 ptr [r9]>
xTab        equ     <dword ptr [r10]>

FPDigits    proc
            push    rbx
            push    rdx
            push    rsi
            push    r8
            push    r9
            push    r10

; Special case if the number is zero.

            
            ftst
            fstsw   ax
            sahf
            jnz     fpdNotZero

; The number is zero, output it as a special case.

            fstp    tbyte ptr [rdi]  ;Pop value off FPU stack.
            mov     rax, "00000000"
            mov     [rdi], rax 
            mov     [rdi+8], rax 
            mov     [rdi+16], ax
            add     rdi, 18 
            xor     edx, edx         ; Return an exponent of 0.
            mov     bl, ' '          ; Sign is positive.
            jmp     fpdDone
                    
fpdNotZero:
            
; If the number is not zero, then fix the sign of the value.
            
            mov     bl, ' '      ; Assume it's positive.
            jnc     WasPositive  ; Flags set from sahf above.
            
            fabs             ; Deal only with positive numbers.
            mov     bl, '-'  ; Set the sign return result.
                    
WasPositive:

; Get the number between one and ten so we can figure out 
; what the exponent is.  Begin by checking to see if we have 
; a positive or negative exponent.
            
            
            xor     edx, edx        ; Initialize exponent to 0.
            fld1
            fcomip  st(0), st(1)
            jbe     PosExp

; We've got a value between zero and one, exclusive, 
; at this point.  That means this number has a negative 
; exponent.  Multiply the number by an appropriate power
; of ten until we get it in the range 1..10.
                    
            mov     esi, sizeof PotTblN     ; After last element.
            mov     ecx, sizeof ExpTab      ; Ditto.
            lea     r8, PotTblN
            lea     r9, PotTblP
            lea     r10, ExpTab

CmpNegExp:
            sub     esi, 10          ; Move to previous element.
            sub     ecx, 4           ; Zeros HO bytes
            jz      test1

            fld     P10TblN[ rsi*1 ] ; Get current power of 10.
            fcomip  st(0), st(1)     ; Compare against NOS.
            jbe     CmpNegExp        ;While Table >= value.

            mov     eax, xTab[ rcx*1 ]
            test    eax, eax
            jz      didAllDigits

            sub     edx, eax
            fld     P10TblP[ rsi*1 ]
            fmulp
            jmp     CmpNegExp

; If the remainder is *exactly* 1.0, then we can branch
; on to InRange1_10, otherwise, we still have to multiply
; by 10.0 because we've overshot the mark a bit.

test1:
            fld1
            fcomip  st(0), st(1)
            je      InRange1_10

didAllDigits:
                            
; If we get to this point, then we've indexed through
; all the elements in the PotTblN and it's time to stop.

            fld     P10TblP[ 10 ]   ; 10.0
            fmulp
            dec     edx
            jmp     InRange1_10
                    
                    
                    
            
;  At this point, we've got a number that is one or greater.
;  Once again, our task is to get the value between 1 and 10.
            
PosExp:
            
            mov     esi, sizeof PotTblP ; After last element.
            mov     ecx, sizeof ExpTab  ; Ditto.
            lea     r9, PotTblP
            lea     r10, ExpTab

CmpPosExp:
            sub     esi, 10         ; Move back 1 element in
            sub     ecx, 4          ;  PotTblP and ExpTbl.
            fld     P10TblP[ rsi*1 ]
            fcomip  st(0), st(1)
            ja      CmpPosExp;
            mov     eax, xTab[ rcx*1 ]
            test    eax, eax
            jz      InRange1_10
            
            add     edx, eax
            fld     P10TblP[ rsi*1 ]
            fdivp
            jmp     CmpPosExp
                    

                            
InRange1_10:

; Okay, at this point the number is in the range 1 <= x < 10,
; Let's multiply it by 1e+18 to put the most significant digit
; into the 18th print position.  Then convert the result to
; a BCD value and store away in memory.

            
            sub     rsp, 24         ; Make room for BCD result.
            fld     TenTo17
            fmulp
            
; We need to check the floating-point result to make sure it
; is not outside the range we can legally convert to a BCD 
; value.
;
; Illegal values will be in the range:
;
;  >999,999,999,999,999,999 ..<1,000,000,000,000,000,000
;      $403a_de0b_6b3a_763f_ff01..$403a_de0b_6b3a_763f_ffff
;
; Should one of these values appear, round the result up to
;
;           $403a_de0b_6b3a_7640_0000
            
            fstp    real10 ptr [rsp]
            cmp     word ptr [rsp+8], 403ah
            jne     noRounding
            
            cmp     dword ptr [rsp+4], 0de0b6b3ah
            jne     noRounding
                    
            mov     eax, [rsp]
            cmp     eax, 763fff01h
            jb      noRounding;
            cmp     eax, 76400000h
            jae     TooBig
                            
            fld     TenTo17
            inc     edx     ;Inc exp as this is really 10^18. 
            jmp     didRound
                                    
; If we get down here, there was some problems getting the
; value in the range 1 <= x <= 10 above and we've got a value
; that is 10e+18 or slightly larger. We need to compensate for
; that here.

TooBig:
            lea     r9, PotTblP
            fld     real10 ptr [rsp]
            fld     P10TblP[ 10 ]   ; /10
            fdivp
            inc     edx             ; Adjust exp due to fdiv.
            jmp     didRound
                            
                                    
noRounding:
            fld     real10 ptr [rsp]
didRound:   
            fbstp   tbyte ptr [rsp]

            
            
; The data on the stack contains 18 BCD digits.  Convert these
; to ASCII characters and store them at the destination location
; pointed at by edi.
            
            mov     ecx, 8
repeatLp:
            mov     al, byte ptr [rsp+rcx]
            shr     al, 4                   ;Always in the
            or      al, '0'                 ; range 0..9
            mov     [rdi], al
            inc     rdi
            
            mov     al, byte ptr [rsp+rcx]
            and     al, 0fh
            or      al, '0'
            mov     [rdi], al
            inc     rdi
            
            dec     ecx     
            jns     repeatLp

            add     rsp, 24         ; Remove BCD data from stack.

fpdDone:

            mov     eax, edx        ; Return exponent in EAX.
            mov     cl, bl          ; Return sign in CL
            pop     r10
            pop     r9
            pop     r8
            pop     rsi
            pop     rdx
            pop     rbx
            ret
                    
                    
FPDigits    endp

      
      
      
      
;***********************************************************
;                                                           
; r10ToStr-                                                 
;                                                           
; Converts a REAL10 floating-point number to the       
; corresponding string of digits.  Note that this           
; function always emits the string using decimal            
; notation.  For scientific notation, use the e10ToBuf      
; routine.                                                  
;                                                           
; On Entry:                                                 
;                                                           
; r10-              Real10 value to convert.
;                   Passed in ST(0).                       
;                                                           
; fWidth-           Field width for the number (note that this   
;                   is an *exact* field width, not a minimum         
;                   field width).
;                   Passed in EAX (RAX).                                    
;                                                           
; decimalpts-       # of digits to display after the decimal pt.
;                   Passed in EDX (RDX). 
;                                                           
; fill-             Padding character if the number is smaller   
;                   than the specified field width.
;                   Passed in CL (RCX).                  
;                                                                            
; buffer-           r10ToStr stores the resulting characters in  
;                   this string.
;                   Address passed in RDI.
;
; maxLength-        Maximum string length.
;                   Passed in R8d (R8).                                     
;                                                                            
; On Exit:                                                  
;                                                           
; Buffer contains the newly formatted string.  If the       
; formatted value does not fit in the width specified,      
; r10ToStr will store "#" characters into this string.      
;                                                           
; Carry-    Clear if success, set if an exception occurs.                                                         
;           If width is larger than the maximum length of          
;           the string specified by buffer, this routine        
;           will return with the carry set and RAX=-1.                                             
;                                                           
;***********************************************************


r10ToStr    proc


; Local variables:

fWidth      equ     <dword ptr [rbp-8]>     ;RAX: uns32
decDigits   equ     <dword ptr [rbp-16]>    ;RDX: uns32
fill        equ     <[rbp-24]>              ;CL: char
bufPtr      equ     <[rbp-32]>              ;RDI: pointer
exponent    equ     <dword ptr [rbp-40]>    ;uns32
sign        equ     <byte ptr [rbp-48]>     ;char
digits      equ     <byte ptr [rbp-128]>    ;char[80]

            push    rdi
            push    rbx
            push    rcx
            push    rdx
            push    rsi
            push    rax
            push    rbp
            mov     rbp, rsp
            sub     rsp, 128        ;128 bytes of local vars

; First, make sure the number will fit into the 
; specified string.
            
            cmp     eax, r8d 
            jae     strOverflow
            
            test    eax, eax
            jz      voor

            mov     bufPtr, rdi
            mov     qword ptr decDigits, rdx
            mov     fill, rcx
            mov     qword ptr fWidth, rax
            
;  If the width is zero, raise an exception:

            test    eax, eax
            jz      voor
            
; If the width is too big, raise an exception:

            cmp     eax, fWidth
            ja      badWidth        

; Okay, do the conversion. 
; Begin by processing the mantissa digits:
                    
            lea     rdi, digits     ; Store result here.
            call    FPDigits        ; Convert r80 to string.
            mov     exponent, eax   ; Save away exp result.
            mov     sign, cl        ; Save mantissa sign char.

; Round the string of digits to the number of significant 
; digits we want to display for this number:

            cmp     eax, 17
            jl      dontForceWidthZero

            xor     rax, rax        ; If the exp is negative, or
                                    ; too large, set width to 0.
dontForceWidthZero:
            mov     rbx, rax        ; Really just 8 bits.
            add     ebx, decDigits  ; Compute rounding position.
            cmp     ebx, 17
            jge     dontRound       ; Don't bother if a big #.


; To round the value to the number of significant digits,
; go to the digit just beyond the last one we are considering
; (eax currently contains the number of decimal positions)
; and add 5 to that digit.  Propagate any overflow into the
; remaining digit positions.
                    
                    
            inc     ebx           ; Index+1 of last sig digit.
            mov     al, digits[rbx*1] ; Get that digit.
            add     al, 5             ; Round (e.g., +0.5 ).
            cmp     al, '9'
            jbe     dontRound

            mov     digits[ rbx*1 ], '0'+10 ; Force to zero
whileDigitGT9:                              ; (see sub 10 below).
            sub     digits[ rbx*1 ], 10     ; Sub out overflow, 
            dec     ebx                     ; carry, into prev
            js      hitFirstDigit;          ; digit (until 1st
                                            ;  digit in the #).
            inc     digits[rbx*1]
            cmp     digits[rbx], '9'        ; Overflow if > '9'.
            ja      whileDigitGT9
            jmp     dontRound
            
                                    
hitFirstDigit:
                                            
; If we get to this point, then we've hit the first
; digit in the number.  So we've got to shift all
; the characters down one position in the string of
; bytes and put a "1" in the first character position.
            
            mov     ebx, 17
repeatUntilEBXeq0:
            
            mov     al, digits[rbx*1]
            mov     digits[rbx*1+1], al
            dec     ebx     
            jnz     repeatUntilEBXeq0
                    
            mov     digits, '1'
            inc     exponent    ; Because we added a digit.
                    
dontRound: 
                    
            
; Handle positive and negative exponents separately.

            mov     rdi, bufPtr ; Store the output here.
            cmp     exponent, 0
            jge     positiveExponent

; Negative exponents:
; Handle values between 0 & 1.0 here (negative exponents
; imply negative powers of ten).
;
; Compute the number's width.  Since this value is between
; 0 & 1, the width calculation is easy: it's just the
; number of decimal positions they've specified plus three
; (since we need to allow room for a leading "-0.").
                    
            
            mov     ecx, decDigits
            add     ecx, 3
            cmp     ecx, 4
            jae     minimumWidthIs4

            mov     ecx, 4  ; Minimum possible width is four.

minimumWidthIs4:
            cmp     ecx, fWidth
            ja      widthTooBig 
            
; This number will fit in the specified field width,
; so output any necessary leading pad characters.
            
            mov     al, fill
            mov     edx, fWidth
            sub     edx, ecx
            jmp     testWhileECXltWidth
            
            
whileECXltWidth:
            mov     [rdi], al
            inc     rdi
            inc     ecx
testWhileECXltWidth:
            cmp     ecx, fWidth
            jb      whileECXltWidth
                            
; Output " 0." or "-0.", depending on the sign of the number.
            
            mov     al, sign
            cmp     al, '-'
            je      isMinus
                    
            mov     al, ' '
            
isMinus:    mov     [rdi], al
            inc     rdi
            inc     edx
                    
            mov     word ptr [rdi], '.0'
            add     rdi, 2
            add     edx, 2
            
; Now output the digits after the decimal point:

            xor     ecx, ecx        ; Count the digits in ecx.
            lea     rbx, digits     ; Pointer to data to output.
                                    
; If the exponent is currently negative, or if
; we've output more than 18 significant digits,
; just output a zero character.
            
repeatUntilEDXgeWidth: 
            mov     al, '0'
            inc     exponent
            js      noMoreOutput
            
            cmp     ecx, 18
            jge     noMoreOutput
            
            mov     al, [rbx]
            inc     ebx
                    
noMoreOutput:
            mov     [rdi], al
            inc     rdi
            inc     ecx
            inc     edx
            cmp     edx, fWidth
            jb      repeatUntilEDXgeWidth
            jmp     r10BufDone


; If the number's actual width was bigger than the width
; specified by the caller, emit a sequence of '#' characters
; to denote the error.
                            
widthTooBig:
            

; The number won't fit in the specified field width,
; so fill the string with the "#" character to indicate
; an error.
                    
                    
            mov     ecx, fWidth
            mov     al, '#'
fillPound:  mov     [rdi], al
            inc     rdi
            dec     ecx
            jnz     fillPound
            jmp     r10BufDone

            
; Handle numbers with a positive exponent here.

positiveExponent:
            
; Compute # of digits to the left of the ".".
; This is given by:
;
;                   Exponent     ; # of digits to left of "."
;           +       2            ; Allow for sign and there
;                                ; is always 1 digit left of "."
;           +       decimalpts   ; Add in digits right of "."
;           +       1            ; If there is a decimal point.
            

            mov     edx, exponent   ; Digits to left of "."
            add     edx, 2          ; 1 digit + sign posn.
            cmp     decDigits, 0
            je      decPtsIs0

            add     edx, decDigits  ; Digits to right of "."
            inc     edx             ; Make room for the "."
            
decPtsIs0:
            
; Make sure the result will fit in the
; specified field width.
            
            cmp     edx, fWidth
            ja      widthTooBig
            
                    
; If the actual number of print positions
; is less than the specified field width,
; output leading pad characters here.
            
            cmp     edx, fWidth
            jae     noFillChars
            
            mov     ecx, fWidth
            sub     ecx, edx
            jz      noFillChars
            mov     al, fill
fillChars:  mov     [rdi], al
            inc     rdi
            dec     ecx
            jnz     fillChars
                    
noFillChars:
            
            
; Output the sign character.
            
            mov     al, sign
            cmp     al, '-'
            je      outputMinus;
            
            mov     al, ' '
                    
outputMinus:
            mov     [rdi], al
            inc     rdi
                    
; Okay, output the digits for the number here.
            
            
            xor     ecx, ecx        ; Counts  # of output chars.
            lea     rbx, digits     ; Ptr to digits to output.
            
            
; Calculate the number of digits to output
; before and after the decimal point.
            
            
            mov     edx, decDigits  ; Chars after "."
            add     edx, exponent   ; # chars before "."
            inc     edx             ; Always one digit before "."
            
                    
; If we've output fewer than 18 digits, go ahead
; and output the next digit.  Beyond 18 digits,
; output zeros.
            
repeatUntilEDXeq0:
            mov     al, '0'
            cmp     ecx, 18
            jnb     putChar
            
            mov     al, [rbx]
            inc     rbx

putChar:    mov     [rdi], al
            inc     rdi     
            
; If the exponent decrements down to zero,
; then output a decimal point.
            
            cmp     exponent, 0
            jne     noDecimalPt
            cmp     decDigits, 0
            je      noDecimalPt
            
            mov     al, '.'
            mov     [rdi], al
            inc     rdi
                    
noDecimalPt:
            dec     exponent      ; Count down to "." output.
            inc     ecx           ; # of digits thus far.
            dec     edx           ; Total # of digits to output.
            jnz     repeatUntilEDXeq0
                    

; Zero-terminate string and leave:
            
r10BufDone: mov     byte ptr [rdi], 0
            leave
            clc     ;No error
            jmp     popRet

badWidth:   mov     rax, -2 ;Illegal character
            jmp     ErrorExit
            
strOverflow:
            mov     rax, -3 ;String overflow
            jmp     ErrorExit

voor:       or      rax, -1 ;Range error
ErrorExit:  leave
            stc     ;Error
            mov     [rsp], rax      ;Change RAX on return
            
popRet:     pop     rax
            pop     rsi
            pop     rdx
            pop     rcx
            pop     rbx
            pop     rdi
            ret

r10ToStr    endp



;***********************************************************
;                                                           
; eToStr-                                                   
;                                                           
; Converts a REAL10 floating-point number to the       
; corresponding string of digits.  Note that this           
; function always emits the string using scientific                  
; notation, use the r10ToStr routine for decimal notation.   
;                                                           
; On Entry:                                                 
;                                                           
;    e10-           Real10 value to convert.
;                   Passed in ST(0)                     
;                                                           
;    width-         Field width for the number (note that this   
;                   is an *exact* field width, not a minimum     
;                   field width).
;                   Passed in RAX (LO 32 bits).                                
;                                                           
;    fill-          Padding character if the number is smaller   
;                   than the specified field width.
;                   Passed in RCX.                  
;                                                                            
;    buffer-        e10ToStr stores the resulting characters in  
;                   this buffer (passed in EDI).
;                   Passed in RDI (LO 32 bits).                 
;                                                           
;    expDigs-       Number of exponent digits (2 for real4,     
;                   3 for real8, and 4 for real10).
;                   Passed in RDX (LO 8 bits)             
;                                                                            
;
;    maxLength-     Maximum buffer size.
;                   Passed in R8.                                     
; On Exit:                                                  
;                                                           
;    Buffer contains the newly formatted string.  If the    
;    formatted value does not fit in the width specified,   
;    e10ToStr will store "#" characters into this string.   
;                                                           
;-----------------------------------------------------------
;                                                           
; Unlike the integer to string conversions, this routine    
; always right justifies the number in the specified        
; string.  Width must be a positive number, negative        
; values are illegal (actually, they are treated as         
; *really* big positive numbers which will always raise     
; a string overflow exception.                              
;                                                           
;***********************************************************

e10ToStr    proc

fWidth      equ     <[rbp-8]>       ;RAX
buffer      equ     <[rbp-16]>      ;RDI
expDigs     equ     <[rbp-24]>      ;RDX
rbxSave     equ     <[rbp-32]>
rcxSave     equ     <[rbp-40]>
rsiSave     equ     <[rbp-48]>
Exponent    equ     <dword ptr [rbp-52]>
MantSize    equ     <dword ptr [rbp-56]>
Sign        equ     <byte ptr [rbp-60]>
Digits      equ     <byte ptr [rbp-128]>

            push    rbp
            mov     rbp, rsp
            sub     rsp, 128
	
            cmp     eax, r8d
            jae     strOvfl
            mov     byte ptr [rdi+rax*1], 0 ; 0-terminate str
	
            
            mov     buffer, rdi
            mov     rsiSave, rsi
            mov     rcxSave, rcx
            mov     rbxSave, rbx
            mov     fWidth, rax
            mov     expDigs, rdx
            
; First, make sure the width isn't zero.
            
            test    eax, eax
            jz      voor

; Just to be on the safe side, don't allow widths greater 
; than 1024:

            cmp     eax, 1024
            ja      badWidth

; Okay, do the conversion.

            lea     rdi, Digits     ; Store result string here.
            call    FPDigits        ; Convert e80 to digit str.
            mov     Exponent, eax   ; Save away exponent result.
            mov     Sign, cl        ; Save mantissa sign char.

; Verify that there is sufficient room for the mantissa's sign,
; the decimal point, two mantissa digits, the "E", 
; and the exponent's sign.  Also add in the number of digits
; required by the exponent (2 for real4, 3 for real8, 4 for 
; real10).
;
; -1.2e+00    :real4
; -1.2e+000   :real8
; -1.2e+0000  :real10
            
            
            mov     ecx, 6          ; Char posns for above chars.
            add     ecx, expDigs    ; # of digits for the exp.
            cmp     ecx, fWidth
            jbe     goodWidth
            
; Output a sequence of "#...#" chars (to the specified width)
; if the width value is not large enough to hold the 
; conversion:

            mov     ecx, fWidth
            mov     al, '#'
            mov     rdi, buffer
fillPound:  mov     [rdi], al
            inc     rdi
            dec     ecx
            jnz     fillPound
            jmp     exit_eToBuf


; Okay, the width is sufficient to hold the number, do the
; conversion and output the string here:

goodWidth:
            
            mov     ebx, fWidth     ; Compute the # of mantissa
            sub     ebx, ecx        ; digits to display.
            add     ebx, 2          ; ECX allows for 2 mant digs.
            mov     MantSize,ebx
                    
            
; Round the number to the specified number of print positions.
; (Note: since there are a maximum of 18 significant digits,
;  don't bother with the rounding if the field width is greater
;  than 18 digits.)
            
            
            cmp     ebx, 18
            jae     noNeedToRound
                    
; To round the value to the number of significant digits,
; go to the digit just beyond the last one we are considering
; (ebx currently contains the number of decimal positions)
; and add 5 to that digit.  Propagate any overflow into the
; remaining digit positions.
            
            mov     al, Digits[rbx*1] ; Get least sig digit + 1.
            add     al, 5             ; Round (e.g., +0.5 ).
            cmp     al, '9'
            jbe     noNeedToRound
            mov     Digits[rbx*1], '9'+1
            jmp     whileDigitGT9Test
whileDigitGT9:                      

; Subtract out overflow and add the carry into the previous
; digit (unless we hit the first digit in the number).

            sub     Digits[ rbx*1 ], 10     
            dec     ebx                     
            cmp     ebx, 0                  
            jl      firstDigitInNumber      
                                                                    
            inc     Digits[rbx*1]
            jmp     whileDigitGT9Test

firstDigitInNumber:

; If we get to this point, then we've hit the first
; digit in the number.  So we've got to shift all
; the characters down one position in the string of
; bytes and put a "1" in the first character position.
            
            mov     ebx, 17
repeatUntilEBXeq0:
            
            mov     al, Digits[rbx*1]
            mov     Digits[rbx*1+1], al
            dec     ebx
            jnz     repeatUntilEBXeq0
                    
            mov     Digits, '1'
            inc     Exponent         ; Because we added a digit.
            jmp     noNeedToRound
            
                    
whileDigitGT9Test:
            cmp     Digits[rbx], '9' ; Overflow if char > '9'.
            ja      whileDigitGT9 
            
noNeedToRound:      
            
; Okay, emit the string at this point.  This is pretty easy
; since all we really need to do is copy data from the
; digits array and add an exponent (plus a few other simple chars).
            
            xor     ecx, ecx    ; Count output mantissa digits.
            mov     rdi, buffer
            xor     edx, edx    ; Count output chars.
            mov     al, Sign
            cmp     al, '-'
            je      noMinus
            
            mov     al, ' '
                    
noMinus:    mov     [rdi], al
            
; Output the first character and a following decimal point
; if there are more than two mantissa digits to output.
            
            mov     al, Digits
            mov     [rdi+1], al
            add     rdi, 2
            add     edx, 2
            inc     ecx
            cmp     ecx, MantSize
            je      noDecPt
            
            mov     al, '.'
            mov     [rdi], al
            inc     rdi
            inc     edx     
                                    
noDecPt:
            
; Output any remaining mantissa digits here.
; Note that if the caller requests the output of
; more than 18 digits, this routine will output zeros
; for the additional digits.
            
            jmp     whileECXltMantSizeTest
            
whileECXltMantSize:
            
            mov     al, '0'
            cmp     ecx, 18
            jae     justPut0

            mov     al, Digits[ rcx*1 ]
                    
justPut0:
            mov     [rdi], al
            inc     rdi
            inc     ecx
            inc     edx
            
whileECXltMantSizeTest:
            cmp     ecx, MantSize
            jb      whileECXltMantSize

; Output the exponent:
            
            mov     byte ptr [rdi], 'e'
            inc     rdi
            inc     edx
            mov     al, '+'
            cmp     Exponent, 0
            jge     noNegExp
            
            mov     al, '-'
            neg     Exponent
                                            
noNegExp:
            mov     [rdi], al
            inc     rdi
            inc     edx
            
            mov     eax, Exponent
            mov     ecx, expDigs
            call    expToBuf
            jc      error
                    
exit_eToBuf:
            mov     rsi, rsiSave
            mov     rcx, rcxSave
            mov     rbx, rbxSave
            mov     rax, fWidth
            mov     rdx, expDigs
            leave
            clc
            ret

strOvfl:    mov     rax, -3
            jmp     error

badWidth:   mov     rax, -2
            jmp     error
	
voor:       mov     rax, -1
error:      mov     rsi, rsiSave
            mov     rcx, rcxSave
            mov     rbx, rbxSave
            mov     rdx, expDigs
            leave
            stc
            ret

e10ToStr   endp

                        
            
; Here is the "asmMain" function.

        
            public  asmMain
asmMain     proc
            push    rbx
            push    rsi
            push    rdi
            push    rbp
            mov     rbp, rsp
            sub     rsp, 64         ;Shadow storage
            and     rsp, -16
            
; F output

            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 16         ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 15         ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 14         ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 13         ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 12         ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 11         ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 10         ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 9          ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 8          ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 7          ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 6          ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 5          ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 4          ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 3          ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 2          ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 1          ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
            fld     r10_1
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 0          ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            


            fld     r10_2
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 16         ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            

            fld     r10_3
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 1          ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            

            fld     r10_4
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 6          ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            

            fld     r10_5
            lea     rdi, r10str_1
            mov     eax, 30         ;fWidth
            mov     edx, 1          ;decimalPts
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    r10ToStr
            jc      fpError
            
            lea     rcx, fmtStr1
            lea     rdx, r10str_1
            call    printf
            
; E output

            fld     e10_1
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 3          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf

            fld     e10_2
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 3          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf

            fld     e10_3
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 3          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf

            fld     e10_4
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 3          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf

            fld     e10_5
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 3          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf

            fld     e10_6
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 3          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1

            fld     e10_7
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 3          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf

            fld     e10_8
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 3          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf

            fld     e10_9
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 4          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf

            fld     e10_0
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 4          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            
            

            fld     e10_3
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 1          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            
            fld     e10_3
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 2          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            fld     e10_3
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 3          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            fld     e10_3
            lea     rdi, r10str_1
            mov     eax, 26         ;fWidth
            mov     edx, 4          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf


            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            fld     e10_3
            lea     rdi, r10str_1
            mov     eax, 25         ;fWidth
            mov     edx, 1          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            fld     e10_3
            lea     rdi, r10str_1
            mov     eax, 20         ;fWidth
            mov     edx, 1          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            
            fld     e10_3
            lea     rdi, r10str_1
            mov     eax, 15         ;fWidth
            mov     edx, 1          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            
            fld     e10_3
            lea     rdi, r10str_1
            mov     eax, 10         ;fWidth
            mov     edx, 1          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            
            fld     e10_3
            lea     rdi, r10str_1
            mov     eax, 9          ;fWidth
            mov     edx, 1          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            
            fld     e10_3
            lea     rdi, r10str_1
            mov     eax, 8          ;fWidth
            mov     edx, 1          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            
            fld     e10_3
            lea     rdi, r10str_1
            mov     eax, 7          ;fWidth
            mov     edx, 1          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            
            fld     e10_3
            lea     rdi, r10str_1
            mov     eax, 6          ;fWidth
            mov     edx, 1          ;expDigits
            mov     ecx, '*'        ;Fill
            mov     r8d, 32         ;maxLength
            call    e10ToStr
            jc      fpError
            
            lea     rcx, fmtStr3
            lea     rdx, r10str_1
            call    printf
            
            
            
            
            jmp     allDone
            
fpError:    lea     rcx, fmtStr2
            mov     rdx, rax
            call    printf 
            
 

             
allDone:    leave
            pop     rdi
            pop     rsi
            pop     rbx
            ret     ;Returns to caller
asmMain     endp
            end