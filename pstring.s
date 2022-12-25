//208060855 Evyatar Altman
#file with impelements of the functions
.data
.section .rodata
invalid_input:      .string     "invalid input!\n"
#ascii numeric difference between the lower cases chars and the uper cases
ascii_difference:   .byte       32
#The ascii value of each char of A,Z,a,z the boarders of the alpha beit
A:  .byte   65
Z:  .byte   90
a:  .byte   97
z:  .byte   122
.text
.globl pstrlen      #declare pstrlen as global function
.type pstrlen, @function
#return the length of pstring. the pstring is the adress at rdi
pstrlen:
    movq    (%rdi), %rax    #take the length, which in the first adress of a Pstring struct and store at rax
    ret

.globl replaceChar      #declare replaceChar as global function
.type replaceChar, @function
#raplace all apearence of an old char with a given new char in a pstring. pstring in rdi, oldChar in rsi and newChar
# in rdx
replaceChar:
    movq    %rdi,%rax   #keep the pointer in rax for return in the end of the function
    cmpq    $0,(%rdi)   #check if the pstring is empty (len of 0)
    je      endReplaceChar  #if empty, don't change and end the function
    movq    $0,%rcx     #initialize counter
    replaceCharLoop:
        incq    %rdi    #go forward to the next char of the pstring
        incq    %rcx        #increase the counter
        cmpb    (%rdi),%sil     #compare the current char (in the current adress of rdi) with the old char
        jne     checkIfStopReplacLoop # if not equal, go and check if we had go through all the string
        movb    %dl,(%rdi)      #if equal, replace the currant char with the new char
        #check if the loop had finished to go through the whole string
    checkIfStopReplacLoop:
        cmpb    %cl,(%rax)     #check if the counter had reached the len of the string
        jne     replaceCharLoop     #if not, go back to the loop
    endReplaceChar:
        ret



.globl pstrijcpy     #declare replaceChar as global function
.type pstrijcpy, @function
#copy str[i:j] from src pstring(rsi) to dst pstring(rdi), i in rdx, j in rcx
#if i and j are higher than the lengths of the pstrings, the function prints "invalid input!" and not changes the dst
pstrijcpy:
    movq    %rdi,%rax   #store the dst pstring as return value
    cmpb    (%rsi),%cl     #check if j is higher or equal to the len of the src pstring
    jae      invalidInputPstrijcpy    #go and print "invalid input"
    cmpb    (%rdi),%cl     #check if j is higher or equal to the len of the dst pstring
    jae      invalidInputPstrijcpy    #go and print "invalid input"
    cmpb    (%rsi),%dl     #check if i is higher or equal to the len of the src pstring
    ja      invalidInputPstrijcpy    #go and print "invalid input"
    cmpb    (%rdi),%dl     #check if i is higher or equal to the len of the dst pstring
    ja      invalidInputPstrijcpy    #go and print "invalid input"
    leaq    (%rdx,%rdi),%rdi    #go to index i-1 in the dst pstring
    leaq    (%rdx,%rsi),%rsi    #go to index i-1 in the src pstring
    replaceIJLoop:
    # go forward to the next char
        incq    %rdi
        incq    %rsi
        movq    (%rsi),%r8      #copy the dst[i]
        movb    %r8b,(%rdi)   #replace the current dst[i] whith src[i]
        incq    %rdx        #increase i
        cmpb    %cl,%dl       #check that i <= j
        jbe     replaceIJLoop   #go back if i <= j
    endPstrijcpy:
        ret
    invalidInputPstrijcpy:
        pushq   %rax   #save the pointer to dst
        movq    $0,%rax
        movq    $invalid_input,%rdi     #move the string as arg to printf
        call    printf
        popq    %rax   #store the dst pstring as return value
        jmp     endPstrijcpy

.globl swapCase     #declare swapCase as global function
.type swapCase, @function
#swap every lowerCase char whith upper case and opposite. pstring is in rdi.
swapCase:
    movq    %rdi,%rax   #keep the pointer in rax for return in the end of the function
    cmpq    $0,(%rdi)   #check if the pstring is empty (len of 0)
    je      endSwapCase  #if empty, don't change and end the function
    movq    $0,%rcx     #initialize counter
    swapLoop:
        incq    %rdi    #go to the next char
        incq    %rcx    #increase the counter
        movb    A,%sil  #get the ascii value of A
        cmpb    %sil,(%rdi)   #check if the char is lower than A in the ascii
        jb      checkIfStopSwapLoop     #if below, go to check point
        movb    Z,%sil  #get the ascii value of Z
        cmpb    %sil,(%rdi)   #check if the char is lower than Z in the ascii
        jbe     swapToLowerCase     #swap to lower case if it's equal or below
        movb    a,%sil  #get the ascii value of a
        cmpb    %sil,(%rdi)   #check if the char is lower than a in the ascii
        jb      checkIfStopSwapLoop     #if below, go to check point
        movb    z,%sil  #get the ascii value of z
        cmpb    %sil,(%rdi)   #check if the char is lower than z in the ascii
        jbe     swapToUpperCase     #swap to upper case if it's equal or below
    checkIfStopSwapLoop:
        cmpb    %cl,(%rax)     #check if the counter had reached the len of the string
        jne     swapLoop     #if not, go back to the loop
    endSwapCase:
        ret
    swapToLowerCase:
        movb    ascii_difference,%sil  #get the value of ascii_difference
        addb    %sil,(%rdi)  #add the numeric difference in the ascii table between the upper case and the lower case
        jmp     checkIfStopSwapLoop
    swapToUpperCase:
        movb    ascii_difference,%sil  #get the value of ascii_difference
        subb    %sil,(%rdi)  #decrease the numeric difference in the ascii table between the upper case and the lower case
        jmp     checkIfStopSwapLoop

.globl pstrijcmp    #declare pstrijcmp as global function
.type pstrijcmp, @function
#compare lexographically pstr1 (in rdi) with pstr2 (in rsi) by indexes i (rdx) and j (rcx). If pstr1 is greater,
#return -1, if pstr2 is greater return 1, if pstr1[i:j] equal pstr2[i:j] return 0 and if i or j are beyond the
#length of the two pstr, print "invalid input!" and return -2
pstrijcmp:
    cmpb    (%rsi),%cl     #check if j is higher or equal to the len of pstr2
    jae      invalidInputPstrijcmp    #go and print "invalid input"
    cmpb    (%rdi),%cl     #check if j is higher or equal to the len of pstr1
    jae      invalidInputPstrijcmp    #go and print "invalid input"
    cmpb    (%rsi),%dl     #check if i is higher or equal to the len of pstr2
    ja      invalidInputPstrijcmp    #go and print "invalid input"
    cmpb    (%rdi),%dl     #check if i is higher or equal to the len of pstr1
    ja      invalidInputPstrijcmp    #go and print "invalid input"
    leaq    (%rdx,%rdi),%rdi    #go to index i-1 in pstr1
    leaq    (%rdx,%rsi),%rsi    #go to index i-1 in pstr2
    movq    $0,%rax     #initialize the returning value to 0
    compareIJLoop:
        incq    %rdx        #increase i
        # go forward to the next char(in the first iteration it would be to i)
        incq    %rdi
        incq    %rsi
        movzbq    (%rdi),%r8      #copy the pstr1[i]
        movzbq    (%rsi),%r9      #copy the pstr2[i]
        cmpq    %r8,%r9   #compare pstr2[i] with pstr1[i]
        jb     greater   #return 1 if pstr1[i] > pstr2[i]
        ja     lower   #return -1 if pstr1[i] < pstr2[i]
        cmpb    %cl,%dl       #check if i <= j
        jbe     compareIJLoop   #loop again if i <= j
    endPstrijcmp:
        ret
    greater:
        movq    $1,%rax     #store 1 as the returning value
        jmp     endPstrijcmp
    lower:
        movq    $-1,%rax     #store -1 as the returning value
        jmp     endPstrijcmp
    invalidInputPstrijcmp:
        pushq   %rax   #alighn the stack
        movq    $0,%rax
        movq    $invalid_input,%rdi     #move the string as arg to printf
        call    printf
        popq    %rax   #restore rax
        movq    $-2,%rax    #store -2 (error value) as returning value
        jmp     endPstrijcmp
