.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_files/test_input.bin"

.text
main:
    # Read matrix into memory
    la s0, file_path
    mv a0, s0
    jal read_matrix

    # Print out elements of matrix
    mv s1, a1
    mv s2, a2
    lw t0, 0(s1)
    lw t1, 0(s2)
    mv a1, t0
    mv a2, t1
    jal print_int_array
    

    # Terminate the program
    addi a0, x0, 10
    ecall