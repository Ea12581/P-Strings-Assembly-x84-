//208060855 Evyatar Altman
#file with impelements of the functions
.data
.section .rodata


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
je      endReplaceChar  #if empty, don't change and end the run
incq    %rdi    #get to the adresss with the string of the pstring
movq    $1,%rcx     #initialize counter
    replaceLoop:
    cmpb    (%rdi),%sil     #compare the current char (in the current adress of rdi) with the old char

    #check if the loop had finished to go through the whole string
    checkIfStopLoop:

    endReplaceChar:
        ret



.globl pstrijcpy
.type pstrijcpy, @function
pstrijcpy:


.globl swapCase
.type swapCase, @function
swapCase:



.globl pstrijcmp
.type pstrijcmp, @function
pstrijcmp:

