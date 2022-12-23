#include <stdio.h> // for stderr
#include <stdlib.h> // for exit()
#include "types.h"
#include "utils.h"
#include "riscv.h"

void execute_rtype(Instruction, Processor *);
void execute_itype_except_load(Instruction, Processor *);
void execute_branch(Instruction, Processor *);
void execute_jal(Instruction, Processor *);
void execute_load(Instruction, Processor *, Byte *);
void execute_store(Instruction, Processor *, Byte *);
void execute_ecall(Processor *, Byte *);
void execute_lui(Instruction, Processor *);

void execute_instruction(uint32_t instruction_bits, Processor *processor,Byte *memory) {    
    Instruction instruction = parse_instruction(instruction_bits);
    switch(instruction.opcode) {
        case 0x33:
            execute_rtype(instruction, processor);
            break;
        case 0x13:
            execute_itype_except_load(instruction, processor);
            break;
        case 0x73:
            execute_ecall(processor, memory);
            break;
        case 0x63:
            execute_branch(instruction, processor);
            break;
        case 0x6F:
            execute_jal(instruction, processor);
            break;
        case 0x23:
            execute_store(instruction, processor, memory);
            break;
        case 0x03:
            execute_load(instruction, processor, memory);
            break;
        case 0x37:
            execute_lui(instruction, processor);
            break;
        default: // undefined opcode
            handle_invalid_instruction(instruction);
            exit(-1);
            break;
    }
}

void execute_rtype(Instruction instruction, Processor *processor) {
    switch (instruction.rtype.funct3){
        case 0x0:
            switch (instruction.rtype.funct7) {
                case 0x0:
                  // Add
                  processor->R[instruction.rtype.rd] =
                      ((sWord)processor->R[instruction.rtype.rs1]) +
                      ((sWord)processor->R[instruction.rtype.rs2]);
                  break;
                case 0x1:
                  // Mul
                  processor->R[instruction.rtype.rd] =
                      ((sWord)processor->R[instruction.rtype.rs1]) *
                      ((sWord)processor->R[instruction.rtype.rs2]);
                  break;
                case 0x20:
                    // Sub
                    processor->R[instruction.rtype.rd] =
                      ((sWord)processor->R[instruction.rtype.rs1]) -
                      ((sWord)processor->R[instruction.rtype.rs2]);
                    break;
                default:
                    handle_invalid_instruction(instruction);
                    exit(-1);
                    break;
            }
            break;
        case 0x1:
            switch (instruction.rtype.funct7) {
                case 0x0:
                    // SLL
                    processor->R[instruction.rtype.rd] =
                      (processor->R[instruction.rtype.rs1]) <<
                      (processor->R[instruction.rtype.rs2]);
                    break;
                case 0x1:
                    // MULH
                    processor->R[instruction.rtype.rd] =
                      ((sDouble)processor->R[instruction.rtype.rs1]) *
                      ((sDouble)processor->R[instruction.rtype.rs2]);
                    break;
            }
            break;
        case 0x2:
            // SLT
            processor->R[instruction.rtype.rd] =
                (((sWord)processor->R[instruction.rtype.rs1]) <
                ((sWord)processor->R[instruction.rtype.rs2])) ? 
                1 : 0;
            break;
        case 0x4:
            switch (instruction.rtype.funct7) {
                case 0x0:
                    // XOR
                    processor->R[instruction.rtype.rd] =
                      (processor->R[instruction.rtype.rs1]) ^
                      (processor->R[instruction.rtype.rs2]);
                    break;
                case 0x1:
                    // DIV
                    processor->R[instruction.rtype.rd] =
                      ((sWord)processor->R[instruction.rtype.rs1]) /
                      ((sWord)processor->R[instruction.rtype.rs2]);
                    break;
                default:
                    handle_invalid_instruction(instruction);
                    exit(-1);
                    break;
            }
            break;
        case 0x5:
            switch (instruction.rtype.funct7) {
                case 0x0:
                    // SRL
                    processor->R[instruction.rtype.rd] =
                      (processor->R[instruction.rtype.rs1]) >>
                      (processor->R[instruction.rtype.rs2]);      
                    break;
                case 0x20:
                    // SRA
                    processor->R[instruction.rtype.rd] =
                      ((sWord)processor->R[instruction.rtype.rs1]) >>
                      ((Word)processor->R[instruction.rtype.rs2]);
                    break;
                default:
                    handle_invalid_instruction(instruction);
                    exit(-1);
                break;
            }
            break;
        case 0x6:
            switch (instruction.rtype.funct7) {
                case 0x0:
                    // OR
                    processor->R[instruction.rtype.rd] =
                      (processor->R[instruction.rtype.rs1]) |
                      (processor->R[instruction.rtype.rs2]);
                    break;
                case 0x1:
                    // REM
                    processor->R[instruction.rtype.rd] =
                      ((sWord)processor->R[instruction.rtype.rs1]) %
                      ((sWord)processor->R[instruction.rtype.rs2]);
                    break;
                default:
                    handle_invalid_instruction(instruction);
                    exit(-1);
                    break;
            }
            break;
        case 0x7:
            // AND
            processor->R[instruction.rtype.rd] =
                (processor->R[instruction.rtype.rs1]) &
                (processor->R[instruction.rtype.rs2]);
            break;
        default:
            handle_invalid_instruction(instruction);
            exit(-1);
            break;
    }
    processor->PC += 4;
}

void execute_itype_except_load(Instruction instruction, Processor *processor) {
    unsigned int xfunc7 = instruction.itype.imm >> 5;
    switch (instruction.itype.funct3) {
        case 0x0:
            // ADDI
            processor->R[instruction.itype.rd] =
                ((sWord)processor->R[instruction.itype.rs1]) +
                (sign_extend_number(instruction.itype.imm, 12));
            break;
        case 0x1:
            // SLLI
            processor->R[instruction.itype.rd] =
                (processor->R[instruction.itype.rs1]) <<
                (sign_extend_number((instruction.itype.imm, 12));
            break;
        case 0x2:
            // STLI
            processor->R[instruction.itype.rd] =
                (((sWord)processor->R[instruction.itype.rs1]) <
                (sign_extend_number(instruction.itype.imm, 12)))?
                1 : 0;
            break;
        case 0x4:
            // XORI
            processor->R[instruction.itype.rd] =
                (processor->R[instruction.itype.rs1]) ^
                (sign_extend_number(instruction.itype.imm, 12));
            break;
        case 0x5:
            // Shift Right (You must handle both logical and arithmetic)
            unsigned int xfunc7 = instruction.itype.imm >> 5;
            // SRLI
            if(xfunc7 == 0x00) {
                processor->R[instruction.itype.rd] =
                    (processor->R[instruction.itype.rs1]) >>
                    (sign_extend_number((instruction.itype.imm << 7), 12));
            }
            // SRAI
            else{
                processor->R[instruction.itype.rd] =
                    ((sWord)processor->R[instruction.itype.rs1]) >>
                    (sign_extend_number((instruction.itype.imm << 7), 12));

            }
        case 0x6:
            // ORI
            processor->R[instruction.itype.rd] =
                (processor->R[instruction.itype.rs1]) |
                (sign_extend_number(instruction.itype.imm, 12));
            break;
        case 0x7:
            // ANDI
            processor->R[instruction.itype.rd] =
                (processor->R[instruction.itype.rs1]) &
                (sign_extend_number(instruction.itype.imm, 12));
            break;
        default:
            handle_invalid_instruction(instruction);
            break;
    }
    processor->PC += 4;
}

void execute_ecall(Processor *p, Byte *memory) {
    Register i;
    
    // syscall number is given by a0 (x10)
    // argument is given by a1
    switch(p->R[10]) {
        case 1: // print an integer
            printf("%d",p->R[11]);
            break;
        case 4: // print a string
            for(i=p->R[11];i<MEMORY_SPACE && load(memory,i,LENGTH_BYTE);i++) {
                printf("%c",load(memory,i,LENGTH_BYTE));
            }
            break;
        case 10: // exit
            printf("exiting the simulator\n");
            exit(0);
            break;
        case 11: // print a character
            printf("%c",p->R[11]);
            break;
        default: // undefined ecall
            printf("Illegal ecall number %d\n", p->R[10]);
            exit(-1);
            break;
    }
}

// (sHalf)?
void execute_branch(Instruction instruction, Processor *processor) {
    // pc += imm
    switch (instruction.sbtype.funct3) {
        case 0x0:
            // BEQ
            if(processor->R[instruction.sbtype.rs1] == processor->R[instruction.sbtype.rs2]) {
                processor->PC += sign_extend_number(get_branch_offset(instruction), 12);
            }
            break;
        case 0x1:
            // BNE
            if(processor->R[instruction.sbtype.rs1] != processor->R[instruction.sbtype.rs2]) {
                processor->PC += sign_extend_number(get_branch_offset(instruction), 12);
            }
            break;
        default:
            handle_invalid_instruction(instruction);
            exit(-1);
            break;
    }
}

void execute_load(Instruction instruction, Processor *processor, Byte *memory) {
    // rd = M[rs1+imm]
    switch (instruction.itype.funct3) {
        case 0x0:
            // LB
            processor->R[instruction.itype.rd] = sign_extend_number(
                load(memory, (((sWord)processor->R[instruction.itype.rs1]) + 
                (sign_extend_number(processor->R[instruction.itype.imm], 12))), LENGTH_BYTE), 8);
            break;
        case 0x1:
            // LH
            processor->R[instruction.itype.rd] = sign_extend_number(
                load(memory, (((sWord)processor->R[instruction.itype.rs1]) + 
                (sign_extend_number(processor->R[instruction.itype.imm], 12))), LENGTH_HALF_WORD), 16);
            break;
        case 0x2:
            // LW
            processor->R[instruction.itype.rd] =
                load(memory, (((sWord)processor->R[instruction.itype.rs1]) + 
                (sign_extend_number(processor->R[instruction.itype.imm], 12))), LENGTH_WORD);
            break;
        default:
            handle_invalid_instruction(instruction);
            break;
    }
}

void execute_store(Instruction instruction, Processor *processor, Byte *memory) {
    // M[rs1+imm] = rs2
    switch (instruction.stype.funct3) {
        case 0x0:
            // SB
            store(memory, ((sWord)(processor->R[instruction.stype.rs1]) + 
            (sign_extend_number(get_store_offset(instruction), 12))), LENGTH_BYTE, 
            processor->R[instruction.stype.rs2]);
            break;
        case 0x1:
            // SH
            store(memory, ((sWord)(processor->R[instruction.stype.rs1]) + 
            (sign_extend_number(get_store_offset(instruction), 12))), LENGTH_HALF_WORD, 
            processor->R[instruction.stype.rs2]);            
            break;
        case 0x2:
            // SW
            store(memory, ((sWord)(processor->R[instruction.stype.rs1]) + 
            (sign_extend_number(get_store_offset(instruction), 12))), LENGTH_WORD, 
            processor->R[instruction.stype.rs2]);            
            break;
        default:
            handle_invalid_instruction(instruction);
            exit(-1);
            break;
    }
}

void execute_jal(Instruction instruction, Processor *processor) {
    /* YOUR CODE HERE */
    // rd=pc+4; pc+=imm
    processor->R[instruction.ujtype.rd] = processor->PC + 4;
    processor->PC += sign_extend_number(get_jump_offset(instruction), 21);
}

void execute_lui(Instruction instruction, Processor *processor) {
    /* YOUR CODE HERE */
    // 20 bits << 12 == 32 bits
    processor->R[instruction.utype.rd] = instruction.utype.imm << 12;
}

void store(Byte *memory, Address address, Alignment alignment, Word value) {
    /* YOUR CODE HERE */
    if(address > MEMORY_SPACE) {
        handle_invalid_write(address);
        exit(-1);
    }  
    switch(alignment) {
        case LENGTH_BYTE:
            // 0x000000ff
            memory[address] = (Byte)(value & ((1U << 8) - 1));
            break;
        case LENGTH_HALF_WORD:
            // 0x000000ff
            memory[address] = (Byte)(value & ((1U << 8) - 1));
            // 0x0000ff00
            memory[address + 1] = (Byte)((value & ((1U << 16) - 1)) >> 8);
            break;
        case LENGTH_WORD:
            // 0x000000ff
            memory[address] = (Byte)(value & ((1U << 8) - 1));
            // 0x0000ff00
            memory[address + 1] = (Byte)((value & ((1U << 16) - 1)) >> 8);
            // 0x00ff0000
            memory[address + 2] = (Byte)((value & ((1U << 24) - 1)) >> 16);
            // 0xff000000
            memory[address + 3] = (Byte)((value & ((1U << 32) - 1)) >> 24);
            break;
        default:
            printf("Invalid Alignment!");
            break;        
    }
}

Word load(Byte *memory, Address address, Alignment alignment) {
    /* YOUR CODE HERE */
    if(address > MEMORY_SPACE) {
        handle_invalid_read(address);
        exit(-1);  
    }
    Word data = 0;  
    switch(alignment) {
        case LENGTH_BYTE:
            data = data | memory[address];
            break;
        case LENGTH_HALF_WORD:
            data = data | memory[address];
            data = data | (memory[address + 1] << 8);
            break;
        case LENGTH_WORD:
            data = data | memory[address];
            data = data | (memory[address + 1] << 8);    
            data = data | (memory[address + 2] << 16);
            data = data | (memory[address + 3] << 24);    
            break;
        default:
            printf("Invalid Alignment!");
            break;        
    }

    return data;
}
