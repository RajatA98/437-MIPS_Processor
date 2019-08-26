`include "register_file_if.vh"
`include "cpu_types_pkg.vh"
module register_file
(
	input logic clk,
	input logic n_rst,
	register_file_if.rf rfif
	
);
	
	//register_file_if rfif();
	import cpu_types_pkg::*;
	word_t [31:0]reg_file;
	word_t [31:0]n_reg_file;
	//logic [31:0]EN;
	
	
	
	always_comb
	begin
		n_reg_file = reg_file;
		rfif.rdat1 = 0;
		rfif.rdat2 = 0;	
		if(rfif.WEN)
			n_reg_file[rfif.wsel] = rfif.wdat;
		if(rfif.rsel1)
			rfif.rdat1 = reg_file[rfif.rsel1];
		if(rfif.rsel2)
			rfif.rdat2 = reg_file[rfif.rsel2];
		n_reg_file[0] = 0;
	end
	
	always_ff @(posedge clk, negedge n_rst)
	begin
		if(!n_rst)
			reg_file <= 0;
		else
			reg_file <= n_reg_file;
	end
endmodule
		
		
		
			
		
		
	 	


