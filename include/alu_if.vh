`ifndef ALU_IF_VH
`define ALU_IF_VH

`include "cpu_types_pkg.vh"

interface alu_if;

	import cpu_types_pkg::*;
	
	logic negative, overflow, zero;
	aluop_t ALUOP;
	word_t Port_A, Port_B, Output_Port;

	modport alu(
		input Port_A, Port_B, ALUOP,
		output Output_Port, negative, overflow, zero
	);

	modport tb(
		input Output_Port, negative, overflow, zero,
		output Port_A, Port_B, ALUOP
	);
endinterface
`endif 
