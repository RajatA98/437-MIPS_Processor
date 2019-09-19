`ifndef DECODE_EXECUTE_IF_VH
`define DECODE_EXECUTE_IF_VH
// types
`include "cpu_types_pkg.vh"

interface execute_memory
//signals from decode_execute_if
logic RegWr_EX;
logic [1:0]RegDst_EX;
logic memtoReg_EX, memWr_EX;
logic [1:0]PC_Src_EX;
logic [1:0]Wsel_EX;
word_t busA_EX, imemaddr_EX, instr_EX, jump_addr, branch_addr;
opcode_t opcode_EX;
funct_t funct_EX;
logic [15:0]imm16_EX;
//signals from ALU

logic zero;
word_t Output_Port;

//enable and flush

logic enable, flush;

//outputs

logic RegWr_MEM;
logic [1:0]RegDst_MEM;
logic memtoReg_MEM, memWr_MEM; //assign in datapath to dmemREN/WEN
logic [1:0]PC_Src_MEM;
logic [1:0]Wsel_MEM;
word_t instr_MEM, busA_MEM, jump_addr_MEM, branch_addr_MEM;
opcode_t opcode_MEM;
funct_t funct_MEM;
logic [15:0]imm16_MEM;
//signals from ALU

logic zero_MEM;
logic Output_Port_MEM;



modport exmem(

input RegWr_EX, RegDst_EX, memtoReg_EX, memWr_EX, PC_Src_EX, Wsel_EX, busA_EX, busB_EX, imemaddr_EX, jump_addr, branch_addr, zero, opcode_EX, funct_EX, imm16_EX, Output_Port, enable, flush,

output RegWr_MEM, RegDst_MEM, memtoReg_MEM, memWr_MEM, PC_Src_MEM, Wsel_MEM, instr_MEM, busA_MEM, busB_MEM, imemaddr_MEM, jump_addr_MEM, branch_addr_MEM, zero_MEM, Output_Port_MEM

);

`endif





