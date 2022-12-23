.import ../gemv.s
.import ../utils.s
.import ../dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9 # 3x3 matrix [1,2,3;4,5,6;7,8,9]
m1: .word 1 2 3 # 3x1 vector [1,2,3]
d: .word 0 0 0 # allocate static space for output

.text
main:
    # Load addresses of matrix, vector (which are in static memory), and set their dimensions
    la s0, m0               # pointer to the start of m
    addi s1, x0, 3          # rows (height) of m
    addi s2, x0, 3          # cols (height) of m
    la s3, m1               # pointer to the start of v
    addi s4, x0, 3          # rows (height) of v
    la s5, d                # pointer to the the start of d


    mv a0, s0           # 	a0 is the pointer to the start of m
    mv a1, s1           #	a1 is the # of rows (height) of m
    mv a2, s2           #	a2 is the # of columns (width) of m
    mv a3, s3           #	a3 is the pointer to the start of v
    mv a4, s4           # 	a4 is the # of rows (height) of v
    mv a5, s6           #	a5 is the pointer to the the start of d

    # Call gemv m * v
    jal ra, gemv

    # Print the output (use print_int_array in utils.s)
    # Note that produce of matrix*vector is a vector i.e., cols always = 1
    addi s7, x0, 1
    mv a2, s7
    mv a1, s1
    mv a0, a5
    
    jal print_int_array



    # Exit the program
    jal exit
