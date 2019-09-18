`ifndef DECODE_EXECUTE_IF_VH
`define DECODE_EXECUTE_IF_VH
// types
`include "cpu_types_pkg.vh"
`include "register_file_if.vh"

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



//signals from fetch_decode_if

word_t imemaddr_ID, instr_ID;

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


//signals from the register file
register_file_if rfif();

logic busA_EX, busB_EX;



//signals from fetch_decode_if

logic imemaddr_EX, instr_EX;

//eanble and flush
logic enable, flush;

modport idex (

input enable, flush, memtoReg, memWR, ALUop, ALU_Src, EXTop, halt, PC_Src, RegDst, RegWr, Wsel, busA, busB, imemaddr_ID, instr_ID,

output memtoReg_EX, memWR_EX, ALUop_EX, ALU_Src_EX, EXTop_EX, halt_EX, PC_Src_EX, RegDst_EX, RegWr_EX, Wsel_EX, busA_EX, busB_EX, imemaddr_EX, instr_EX
);

`endif






