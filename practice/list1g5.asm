
        option  casemap:none
        .data

fmtStr  byte    'Hello, world!', 10, 0

    .code

    externdef   printf:proc

        public asmFunc
asmFunc proc

    sub     rsp, 56

    lea     rcx, fmtStr
    call    printf

    add     rsp, 56

    ret

asmFunc endp
        end