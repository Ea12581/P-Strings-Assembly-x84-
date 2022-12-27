//208060855 Evyatar Altman
.data
.section .rodata
invalidOptinon:          .string     "invalid option!\n"
lengthPrint:            .string "first pstring length: %d, second pstring length: %d\n"
replaceCharsInput:      .string " %c %c"
replaceCharPrint:       .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
indexInput:             .string " %d"
printCopySubString:     .string "length: %d, string: %s\n"
swapPrint:              .string "length: %d, string: %s\n"
printCompareResult:     .string     "compare result: %d\n"
.align 8 # Align address to multiple of 8
# the jump table of cases 31-37
switchCase:
.quad printLengths # Case 31
.quad replaceChars # Case 32, replace an exists char with new input char
.quad replaceChars # Case 33 replace an exists char with new input char
.quad default # Case 34, there is no valid case 34. go to default
.quad copySubString # Case 35, copy pstr2[i:j] to pstr1[i:j]
.quad swapUpperLower # Case 36, swap between lower to upper and opposite
.quad compareSubString # Case 37, compare pstr2[i:j] to pstr1[i:j]

.text
.globl run_func     #declare run_func as global function
.type run_func, @function
# do operations acording to the option that was chosen, using jump table that represent a "switch case". Cases are
#31,32\33,35,36 and 37 and they are being operated on two Pstrings, one in rsi and the second in rdx.
#The option that was chosen are in rdi
run_func:
    pushq	%rbp		#save the old frame pointer
	movq	%rsp,	%rbp	#create the new frame pointer
# Set up the jump table access
    leaq -31(%rdi),%rdi # Compute rdi = rdi-31, because it would be refernce as unsigned, 31-37 would be 0-6 and all the
    # other numbers would be above them
    cmpq $6,%rdi # Compare rdi:6, if rdi <=6, it's one of the cases, else error
    ja default # if >, goto default-case
    jmp *switchCase(,%rdi,8) # Goto switchCase[rdi]

    printLengths:
        movq    %rsi,%rdi   #get the first pstring as argument to pstrlen
        movq    %rdx,%r8   #save the second pstring
        call    pstrlen
        movq    %rax,%r9     #keep the len of the first pstring in r9
        movq    %r8,%rdi     #get the second pstring as argument to pstrlen
        call    pstrlen
        movq    %rax,%rdx     #get the len of the second as 3th argument to printf
        movq    %r9,%rsi     #get the len of the first as 2th argument to printf
        movq    $lengthPrint,%rdi   #get the format of the print
        movq    $0,%rax #initialize rax to 0
        call    printf
        jmp finish
    replaceChars:
        pushq   %r12    #keep r12 on stack
        pushq   %r13    #keep r13 on stack
        pushq   %r14    #keep r14 on stack
        pushq   %r15    #keep r15 on stack

        movq    %rsi,%r12     #keep the pointer of the first pstring in r12
        movq    %rdx,%r13   #save the second pstring at r13

        #prepare the stack to get two chars
        subq    $16,%rsp    #increase the frame by 24 bytes
        leaq    -8(%rbp),%rsi  #make room for the old char
        leaq    -16(%rbp),%rdx  #make room for the new char
        movq    $replaceCharsInput,%rdi     #move the string as arg to printf
        movq    $0,%rax
        call    scanf

        movq    -8(%rbp), %r14    #keep the old char at r14
        movq    -16(%rbp), %r15    #keep the new char at r15

        #call replace char on the first pstring
        movq    %r12,%rdi   #move the first pstring as argument to replaceChar
        movq    %r14,%rsi   #move old char as 2th arg
        movq    %r15,%rdx   #move new char as 3th arg
        call    replaceChar

        #call replace char on the second pstring
        movq    %r13,%rdi   #move the second pstring as argument to replaceChar
        movq    %r14,%rsi   #move old char as 2th arg
        movq    %r15,%rdx   #move new char as 3th arg
        call    replaceChar

        #print the two chars and the pstrings
        movq    $replaceCharPrint,%rdi  #take the format of the printing
        movq    %r14,%rsi   #move old char as 2th arg
        movq    %r15,%rdx   #move new char as 3th arg
        leaq    1(%r12),%rcx   #move first pstring as 4th arg
        leaq    1(%r13),%r8   #move second pstring as 5th arg
        movq    $0,%rax
        call    printf

         #restore r12-15
        popq    %r15
        popq    %r14
        popq    %r13    #restore r12,r13
        popq    %r12
        jmp     finish
    copySubString:
        pushq   %r12    #keep r12 on stack
        pushq   %r13    #keep r13 on stack

        movq    %rsi,%r12     #keep the pointer of the first pstring in r12
        movq    %rdx,%r13   #save the second pstring at r13

        #prepare the stack to get index i
        subq    $16,%rsp    #increase the frame by 16 bytes
        leaq    -8(%rbp),%rsi  #make room for index i
        movq    $indexInput,%rdi     #move the string as arg to printf
        movq    $0,%rax
        call    scanf

        #getting j
        leaq    -16(%rbp),%rsi  #make room for index j
        movq    $indexInput,%rdi     #move the string as arg to printf
        movq    $0,%rax
        call    scanf

        #call pstrijcpy
        movq    %r12,%rdi   #move the first pstring as 1th arg
        movq    %r13,%rsi   #move the second pstring as 2th arg
        movzbq    -8(%rbp),%rdx   #move i as 3th arg
        movzbq    -16(%rbp),%rcx   #move j as 4th arg
        call    pstrijcpy

        #print the first pstring and his length
        movq    $printCopySubString,%rdi  #take the format of the printing
        movzbq    (%r12),%rsi   #move first pstring len as 2th arg
        leaq    1(%r12),%rdx   #move the string of the first pstring as 3th arg
        movq    $0,%rax
        call    printf

        #print the second pstring and his length
        movq    $printCopySubString,%rdi  #take the format of the printing
        movzbq  (%r13),%rsi   #move first pstring len as 2th arg
        leaq    1(%r13),%rdx   #move the string of the first pstring as 3th arg
        movq    $0,%rax
        call    printf

         #restore r12-13
        popq    %r13    #restore r12,r13
        popq    %r12
        jmp     finish
    swapUpperLower:
    #prapare r12,r13 to hold the pstrings
        pushq   %r12    #keep r12 on stack
        pushq   %r13    #keep r13 on stack
        movq    %rsi,%r12     #keep the pointer of the first pstring in r12
        movq    %rdx,%r13   #save the second pstring at r13

        #call swapCase to first psring
        movq    %r12,%rdi   #get the first pstring as argument to swapCase
        call    swapCase

        #call swapCase to second psring
        movq    %r13,%rdi   #get the second pstring as argument to swapCase
        call    swapCase

        #print the first pstring
        movzbq  (%r12),%rsi     #get the len of the first pstring as 1th argument to printf
        leaq    1(%r12),%rdx     #get the pointer to the string of the first pstring as 2th argument to printf
        movq    $swapPrint,%rdi   #get the format of the print
        movq    $0,%rax #initialize rax to 0
        call    printf

        #print the second
        movzbq  (%r13),%rsi     #get the len of the second pstring as 1th argument to printf
        leaq    1(%r13),%rdx     #get the pointer to the string of the second pstring as 2th argument to printf
        movq    $swapPrint,%rdi   #get the format of the print
        movq    $0,%rax #initialize rax to 0
        call    printf

        #restore r12,r13
        popq    %r13
        popq    %r12
        jmp finish
    compareSubString:
        pushq   %r12    #keep r12 on stack
        pushq   %r13    #keep r13 on stack

        movq    %rsi,%r12     #keep the pointer of the first pstring in r12
        movq    %rdx,%r13   #save the second pstring at r13

        #prepare the stack to get index i
        subq    $16,%rsp    #increase the frame by 16 bytes
        leaq    -8(%rbp),%rsi  #make room for index i
        movq    $indexInput,%rdi     #move the string as arg to printf
        movq    $0,%rax
        call    scanf

        #getting j
        leaq    -16(%rbp),%rsi  #make room for index j
        movq    $indexInput,%rdi     #move the string as arg to printf
        movq    $0,%rax
        call    scanf

        #call pstrijcmp
        movq    %r12,%rdi   #move the first pstring as 1th arg
        movq    %r13,%rsi   #move the second pstring as 2th arg
        movzbq    -8(%rbp),%rdx   #move i as 3th arg
        movzbq    -16(%rbp),%rcx   #move j as 4th arg
        call    pstrijcmp

        #print the first pstring and his length
        movq    $printCompareResult,%rdi  #take the format of the printing
        movq  %rax,%rsi   #move the compare result as 2th arg
        movq    $0,%rax
        call    printf

         #restore r12-13
        popq    %r13    #restore r12,r13
        popq    %r12
        jmp     finish
    default:        #in case of invalid input, print error and finish program
         movq    $0,%rax
         movq    $invalidOptinon,%rdi     #move the string as arg to printf
         call    printf
         jmp finish
finish:
movq    %rbp,%rsp
popq    %rbp
ret
