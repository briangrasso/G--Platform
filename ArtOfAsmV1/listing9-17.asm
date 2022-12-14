; Listing 9-173
;
; 64-bit unsigned decimal string to numeric conversion

        option  casemap:none

false       =       0
true        =       1
tab         =       9
nl          =       10

            .const
ttlStr      byte    "Listing 9-17", 0
fmtStr1     byte    "strtou: String='%s' value=%I64u", nl, 0
fmtStr2     byte    "strtou: error, rax=%d", nl, 0
           
qStr      byte    "12345678901234567", 0

            
            .code
            externdef printf:proc
            
; Return program title to C++ program:

            public  getTitle
getTitle    proc
            lea     rax, ttlStr
            ret
getTitle    endp




; strtou-
;  Converts string data to a 64-bit unsigned integer.
;
; Input-
;   RDI-    Pointer to buffer containing string to convert
;
; Output-
;   RAX-    Contains converted string (if success), error code
;           if an error occurs.
;
;   RDI-    Points at first char beyond end of numeric string.
;           If error, RDI's value is restored to original value.
;           Caller can check character at [RDI] after a
;           successful result to see if the character following
;           the numeric digits is a legal numeric delimiter.
;
;   C       (carry flag) Set if error occurs, clear if
;           conversion was successful. On error, RAX will
;           contain 0 (illegal initial character) or
;           0ffffffffffffffffh (overflow).

strtou      proc
            push    rcx      ;Holds input char
            push    rdx      ;Save, used for multiplication
            push    rdi      ;In case we have to restore RDI
            
            xor     rax, rax ;Zero out accumulator
            
                        
; The following loop skips over any whitespace (spaces and
; tabs) that appear at the beginning of the string.

            dec     rdi      ;Because of inc below.
skipWS:     inc     rdi
            mov     cl, [rdi]
            cmp     cl, ' '
            je      skipWS
            cmp     al, tab
            je      skipWS
            
; If we don't have a numeric digit at this point,
; return an error.

            cmp     cl, '0'  ;Note: '0' < '1' < ... < '9'
            jb      badNumber
            cmp     cl, '9'
            ja      badNumber
            
; Okay, the first digit is good. Convert the string
; of digits to numeric form:

convert:    and     ecx, 0fh ;Convert to numeric in RCX

; Multiple 64-bit accumulator by 10

            mul     ten
            test    rdx, rdx        ;Test for overflow
            jnz     overflow

            add     rax, rcx
            jc      overflow
                        
;Move on to next character

            inc     rdi      
            mov     cl, [rdi]
            cmp     cl, '0'
            jb      endOfNum
            cmp     cl, '9'
            jbe     convert

; If we get to this point, we've successfully converted
; the string to numeric form:

endOfNum:
            
; Because the conversion was successful, this procedure
; leaves RDI pointing at the first character beyond the
; converted digits. As such, we don't restore RDI from
; the stack. Just bump the stack pointer up by 8 bytes
; to throw away RDI's saved value; must also remove

            add     rsp, 8   ;Remove original RDI value
            pop     rdx
            pop     rcx      ;Restore RCX
            clc              ;Return success in carry flag
            ret
            
; badNumber- Drop down here if the first character in
;            the string was not a valid digit.

badNumber:  xor     rax, rax
            jmp     errorExit     

overflow:   mov     rax, -1  ;0FFFFFFFFFFFFFFFFh
errorExit:  pop     rdi
            pop     rdx
            pop     rcx
            stc              ;Return error in carry flag
            ret
                    
ten         qword   10

strtou      endp

            
                    
            
; Here is the "asmMain" function.

        
            public  asmMain
asmMain     proc
            push    rbp
            mov     rbp, rsp
            sub     rsp, 64         ;Shadow storage
            

; Test hexadecimal conversion:
            
            lea     rdi, qStr
            call    strtou
            jc      error
            
            lea     rcx, fmtStr1
            mov     r8, rax
            lea     rdx, qStr
            call    printf
            jmp     allDone
            
error:      lea     rcx, fmtStr2
            mov     rdx, rax
            call    printf            
 

             
allDone:    leave
            ret     ;Returns to caller
asmMain     endp
            end