`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
module extender
(
	input logic [1:0]EXTop,
	input logic [15:0]imm16,
	output word_t extended
);

	always_comb
	begin
		if(EXTop == 2'd1)//zero extended
			extended = {16'b0,imm16};
		else if (EXTop == 2'd2)
			extended = {imm16, 16'b0};
		else if (imm16[15])
			extended = {16'hffff,imm16};
		else
			extended = {16'b0,imm16};
			
	end
		
endmodule
