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
word_t busA_EX, busB_EX, next_addr_EX, imemaddr_EX, instr_EX, jump_addr, branch_addr, extended;
regbits_t rs_EX,rt_EX;
opcode_t opcode_EX;
funct_t funct_EX;
logic [15:0]imm16_EX;
logic [4:0]shamt_EX;
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
word_t busA_MEM, busB_MEM, next_addr_MEM, imemaddr_MEM, instr_MEM,  jump_addr_MEM, branch_addr_MEM, extended_MEM;

regbits_t rs_MEM,rt_MEM;
opcode_t opcode_MEM;
funct_t funct_MEM;
logic [15:0]imm16_MEM;
logic [4:0]shamt_MEM;
//signals from ALU

logic zero_MEM;
logic Output_Port_MEM;



modport exmem(

input RegWr_EX, RegDst_EX, memtoReg_EX, memWr_EX, PC_Src_EX, Wsel_EX, busA_EX, busB_EX, next_addr_EX, imemaddr_EX, jump_addr, branch_addr, extended, rs_EX, rt_EX, opcode_EX, funct_EX, imm16_EX, shamt_EX, zero, Output_Port, enable, flush,

output RegWr_MEM, RegDst_MEM, memtoReg_MEM, memWr_MEM, PC_Src_MEM, Wsel_MEM, instr_MEM, busA_MEM, busB_MEM, next_addr_MEM, imemaddr_MEM, jump_addr_MEM, branch_addr_MEM, extended_MEM,  rs_MEM, rt_MEM, opcode_MEM, funct_MEM, imm16_MEM, shamt_MEM, zero_MEM, Output_Port_MEM

);

endinterface
`endif





