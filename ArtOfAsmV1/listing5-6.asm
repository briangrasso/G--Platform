; Listing 5-6
;
; Accessing local variables


               option  casemap:none
               .code

; localVars - Demonstrates local variable access
;
; sdword a is at offset -4 from RBP
; sdword b is at offset -8 from RBP
;
; On entry, ECX and EDX contain values to store
; into the local variables a & b (respectively)

localVars     proc
              push rbp
              mov  rbp, rsp
              sub  rsp, 16  ;Make room for a & b
              
              mov  [rbp-4], ecx  ;a = ecx
              mov  [ebp-8], edx  ;b = edx
              
    ; Additional code here that uses a & b
              
              mov   rsp, rbp
              pop   rbp
              ret
localVars     endp
              end