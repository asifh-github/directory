.globl gemv

.text
# =======================================================
# FUNCTION: Matrix Vector Multiplication
# 	d = gemv(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of v
# 	a4 is the # of rows (height) of v
#	a5 is the pointer to the the start of d
# Returns:
#	None, sets d = gemv(m0, m1)
# =======================================================
gemv:

    # Error if mismatched dimensions
    bne a2, a4, mismatched_dimensions

    # Prologue
    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)

    mv s0, a0       # pointer to the start of m0
    mv s1, a1       # rows (height) of m0
    mv s2, a2       # columns (width) of m0
    mv s3, a3       # pointer to the start of v
    mv s4, a4       # rows (height) of v
    mv s5, a5       # pointer to the the start of d

    addi s6, x0, 1          # s6 <- 1 cols (width) 
    add s7, x0, x0          # s7 <- 0 rows (height) of m0 (~count = 0)

outer_loop_start_gemv:
    beq s7, s1, outer_loop_end_gemv         # count < m0_rows
    add s8, x0, x0                          # s8 <- 0 cols (width) of v (v_cols == 0)

    addi t0, x0, 4                          # t0 <- 4 (size of byte)
    mul t0, t0, s2                          # t0 <- m0_cols * 4 
    mul t0, t0, s7                          # t0 <- count * m0_col * 4 
    add t0, t0, s0                          # t0 <- m0_ptr + count * m0_col * 4 
    addi t1, x0, 4                          # t1 <- 4 (size of byte)
    mul t1, t1, s8                          # t1 <- v_col
    add t1, t1, s3                          # t1 <- v_ptr + v_cols (v_cols == 0)

#    mv a0, t0 
#    mv a1, s1
#    mv a2, s6
#    jal print_int_array

    mv a0, t0                               # a0 <- m0_ptr[row]
    mv a1, t1                               # a1 <- v_ptr ([col])
    mv a2, s2                               # a2 <- m0_cols
    jal ra, dot

    addi t0, x0, 4                          # t0 <- 4 (size of byte)
    mul t0, t0, s6                          # t0 <- v_col * 4
    mul t0, t0, s7                          # t0 <- count* v_col * 4
    addi t1, x0, 4                          # t1 <- 4 (size of byte)
    mul t1, t1, s8                          # t1 <- v_cols == 0 * 4
    add t0, t0, t1                          # t0 <- (count* v_col * 4) + (v_cols == 0 * 4)
    add t0, t0, s5                          # t0 <- v + (count* v_col * 4) + (v_cols == 0 * 4)
    sw a0, 0(t0)                            # d[count] <- dot

    addi s7, s7, 1                          # s7 <- s7 + 1 (count++)
    j outer_loop_start_gemv                  

#Epilogue
outer_loop_end_gemv:


    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    le s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40

    ret

mismatched_dimensions:
    li a1 2
    jal exit2