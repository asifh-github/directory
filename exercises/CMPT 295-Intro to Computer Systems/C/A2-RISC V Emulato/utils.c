#include "utils.h"
#include <stdio.h>
#include <stdlib.h>

/* Sign extends the given field to a 32-bit integer where field is
 * interpreted an n-bit integer. */
int sign_extend_number(unsigned int field, unsigned int n) {
  /* YOUR CODE HERE */
  sWord result = 0;
  unsigned int bits = 1;
  for(int i=0; i<n; i++) {
    if(i == n-1) {
      // lec 5, p 41
      // u<<3 == u*2^3
      // field >> i extracts sign bit
      result = ((field >> i) * (-(1 << i))) + result;
    }
    else{
    bits = 1 << i;
    result += field & bits;
    }
  }
  return result;
}

/* Unpacks the 32-bit machine code instruction given into the correct
 * type within the instruction struct */
Instruction parse_instruction(uint32_t instruction_bits) {
  /* YOUR CODE HERE */
  Instruction instruction;
  // add x8, x0, x0     hex : 00000433  binary = 0000 0000 0000 0000 0000 01000
  // Opcode: 0110011 (0x33) Get the Opcode by &ing 0x1111111, bottom 7 bits
  instruction.opcode = instruction_bits & ((1U << 7) - 1);

  // Shift right to move to pointer to interpret next fields in instruction.
  instruction_bits >>= 7;

  switch (instruction.opcode) {
  // R-Type
  case 0x33:
    // instruction: 0000 0000 0000 0000 0000 destination : 01000
    instruction.rtype.rd = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;

    // instruction: 0000 0000 0000 0000 0 func3 : 000
    instruction.rtype.funct3 = instruction_bits & ((1U << 3) - 1);
    instruction_bits >>= 3;

    // instruction: 0000 0000 0000  src1: 00000
    instruction.rtype.rs1 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;

    // instruction: 0000 000        src2: 00000
    instruction.rtype.rs2 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;

    // funct7: 0000 000
    instruction.rtype.funct7 = instruction_bits & ((1U << 7) - 1);
    break;
  // cases for I-type 
  case 0x03:
  case 0x13:
  case 0x73:
    // rd
    instruction.itype.rd = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;
    // func3
    instruction.itype.funct3 = instruction_bits & ((1U << 3) - 1);
      instruction_bits >>= 3;
    // rs1
    instruction.itype.rs1 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;
    // imm
    instruction.itype.imm = instruction_bits & ((1U << 12) - 1);
    break;
  // case for S-type
  case 0x23:
    // imm5
    instruction.stype.imm5 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;
    // func3
    instruction.stype.funct3 = instruction_bits & ((1U << 3) - 1);
    instruction_bits >>= 3;
    // rs1
    instruction.stype.rs1 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;
    // rs2
    instruction.stype.rs2 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;
    // imm7
    instruction.stype.imm7 = instruction_bits & ((1U << 7) - 1);
    break;
  // case for SB-type 
  case 0x63:
    // imm5
    instruction.sbtype.imm5 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;
    // func3
    instruction.sbtype.funct3 = instruction_bits & ((1U << 3) - 1);
    instruction_bits >>= 3;
    // rs1
    instruction.sbtype.rs1 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;
    // rs2
    instruction.sbtype.rs2 = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;
    // imm7
    instruction.sbtype.imm7 = instruction_bits & ((1U << 7) - 1);
    break;
  // case for U-type 
  case 0x37:
    // rd
    instruction.utype.rd = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;
    // imm
    instruction.utype.imm = instruction_bits & ((1U << 20) - 1);
    break;
  // case for UJ-type 
  case 0x6f:
    // rd
    instruction.ujtype.rd = instruction_bits & ((1U << 5) - 1);
    instruction_bits >>= 5;
    // imm
    instruction.ujtype.imm = instruction_bits & ((1U << 20) - 1);
    break;
  // default 
  default:
    exit(EXIT_FAILURE);
  }
  return instruction;
}

/* Return the number of bytes (from the current PC) to the branch label using
 * the given branch instruction */
int get_branch_offset(Instruction instruction) {
  /* YOUR CODE HERE */
  // imm[4:1|11] - 5 bits 
  unsigned int imm51 = instruction.sbtype.imm5;
  // imm[12|10:5] - 7 bits
  unsigned int imm71 = instruction.sbtype.imm7;
  // imm[11] - 1 bit
  // 0x01
  unsigned int imm52 = (imm51 & 0x01) * (1U << 11);
  // imm[1:4] - 4 bits
  imm51 >>= 1;
  imm51 = imm51 * (1U << 1);
  // imm[5:10] - 6 bits
  // 0x3f
  unsigned int imm72 = (imm71 & 0x3f) * (1U << 5);
  // imm[12] - 1 bit 
  imm71 >>= 6;
  imm71 = imm71 * (1U << 12);

  return (imm51 + imm52 + imm71 + imm72);


  int imm5_1 = (instruction.sbtype.imm5 & 0x01);
  int imm5_2 = (instruction.sbtype.imm5 & 0x1d);
  int imm7_1 = (instruction.sbtype.imm7 & 0x3f);
  int imm7_2 = (instruction.sbtype.imm7 & 0x80);

  int imm = (imm7_2 << 11) | (imm5_2 << 10) | (imm7_1 << 4) | (imm5_2);

  return sign_extend_number(imm<<1, 13);
}

/* Returns the number of bytes (from the current PC) to the jump label using the
 * given jump instruction */
int get_jump_offset(Instruction instruction) {
  /* YOUR CODE HERE */
  // imm[20|10:1|11|19:12] - 20 bits 
  unsigned int imm1 = instruction.ujtype.imm;
  // imm[12:19] - 8 bits 
  // 0xff
  unsigned int imm2 = (imm1 & 0xff) * (1U << 12);
  imm1 >>= 8;
  // imm[11] - 1 bit
  // 0x01
  unsigned int imm3 = (imm1 & 0x01) * (1U << 11);
  imm1 >>= 1;
  // imm[1:10] - 10 bits 
  // 0x3ff
  unsigned int imm4 = (imm1 & 0x3ff) * (1U << 1);
  imm1 >>= 10;
  // imm [20] - 1 bit 
  imm1 = imm1 * (1U << 20);

  return (imm1 + imm2 + imm3 + imm4);


  int imm1 = (instruction.ujtype.imm & 0x000ff);
  int imm2 = (instruction.ujtype.imm & 0x00100);
  int imm3 = (instruction.ujtype.imm & 0x7fd00);
  int imm4 = (instruction.ujtype.imm & 0x80000);

  imm = (imm3 << 1) | (imm2 << 11) | (imm1 << 12) | (imm4 << 20);

  return sign_extend_number(imm, 21);
}

int get_store_offset(Instruction instruction) {
  /* YOUR CODE HERE */
  // imm[0:4]
  unsigned int imm5 = instruction.stype.imm5;
  unsigned int imm7 =  instruction.stype.imm7;
  // imm[5:11]
  imm7 = imm7 * (1U << 5);

  return (imm5 + imm7);


  int imm = instruction.stype.imm5 + (instruction.stype.imm7 << 5);

  return sign_extend_number(imm);

void handle_invalid_instruction(Instruction instruction) {
  printf("Invalid Instruction: 0x%08x\n", instruction.bits);
}

void handle_invalid_read(Address address) {
  printf("Bad Read. Address: 0x%08x\n", address);
  exit(-1);
}

void handle_invalid_write(Address address) {
  printf("Bad Write. Address: 0x%08x\n", address);
  exit(-1);
}
