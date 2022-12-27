//208060855 Evyatar Altman
.data
.section .rodata
indexInput:             .string "%d"
stringInput:             .string "%s"
.text
.globl run_main
.type run_main, @function
run_main:
    pushq	%rbp		#save the old frame pointer
	movq	%rsp,	%rbp	#create the new frame pointer
	#prepare r12-13 for usage
	pushq   %r12    #keep r12 on stack
    pushq   %r13    #keep r13 on stack
    pushq   %r14    #keep r13 on stack
    pushq   $0      #for the alighnment

    #get the first pstring, first his len and later his string
    #prepare the stack
    #prepare the stack to get the len of pstr1
    subq    $16,%rsp    #increase the frame by 16 bytes
    leaq    -8(%rbp),%rsi  #make room for len of pstr1
    movq    $indexInput,%rdi     #send the format of the input of integer
    movq    $0,%rax
    call    scanf

    #get the string of pstr1
    xorq    %r13,%r13   #inilize r13
    movq    -8(%rbp),%r13   #keep the len of the first pstring
    movq    $0,(%rsp)   #zero the memory
    xorq    %rcx,%rcx   #counter
    memoryLoopP1:     #loop to allocate memory in 16 multiplies
    subq    $16,%rsp    #increase the frame by 16 bytes
    addq    $16,%rcx
    movq    $0,(%rsp)   #zero the memory
    cmpb    %r13b,%cl   #check if we allocated enough memroy
    jb      memoryLoopP1

    leaq    1(%rsp),%rsi  #make room for the string (after the len)
    movq    $stringInput,%rdi     #send the format of the input of integer
    call    scanf
    movb    %r13b,(%rsp)       #save the len at the start
    movq    %rsp,%r12   #keep the pointer to pstr1

    #prepare the stack to get the len of pstr2
    pushq	%rbp		#save the old frame pointer
    movq	%rsp,	%rbp	#create the new frame pointer
    pushq   $0      #align the stack
    subq    $16,%rsp    #increase the frame by 16 bytes
    leaq    -8(%rbp),%rsi  #make room for len of pstr1
    movq    $indexInput,%rdi     #send the format of the input of integer
    movq    $0,%rax
    call    scanf

#get the string of pstr2
    xorq    %r14,%r14   #inilize r13
    movq    -8(%rbp),%r14   #keep the len of the second pstring
    movq    $0,(%rsp)   #zero the memory
    xorq    %rdx,%rdx   #counter
    memoryLoopP2:     #loop to allocate memory in 16 multiplies
    subq    $16,%rsp    #increase the frame by 16 bytes
    addq    $16,%rdx
    movq    $0,(%rsp)   #zero the memory
    cmpb    %r14b,%dl   #check if we allocated enough memroy
    jb      memoryLoopP2

    leaq    1(%rsp),%rsi  #make room for the string (after the len)
    movq    $stringInput,%rdi     #send the format of the input of integer
    call    scanf
    movb    %r14b,(%rsp)       #save the len at the start
    movq    %rsp,%r13   #keep the pointer to pstr2

    #prepare the stack to get the option
    pushq	%rbp		#save the old frame pointer
    movq	%rsp,	%rbp	#create the new frame pointer
    pushq   $0
    subq    $16,%rsp    #increase the frame by 16 bytes
    leaq    -8(%rbp),%rsi  #make room for the option (after pstr2)
    movq    $indexInput,%rdi     #send the format of the input of integer
    movq    $0,%rax
    call    scanf

    #call run_func
    movq    -8(%rbp),%rdi  #get the choise of the user
    movq    %r12,%rsi   #get pstr1
    movq    %r13,%rdx   #get pstr2
    call     run_func

    #restore third frame
    leave
    #restore second frame
    leave

    popq    %r14
    popq    %r13
    popq    %r12
    leave
    ret
