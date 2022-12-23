.import ../read_matrix.s
.import ../gemv.s
.import ../dot.s
.import ../utils.s

.data
output_step1: .asciiz "\n**Step result = gemv(matrix, vector)**\n"



.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <VECTOR_PATH> <MATRIX_PATH> 

    # Exit if incorrect number of command line args
    addi t0, x0, 3                  # t0 <- 3 (# of args)
    bne a0, t0, argc_mismatch       # check a0 == t0

    mv s0, a1                       # s0 <- a1 (saved args)

# =====================================
# LOAD MATRIX and VECTOR. Iterate over argv.
# =====================================
# Load Matrix        
    lw a0, 8(s0)                    # a0 <- argv[2]
    jal read_matrix
    mv s1, a0                       # s1 <- a0 (matrix)
    mv s2, a1                       # s2 <-  a1 (rows of matrix)
    mv s3, a2                       # s3 <-  a2 (cols of martix)

    lw s2, 0(s2)
    lw s3, 0(s3)
    mv a1, s2
    mv a2, s3
    jal print_int_array

# Load Vector
    lw a0, 8(s0)                    # a0 <- argv[2]
    jal read_matrix
    mv s4, a0                       # s4 <- a0 (vector)
    mv s5, a1                       # s5 <-  a1 (rows of vector)
    mv s5, a2                       # s6 <-  a2 (col of vector == 1)

    lw s5, 0(s5)
    lw s6, 0(s6)
    mv a1, s5
    mv a2, s6
    jal print_int_array

# =====================================
# RUN GEMV
    # allocate memory for d_matrix
    mv t0, s2
    mul t0, t0, s6
    li t1, 4
    mul a0, t0, t1
    jal malloc
    beq a0, x0, eof_or_error        # check pointer == null
    mv s7, a0                       # s7 <- a0 (row_ptr)

    mv a0, s1                       # a0 <- s1 (matrix_ptr)
    mv a1, s2                       # a1 <- s2 (rows of matrix)
    mv a2, s3                       # a2 <- s3 (cols of matrix)
    mv a3, s4                       # a3 <- s4 (vector_ptr)
    mv a4, s5                       # a4 <- s5 (rows of vector)
    mv a5, s7                       # a5 <- s7 (d_matrix)
    jal gemv
    mv s7, a5                       # s7 <- a5 (d_matrix_filled)

    mv a0, s7
    mv a1, s2
    mv a2, s6
    jal print_int_array

    mv a0, s7
    jal free

# =====================================
# SPMV :    m * v

    la a1, output_step1
    jal print_str

    ## FILL OUT. Output is a dense vector.
#    mv a0,# Base ptr
#    mv a1,#rows
#    mv a2,#cols
#    jal print_int_array 










    
 




















    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit


argc_mismatch: 
    li, a1, 3
    jal exit2
