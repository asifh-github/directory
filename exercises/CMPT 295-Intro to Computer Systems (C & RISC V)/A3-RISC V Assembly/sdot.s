.globl sdot

.text
# =======================================================
# FUNCTION: Dot product of 1 sparse vectors and 1 dense vector
# Arguments:
#   a0 is the pointer to the start of v0 (sparse, coo format)
#   a1 is the pointer to the start of v1 (dense)
#   a2 is the number of non-zeros in vector v0
# Returns:
#   a0 is the sparse dot product of v0 and v1
# =======================================================
#
# struct coo {
#   int row;
#   int index;
#   int val;
# };   
# Since these are vectors row = 0 always for v0.
#for (int i = 0 i < nnz; i++) {
#    sum = sum + v0[i].value * v1[coo[i].index];
# }
sdot:
    # Prologue 
    addi sp, sp, -36
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)


    # Save arguments
    mv s0, a0               # s0 <- a0 (v0)
    mv s1, a1               # s1 <- a1 (v1)
    mv s2, a2               # s2 <- a2 (# v0_nnzs)

    # Set strides. Note that v0 is struct. v1 is array.
    li s3, 3                # s3 <- 3 (v0_stride_value)
    li s4, 2                # s4 <- 1 (v0_stride_col)
    addi t1, x0, 4          # t1 <- 4 (size of byte/int)
    # Set loop index
    li t0, 0                # t0 <- 0 (count)

    # Set accumulation to 0
    add a0, x0, x0          # a0 <- 0 (return dot_product)


loop_start:

    # Check outer loop condition
    beq t0, s2, loop_end    # t0 < s2 (count < v0_nnzs)
    # load v0[i].value. The actual value is located at offset  from start of coo entry
    add t2, t0, s3          # t2 <- count + v0_stride_val
    mul t2, t2, t1          # t2 <- (count + v0_stride_val) * 4
    add t3, t2, s0          # t3 <- v0 + (count + v0_stride_val) * 4

    lw s5, 0(t3)                # s5 <- v0[i].value

    # What is the index of the coo element?
    add t2, t0, s4          # t2 <- count + v0_stride_col
    mul t2, t2, t1          # t2 <- (v0_stride_col + count) * 4
    add t3, t2, s0          # t3 <- v0 ( v0_stride_col + count) * 4

    lw s6, 0(t3)            # s6 <- v1_stride

    # Lookup corresponding index in dense vector
    mul t2, t1, s6          # t2 <- v1_stride * 4
    add t3, t2, s1          # t3 <- v0 + v1_stride * count * 4
    
    # Load v1[coo[i].index]
    lw s7, 0(t3)                # s6 <- v1[coo[i].index]

    # Multiply and accumulate
    mul t2, s5, s7              # s7 <- v0[i].value
    add a0, a0, t2
    # Bump ptr to coo entry

    # Increment loop index
    addi t0, t0, 1          # t0 <-  t0 + 1 (count++)
    j loop_start

loop_end:

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    addi sp, sp, 36

    ret
