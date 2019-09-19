`ifndef MEMORY_WB_IF_VH
`define MEMORY_WB_IF_VH

`include "cpu_types_pkg.vh"

interface memory_wb_if;
  // import types
  import cpu_types_pkg::*;

<<<<<<< HEAD
  word_t Output_Port_MEM, Output_Port_WB,imemaddr_MEM, imemaddr_WB, instr_MEM, instr_WB;
  logic memtoReg_MEM, memtoReg_WB, RegWr_MEM, RegWr_WB,flush, enable;
  logic [1:0] RegDst_MEM, RegDst_WB;

=======
  word_t Output_Port_MEM, Output_Port_WB,busB_MEM, busB_WB, next_addr_MEM, next_addr_WB, imemaddr_MEM, imemaddr_WB, jump_addr_MEM, jump_addr_WB, branch_addr_MEM, branch_addr_WB, extended_MEM, extended_WB instr_MEM, instr_WB;
  logic MemtoReg_MEM, MemtoReg_WB, RegWr_MEM, RegWr_WB,flush, enable;
  logic [1:0] RegDst_MEM, RegDst_WB, Wsel_MEM, Wsel_WB;
	regbits_t rs_MEM,rt_MEM,rs_WB, rt_WB;
>>>>>>> a36603fb9e58bc090df024b623c3789041f63fe7
  opcode_t opcode_MEM, opcode_WB;
  funct_t funct_MEM, funct_WEB;
  logic [15:0] imm16_MEM, imm16_WB;
	logic [4:0]shamt_MEM, shamt_WB;

  modport mw (
<<<<<<< HEAD
    input flush, enable, memtoReg_MEM,Output_Port_MEM,RegDst_MEM,RegWr_MEM,
=======
<<<<<<< HEAD
    input flush, enable, RegWr_MEM, RegDst_MEM, memtoReg_MEM, memWr_MEM, Wsel_MEM, instr_MEM, busB_MEM, next_addr_MEM, imemaddr_MEM, jump_addr_MEM, branch_addr_MEM, extended_MEM,  rs_MEM, rt_MEM, opcode_MEM, funct_MEM, imm16_MEM, shamt_MEM,  Output_Port_MEM
    output RegWr_WB, RegDst_WB, memtoReg_WB, memWr_WB, PC_Src_WB, Wsel_WB, instr_WB, busA_WB, busB_WB, next_addr_WB, imemaddr_WB, jump_addr_WB, branch_addr_WB, extended_WB,  rs_WB, rt_WB, opcode_WB, funct_WB, imm16_WB, shamt_WB,  Output_Port_WB
=======
    input flush, enable, MemtoReg_MEM,Output_Port_MEM,RegDst_MEM,RegWr_MEM,
>>>>>>> a36603fb9e58bc090df024b623c3789041f63fe7
opcode_MEM, funct_MEM, imm16_MEM, instr_MEM, imemaddr_MEM,
    output RegDst_WB, RegWr_WB, Output_Port_WB, memtoReg_WB, imemaddr_WB,
opcode_WB, funct_WB, imm16_WB, instr_WB
>>>>>>> 40a6c7c6ea95b187ecd16ddc120b6a27c7a41d3a
  );

endinterface
`endif
