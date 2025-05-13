#saving the id as a number
	.data
ID:	.quad	238888888
    .section	.rodata			#read only data section
printNumberFormat:	.string	"%ld\n"	#print of ID
True:	.string	"True\n"
False:	.string	"False\n"
########
    .text	#the beginnig of the code
.globl	main	#the label "main" is used to state the initial point of this program
.type	main, @function	# the label "main" representing the beginning of a function
main:
    movq    %rsp, %rbp #for correct debugging
    pushq   %rbp		#save the old frame pointer
    movq	   %rsp, %rbp	#create the new frame pointer
    pushq   %rbx		#saving a callee save register.
    
    ######## question number 1, print the ID
    movq    ID, %rsi      #passing the id to printf
    movq    $printNumberFormat, %rdi	#passing the format printing of the id
    movq	    $0,%rax
    pushq   $0x41		#pushing a random value to the stack (causing the stack to be 16 byte aligned)
    call	    printf		#calling to printf AFTER its arguments are passed (not that many arguments, therefore using registers only)
    
    ####### question 2 - print ID%3 if the 2th byte of ID is even, ID*3 if even
    movq    ID, %rdi    #take the ID to register
    sarq    $8,%rdi    #shift left 8 times, drop the first byte, now the second byte is the first
    testq   $1,%rdi    #do a & between the second byte and 1. if the scond byte is even the result would be 0, 1 if even
    je      .even       #jump if ZF = 1. if the result is 0, the LSB is 0 so the number is even
    #else the number is odd, compute ID*3
    movq    ID, %rsi    #take the ID to rsi
    imulq   $3, %rsi   #multiply by 3
    jmp     .printQ2
.even:
    #else, ZF = 0 and the number is odd, so we need to compute the modulo of ID%3
    mov ID, %rax          # take the ID
    mov $0, %rdx          # initialize rdx to 0, to keep the reminder
    mov $3, %rbx           # keep the divisor(3) in rbx
    idiv %rbx              #divide ID by 3
    movq %rdx,%rsi         #keep the reminder in rsi
    #print the result from the condition
.printQ2:
    #the result already in rsi, call rsi to print the number
    movq    $printNumberFormat, %rdi	#passing the format printing of the id
    movq	    $0,%rax              #initialize rax to 0
    call	    printf		#calling to printf AFTER its arguments are passed
    
    ####### question 3 - do xor between the 3th byte and the 1th byte of ID. print True if the result is bigger than 127, false otherwise
    movq    ID, %rdx     #take ID to rdx
    movq    ID, %rax    #take ID to rax
    sarq    $16,%rax    #shift ID to the left 16 times, drop the first and the second byte to set the third byte as the first byte
    xor    %al, %dl     #xor betwwen the third byte and the first, l suffix takes only the first byte
    cmp     $127, %dl   # compute dl - 127
    js  .lower          #jump if SF = 1. if the result is negetive, that means that dl < 127 and we need to print "False".
    # else, SF = 0.if the result is positive, we need to print "True"
    movq $True, %rdi    # move "True" as first argument
    jmp .printQ3
.lower:                 # we need to print "False"
    movq $False, %rdi    # move "False" as first argument
.printQ3:
    movq	    $0,%rax      #initialize rax to 0
    call	    printf		#calling to printf AFTER its arguments are passed
    
    ####### question 4 - return the number of ones in the 4th byte
    movq    ID, %rax     #take ID to rdx
    sarq    $24,%rax    #shift ID to the left 24 times, drop the first, the second and the third bytes to set the forth byte as the first byte
    movq    $0, %rsi    #prepare rsi to keep the number of ones
.sumOnesLoop:
    testq   $1,%rax    #do a & with the 4th byte.
    je  .nextDigit     # if the result is 0, the LSB is 0, so we can move on to the next digit
    add     $1, %rsi    # if the result is 1, the LSB is 1 and we can add it to the sum of ones
.nextDigit:
    cmp     $1,%rax     # check if rax > 1
    #jump if SF = 1. if the result is negetive, that means that rax < 1 and there are no more ones
    js  .printQ4
    sarq    $1,%rax    #shift ID to the left to check the next digit
    jmp    .sumOnesLoop #return to the loop
.printQ4:   #print the number of ones. the result is already in rsi
    movq    $printNumberFormat, %rdi	#passing the format printing of the id
    movq	    $0,%rax              #initialize rax to 0
    call	    printf		#calling to printf AFTER its arguments are passed
    
    movq    $0, %rax	#return value is zero.
    movq	   -8(%rbp), %rbx	#restoring the save register (%rbx) value, for the caller function.
    movq	   %rbp, %rsp	#restore the old stack pointer - release all used memory.
    popq	   %rbp		#restore old frame pointer (the caller function frame)
    ret			#return to caller function (OS)
    
