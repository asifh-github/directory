.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:
    # Prologue
    mv t0, a0           # t0 <- v0
    add a0, x0, x0      # a0 <- 0 (return dot_product)
    add t1, x0, x0      # t1 <- 0 (count)
    addi t2, x0, 4      # t2<- 4 (size of a byte)
    
loop_start:
    beq t1, a2, loop_end    # t1 < a2
    mul t3, t1, t2          # t3 <- t1 * t2 (count * size of a byte)
    add t4, t0, t3          # t4 <- t0 + t3 (v0 + count * size of a byte)
    add t5, a1, t3          # t5 <- a1 + t3 (v1 + count * size of a byte)
    lw  t4, 0(t4)           # t4 <- v0[count]
    lw  t5, 0(t5)           # t5 <- v1[count]
    mul t4, t4, t5          # t4 <- t4 * t5 (v0[count] * v1[count]) 
    add a0, a0, t4          # a0 <- a0 + t34 (~sum(v0[count] * v1[count]))
    addi t1, t1, 1          # t1 <- t1 + 1 (count++)
    j loop_start
    
loop_end:

    # Epilogue
    ret
