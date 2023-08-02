.macro exit #macro to exit program
	li a7, 10
	ecall
	.end_macro	

.macro print_str(%string1) #macro to print any string
	li a7,4 
	la a0, %string1
	ecall
	.end_macro
	
	
.macro read_n(%x)#macro to input integer n into register x
	li a7, 5
	ecall 		
	#a0 now contains user input
	addi %x, a0, 0
	.end_macro
	

.macro 	file_open_for_write_append(%str)
	la a0, %str
	li a1, 1
	li a7, 1024
	ecall
.end_macro
	
.macro  initialise_buffer_counter
	#buffer begins at location 0x10040000
	#location 0x10040000 to keep track of which address we store each character byte to 
	#actual buffer to store the characters begins at 0x10040008
	
	#initialize mem[0x10040000] to 0x10040008
	addi sp, sp, -16
	sd t0, 0(sp)
	sd t1, 8(sp)
	
	li t0, 0x10040000
	li t1, 0x10040008
	sd t1, 0(t0)
	
	ld t0, 0(sp)
	ld t1, 8(sp)
	addi sp, sp, 16
	.end_macro
	

.macro write_to_buffer(%char)
	#NOTE:this macro can add ONLY 1 character byte at a time to the file buffer!	
	
	addi sp, sp, -16
	sd t0, 0(sp)
	sd t4, 8(sp)
	
	
	li t0, 0x10040000
	ld t4, 0(t0)#t4 is starting address
	#t4 now points to location where we store the current %char byte
	
	#store character to file buffer
	li t0, %char
	sb t0, 0(t4)
	
	#update address location for next character to be stored in file buffer
	li t0, 0x10040000
	addi t4, t4, 1
	sd t4, 0(t0)
	
	ld t0, 0(sp)
	ld t4, 8(sp)
	addi sp, sp, 16
	.end_macro

.macro fileRead(%file_descriptor_register, %file_buffer_address)
#macro reads upto first 10,000 characters from file
	addi a0, %file_descriptor_register, 0
	li a1, %file_buffer_address
	li a2, 10000
	li a7, 63
	ecall
.end_macro 

.macro fileWrite(%file_descriptor_register, %file_buffer_address,%file_buffer_address_pointer)
#macro writes contents of file buffer to file
	addi a0, %file_descriptor_register, 0
	li a1, %file_buffer_address
	li a7, 64
	
	#a2 needs to contains number of bytes sent to file
	li a2, %file_buffer_address_pointer
	ld a2, 0(a2)
	sub a2, a2, a1
	
	ecall
.end_macro 

.macro print_file_contents(%ptr_register)
	li a7, 4
	addi a0, %ptr_register, 0
	ecall
	#entire file content is essentially stored as a string
.end_macro
	


.macro close_file(%file_descriptor_register)
	li a7, 57
	addi a0, %file_descriptor_register, 0
	ecall
.end_macro

.data
	prompt: .asciz  "Enter the height of the pattern (must be greater than 0):"
	invalidMsg: .asciz "Invalid Entry!"
	newLine: .asciz  "\n"
	star_dollar: .asciz  "*$"
	dollar: .asciz  "$"
	star: .asciz "*"
	blankspace: .asciz " "
	outputMsg: .asciz  " display pattern saved to lab3_output.txt "
	filename: .asciz "lab3_output.txt"
	Zero:.asciz"0"


.text

	file_open_for_write_append(filename)
	#a0 now contaimns the file descriptor (i.e. ID no.)
	#save to t6 register
	addi t6, a0, 0
	
	initialise_buffer_counter
	
	#for utilsing macro write_to_buffer, here are tips:
	#0x2a is the ASCI code input for star(*)
	#0x24 is the ASCI code input for dollar($)
	#0x30  is the ASCI code input for  the character '0'
	#0x0a  is the ASCI code input for  newLine (/n)

	
	#START WRITING YOUR CODE FROM THIS LINE ONWARDS
	#DO NOT use the registers a0, a1, a7, t6, sp anywhere in your code.
	
	#................ your code here..........................................................#
	

main:
  input:
    print_str(prompt)
    read_n(t0)

    # t0 now contains the value n
    li s4, 1 # load immediate
    li s9, 3 # load immediate
    li s8, 4 # load immediate
    blt t0, s4, invalid # branch if less than t0 s4
    j setting # jump to setting

  invalid:
    print_str(invalidMsg)
    print_str(newLine)
    j input

  inputcheck:
    # blt t0, x1, input
    # bge t1, t0, loop exit
    li t1, 0
    li t2, 0
    j checkLoop

  checkLoop:
    blt t1, t0, loop_body # branch if less than

    # exit loop

    # write null character to end of file
    write_to_buffer(0x00)
    # print prompt1 string on console
    # print_str(prompt1)

  setting:
    li a4, 0
    li s2, 0
    li s3, 0
    li a3, 0
    addi s2, t0, 1
    addi a2, t0, 1
    addi a3, a3, 1

    addi t5, t0, 2
    # addi t5, t0, 1

    # 0x20 - whitespace
    # 0x2a - *
    # 0x24 - $
    # 0x30 - 0

  loop_body:
    bge a4, t0, loop_exit # branch if greater than or equal
    addi s3, s3, 1 # increase s3 by 1 to continue counter

    write_to_buffer(0x24) #each line starts witha $, so well have one on the outer loop to continously print this to start each line

    loop_inner: #goal of the inner loop is to print the content of our triangle, in this case it would be the asterisk and the dollar signs repeatedly
      beq s2, a2, loop_A
      beq s2, t5, loop_B
      beq s3, t0, loop_C
      bge s2, s3, loop_B
      write_to_buffer(0x2a) # writes the asterisk
      write_to_buffer(0x24) # writes the dollar signs

    loopB_update:
      addi s2, s2, 1
      b loop_inner

    loop_C: #for the bottom row
      bge a3, t0, loop_exit # tells the code to stop the loop once the inner loop of loop c is finished
      write_to_buffer(0x2a) # writes the bottom row
      write_to_buffer(0x24) # writes the dollar signs
      addi a3, a3, 1
      b loop_C

    loop_B:
      add s2, zero, zero # set s2 to zero
      beqz t0, loop_exit # branch to loop_exit if t0 is zero
      write_to_buffer(0x2a) # writes the asterisk
      write_to_buffer(0x24) # writes the dollar signs
      b loop_A

    loop_A: #each line ends with a 0, so to complete each line we simply print the 0 and the newline at the same time
      addi s2, s2, 1
      write_to_buffer(0x30) # writes the zeros
      write_to_buffer(0x0a) # newLine

    loop_update:
      addi a4, a4, 1 # increase a4 by 1
      b loop_body # branch to the beginning of the loop
    loop_exit:
      blt t0, s9, end_dont_add_zero # branch if less than t0 s4
      beq t0, s9, end_add_zero
      bgt t0, s9, end_add_dolla_ster_zero # branch if greater than 3 than t0 s4
      
    end_add_dolla_ster_zero:
      write_to_buffer(0x2a) # writes the asterisk
      write_to_buffer(0x24) # writes the dollar signs
      #write_to_buffer(0x30)
    end_add_zero: #for case 3 which specifically is missing a 0
      write_to_buffer(0x30) # writes '0' at the end of the output
    end_dont_add_zero: #for cases when the 0 is already taken care of the by the main loop
      
    #li s4, 1 # load immediate
    #li s9, 3 # load immediate
    #li s8, 4 # load immediate
  
	#................ your code ends here..........................................................#
	
	#END YOUR CODE ABOVE THIS COMMENT
	#Don't change anything below this comment!
Exit:	
	#write null character to end of file
	write_to_buffer(0x00)
	
	#write file buffer to file
	fileWrite(t6, 0x10040008,0x10040000)
	addi t5, a0, 0
	
	print_str(newLine)
	print_str(outputMsg)
	
	exit
