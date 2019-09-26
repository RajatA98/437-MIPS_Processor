`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
module hazard_unit
(
	input word_t instr_ID, instr_EX, instr_MEM,
	input logic RegWr_MEM,
	output logic flush_ID, flush_EX, flush_MEM, pc_enable, enable_ID, enable_EX, enable_MEM
);

r_t rt_ID, rt_EX, rt_MEM;
i_t it_ID, it_EX, it_MEM;

assign rt_ID = instr_ID;
assign rt_EX = instr_EX;
assign rt_MEM = instr_MEM;
assign it_ID = instr_ID;
assign it_EX = instr_EX;
assign it_MEM = instr_MEM;
always_comb
begin
	flush_ID = 1'b0;
	flush_EX = 1'b0;
	flush_MEM = 1'b0;
	enable_ID = 1'b1;
	enable_EX = 1'b1;
	enable_MEM = 1'b1;
	pc_enable = 1'b0;

	casez(rt_MEM.opcode)
			RTYPE:
			begin
				if(rt_MEM.funct == JR)
				begin
					flush_ID = 1'b1;
					flush_EX = 1'b1;
					flush_MEM = 1'b0;
					pc_enable = 1'b0;
				end			
			end
			J:
			begin
				flush_ID = 1'b1;
				flush_EX = 1'b1;
				flush_MEM = 1'b1;
				pc_enable = 1'b0;
			end
			JAL:
			begin
				flush_ID = 1'b1;
				flush_EX = 1'b1;
				flush_MEM = 1'b1;
				pc_enable = 1'b0;
			end
	endcase
	if(RegWr_MEM)
	begin
		if((((rt_EX.rd == rt_ID.rs || rt_EX.rd == rt_ID.rt) && (rt_EX.opcode == RTYPE)) || it_EX.rt == it_ID.rs))
		begin
	
			pc_enable = 1'b1;
			enable_ID = 1'b0;
			flush_EX = 1'b1;
		end
		if((((rt_MEM.rd == rt_ID.rs || rt_MEM.rd == rt_ID.rt) && (rt_MEM.opcode == RTYPE)) || it_MEM.rt == it_ID.rs))
		begin
			pc_enable = 1'b1;
			enable_ID = 1'b0;
			flush_EX = 1'b1;
		end
	end
	
end
endmodule
			



