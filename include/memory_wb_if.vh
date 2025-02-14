`ifndef MEMORY_WB_IF_VH
`define MEMORY_WB_IF_VH

`include "cpu_types_pkg.vh"

interface memory_wb_if;
  // import types
  import cpu_types_pkg::*;


  word_t Output_Port_MEM, Output_Port_WB,busB_MEM, busB_WB, next_addr_MEM, next_addr_WB, imemaddr_MEM, imemaddr_WB, jump_addr_MEM, jump_addr_WB, branch_addr_MEM, branch_addr_WB, extended_MEM, extended_WB, instr_MEM, instr_WB;
  logic memtoReg_MEM, memtoReg_WB, memWr_MEM, memWr_WB, RegWr_MEM, RegWr_WB,flush, enable;
  logic [1:0] RegDst_MEM, RegDst_WB, Wsel_MEM, Wsel_WB;
	regbits_t rs_MEM,rt_MEM,rs_WB, rt_WB;
	word_t dload, dload_WB;
  opcode_t opcode_MEM, opcode_WB;
  funct_t funct_MEM, funct_WB;
  logic [15:0] imm16_MEM, imm16_WB; 
	logic [4:0]shamt_MEM, shamt_WB, final_wsel_MEM, final_wsel_WB;
	logic halt_MEM, halt_WB;


  modport mw (

    input flush, enable, RegWr_MEM, RegDst_MEM, memtoReg_MEM, memWr_MEM, Wsel_MEM, instr_MEM, busB_MEM, next_addr_MEM, imemaddr_MEM, jump_addr_MEM, branch_addr_MEM, extended_MEM,  rs_MEM, rt_MEM, opcode_MEM, funct_MEM, imm16_MEM, shamt_MEM,  Output_Port_MEM,halt_MEM,dload, final_wsel_MEM,
    output RegWr_WB, RegDst_WB, memtoReg_WB, memWr_WB, Wsel_WB, instr_WB, busB_WB, next_addr_WB, imemaddr_WB, jump_addr_WB, branch_addr_WB, extended_WB,  rs_WB, rt_WB, opcode_WB, funct_WB, imm16_WB, shamt_WB,  Output_Port_WB, halt_WB,dload_WB, final_wsel_WB
  );

endinterface
`endif
