.globl read_matrix


.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
# Returns:
#   a0 is the pointer to the matrix in memory
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# ==============================================================================
read_matrix:
    # prologue
    addi sp, sp, -40
    sw s0, 0(sp)    # save filename (arg)
    sw s1, 4(sp)    # save number of rows_ptr
    sw s2, 8(sp)    # save number of columns_ptr
    sw s3, 12(sp)   # save file descriptor 
    sw s4, 16(sp)   # save matrix_ptr
    sw s5, 20(sp)   # save # entries
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)

    add s0, a0, x0           # s0 <- a0 (arg)


    # fopen
    add a1, s0, x0              # a1 <- s0 / a0 (arg)
    add a2, x0, x0              # a2 <- 0 / 'r'
    jal fopen
    addi t0, x0, -1             # t0 <- -1
    beq t0, a0, eof_or_error    # check file path

    add s3, a0, x0              # s3 <- a0 (file descriptor) 
	
	    
	#lw t0, 0(s3)	
	#mv a1, t0
	#jal print_int
    	## Print newline afterwards for clarity
    	#li a1 '\n'
    	#jal print_char

    # malloc row pointer
    addi a0, x0, 4              # a0 <- 4         
    jal malloc
    beq a0, x0, eof_or_error    # check pointer == null
    add s1, a0, x0              # s1 <- a0 (row_ptr)

    # Malloc col pointer
    addi a0, x0, 4              # a0 <- 4 
    jal malloc
    beq a0, x0, eof_or_error    # check pointer == null
    add s2, a0, x0              # s2 <- a0 (col_ptr)


    # Read number of rows
    addi a1, s3, 0              # a1 <- s3 (file des.)
    add a2, s1, x0              # a2 <- s1 (row_ptr)
    addi a3, x0, 4              # a3 <- 4
    jal fread
    bne a0, a3, eof_or_error    # check byte read

    lw t1, 0(s1)                # t1 <- s1 (load rows)
    blt t1, x0, eof_or_error    # check rows

	#mv a1, t1
	#jal print_int
    	## Print newline afterwards for clarity
    	#li a1 '\n'
    	#jal print_char

    # !!! Read number of cols
    add a1, s3, x0              # a1 <- s3 + 4? (file des.)
    add a2, s2, x0              # a2 <- s2 (col_ptr)
    addi a3, x0, 4              # a3 <- 4
    jal fread
    bne a0, a3, eof_or_error    # check byte read

    lw t0, 0(s2)                # t0 <- s2 (load cols)
    blt t0, x0, eof_or_error    # check cols

	#mv a1, t0
	#jal print_int
    	## Print newline afterwards for clarity
    	#li a1 '\n'
    	#jal print_char



    # Calculate bytes
    mul t0, t0, t1              # t0 <- t0 * t1 (col * rows)
    add s5, t0, x0              # s5 <- t0 (# of entries)

    # Allocate space for matrix and read it.
    addi t0, x0, 4              # t0 <- 4 (byte)
    mul a0, s5, t0              # a0 <- s5 * 4 (# of entries * byte)
    jal malloc
    beq a0, x0, eof_or_error    # check pointer == null

    add s4, a0, x0              # s4 <- a0 (matrix_ptr)

    add a1, s3, x0              # a1 <- s3 (file descriptor) 
    add a2, s4, x0              # a2 <- s4 (matrix_ptr)
    addi t0, x0, 4              # t0 <- 4 (byte)
    mul a3, s5, t0              # a3 <- s5 * 4 (# of entries * byte)
    call fread
    bne a0, a3, eof_or_error    # check byte read


    #fclose
    add a1, s3, x0              # a1 <- s3 (file descriptor)
    jal fclose
    bne a0, x0, eof_or_error    # check file's colsed

    # Return value (can use mv throught similar code)
    add a0, s4, x0
    add a1, s1, x0
    add a2, s2, x0
 

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40

    
    ret

eof_or_error:
    li a1 1
    jal exit2