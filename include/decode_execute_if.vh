`ifndef DECODE_EXECUTE_IF_VH
`define DECODE_EXECUTE_IF_VH
// types
`include "cpu_types_pkg.vh"

interface decode_execute_if;
  // import types
  import cpu_types_pkg::*;


//signals from the control unit
logic memtoReg, memWr;
aluop_t ALUop;
logic ALU_Src;
logic [1:0] EXTop;
logic halt;
logic [1:0] PC_Src;
logic [1:0] RegDst;
logic RegWr;
logic [1:0]Wsel;


//signals from the register file

word_t busA, busB;

regbits_t rs,rt;
opcode_t opcode;
funct_t funct;
logic [15:0]imm16;
logic [4:0]shamt;

//signals from fetch_decode_if

word_t next_addr_ID, imemaddr_ID, instr_ID;

//signals from the control unit
logic memtoReg_EX, memWr_EX;
aluop_t ALUop_EX;
logic ALU_Src_EX;
logic [1:0] EXTop_EX;
logic halt_EX;
logic [1:0] PC_Src_EX;
logic [1:0] RegDst_EX;
logic RegWr_EX;
logic [1:0]Wsel_EX;
logic [4:0] final_wsel, final_wsel_EX;


//signals from the register file



word_t busA_EX, busB_EX;


regbits_t rs_EX,rt_EX;
opcode_t opcode_EX;
funct_t funct_EX;
logic [15:0]imm16_EX;
logic [4:0]shamt_EX;
//signals from fetch_decode_if

word_t next_addr_EX, imemaddr_EX, instr_EX;

//eanble and flush
logic enable, flush;

modport idex (

input enable, flush, memtoReg, memWr, ALUop, ALU_Src, EXTop, halt, PC_Src, RegDst, RegWr, Wsel, busA, busB, rs, rt, opcode, funct, imm16, shamt, next_addr_ID, imemaddr_ID, instr_ID, final_wsel,

output memtoReg_EX, memWr_EX, ALUop_EX, ALU_Src_EX, EXTop_EX, halt_EX, PC_Src_EX, RegDst_EX, RegWr_EX, Wsel_EX, busA_EX, busB_EX,rs_EX, rt_EX, opcode_EX, funct_EX, imm16_EX, shamt_EX, next_addr_EX, imemaddr_EX, instr_EX, final_wsel_EX
);

endinterface
`endif






