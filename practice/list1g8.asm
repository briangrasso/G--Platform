
    option casemap:none

nl      =       10
maxLen  =       256

        .data
titleStr    byte        'List1g8', 0
prompt      byte        'Enter a string: ', 0
fmtStr      byte        "User entered: '%s'", nl, 0

input   byte    maxLen dup (?)

    .code

    externdef printf:proc
    externdef readLine:proc

    public getTitle
getTitle proc

    lea rax, titleStr
    ret
getTitle endp

    public asmMain
asmMain proc
    sub     rsp, 56

    lea     rcx, prompt
    call    printf

    mov     input, 0

    lea     rcx, input
    mov     rdx, maxLen
    call    readLine

    lea     rcx, fmtStr
    lea     rdx, input
    call    printf
    
    add     rsp, 56
    ret

asmMain endp
        end