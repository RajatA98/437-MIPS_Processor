`ifndef MEMORY_WB_IF_VH
`define MEMORY_WB_IF_VH

`include "cpu_types_pkg.vh"

interface memory_wb_if;
  // import types
  import cpu_types_pkg::*;

  word_t Output_Port_MEM, Output_Port_WB,imemaddr_MEM, imemaddr_WB, instr_MEM, instr_WB;
  logic MemtoReg_MEM, MemtoReg_WB, RegWr_MEM, RegWr_WB,flush, enable;
  logic [1:0] RegDst_MEM, RegDst_WB;

  opcode_t opcode_MEM, opcode_WB;
  funct_t funct_MEM, funct_WEB;
  logic [15:0] imm16_MEM, imm16_WB;

  modport mw (
    input flush, enable, MemtoReg_MEM,Output_Port_MEM,RegDst_MEM,RegWr_MEM,
opcode_MEM, funct_MEM, imm16_MEM, instr_MEM, imemaddr_MEM,
    output RegDst_WB, RegWr_WB, Output_Port_WB, MemtoReg_W, imemaddr_WB,
opcode_WB, funct_WB, imm16_WB, instr_WB
  );

endinterface
`endif
