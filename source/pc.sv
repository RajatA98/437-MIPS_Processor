`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
module pc
(
	input logic CLK, nRST,
	//input from cache
	input logic ihit,
	//input from control unit
	input logic halt,
	//input from mux
	input word_t next_addr,
	output word_t iaddr
);

	always_ff @(posedge CLK, negedge nRST)
	begin
		if(!nRST)
			iaddr <= 32'b0;
		else if(ihit && !halt)
			iaddr <= next_addr;
		else
			iaddr <= iaddr;
	end
endmodule
