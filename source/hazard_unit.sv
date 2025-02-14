`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
module hazard_unit
(
	input word_t instr_ID, instr_EX, instr_MEM,
	input logic RegWr_EX, memWr_EX, RegWr_MEM, memWr_MEM,
	output logic flush_ID, flush_EX, flush_MEM, pc_enable, enable_ID, enable_EX, enable_MEM,
  output logic [1:0] hazard
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
  hazard = 0;
	flush_ID = 1'b0;
	flush_EX = 1'b0;
	flush_MEM = 1'b0;
	pc_enable = 1'b0;

	if (rt_MEM.opcode == J || rt_MEM.opcode == JAL || (rt_MEM.funct == JR && rt_MEM.opcode == RTYPE))
	begin
	casez(rt_MEM.opcode)
			RTYPE:
			begin
				if(rt_MEM.funct == JR)
				begin
					flush_ID = 1'b1;
					flush_EX = 1'b1;
					flush_MEM = 1'b1;
					pc_enable = 1'b0;
					hazard = 2'b1;
				end			
			end
			J:
			begin
				flush_ID = 1'b1;
				flush_EX = 1'b1;
				flush_MEM = 1'b1;
				pc_enable = 1'b0;
				hazard = 2'b1;
			end
			JAL:
			begin
				flush_ID = 1'b1;
				flush_EX = 1'b1;
				flush_MEM = 1'b1;
				pc_enable = 1'b0;
				hazard = 2'b1;
			end
	endcase
end
 else if((RegWr_EX || memWr_EX) /*&& (rt_EX.opcode != J && rt_EX.opcode != JAL && rt_EX.funct != JR)*/)
	begin
		if(it_EX.opcode == LW || it_EX.opcode == LL)
		begin
			if(((it_ID.rs == it_EX.rt) || ((it_ID.rt == it_EX.rt) && it_ID.opcode == SW) && it_ID.opcode != RTYPE)  || ((rt_ID.rt == it_EX.rt || rt_ID.rs == it_EX.rt) && rt_ID.opcode == RTYPE))
			begin
				pc_enable = 1'b1;
				enable_ID = 1'b0;
				flush_EX = 1'b1;
				hazard = 2'b10;
			end
		end
		else if(it_EX.opcode == SC)
		begin
			if(((it_ID.rs == it_EX.rt) || ((it_ID.rt == it_EX.rt) && it_ID.opcode == SW) && it_ID.opcode != RTYPE)  || ((rt_ID.rt == it_EX.rt || rt_ID.rs == it_EX.rt) && rt_ID.opcode == RTYPE))
			begin
				pc_enable = 1'b1;
				enable_ID = 1'b0;
				flush_EX = 1'b1;
				hazard = 2'b11;
			end
		end
		else if((((rt_EX.rd == rt_ID.rs || rt_EX.rd == rt_ID.rt) && (rt_EX.opcode == RTYPE)) || (it_EX.opcode != RTYPE && it_EX.rt == it_ID.rs) || (it_ID.opcode == SW && it_EX.rt == it_ID.rt)))
		begin
      //hazard = 1;
			pc_enable = 1'b1;
			enable_ID = 1'b0;
			flush_EX = 1'b1;
		end
		else if (((it_EX.opcode == SW || it_EX.opcode == SC) ) && ((it_ID.rt == it_EX.rs) || it_EX.rt == it_ID.rs)) begin
			pc_enable = 1'b1;
			enable_ID = 1'b0;
			flush_EX = 1'b1;
      //hazard = 1;
		end
		/*else if(it_EX.opcode == LW)
		begin
			if((it_ID.rs == it_EX.rt && it_ID.opcode != RTYPE)  || ((rt_ID.rt == it_EX.rt || rt_ID.rs == it_EX.rt) && rt_ID.opcode == RTYPE))
			begin
				pc_enable = 1'b1;
				enable_ID = 1'b0;
				flush_EX = 1'b1;
				hazard = 2'b10;
			end
		end*/
	end
	else if((RegWr_MEM || memWr_MEM) /*&& (rt_MEM.opcode != J && rt_MEM.opcode != JAL && rt_MEM.funct != JR)*/)
	begin
		
		if(it_MEM.opcode == LW ||it_MEM.opcode == LL || it_MEM.opcode == SC )
		begin
			if(((it_ID.rs == it_EX.rt) || ((it_ID.rt == it_EX.rt) && it_ID.opcode == SW) && it_ID.opcode != RTYPE) || ((rt_ID.rt == it_MEM.rt || rt_ID.rs == it_MEM.rt) && rt_ID.opcode == RTYPE))
			begin
				pc_enable = 1'b1;
				enable_ID = 1'b0;
				flush_EX = 1'b1;
				//hazard = 2'b11;
			end
		end
		else if((((rt_MEM.rd == rt_ID.rs || rt_MEM.rd == rt_ID.rt) && (rt_MEM.opcode == RTYPE)) || (it_MEM.opcode != RTYPE && it_MEM.rt == it_ID.rs) || (it_ID.opcode == SW && it_MEM.rt == it_ID.rt)))
		begin
			pc_enable = 1'b1;
			enable_ID = 1'b0;
			flush_EX = 1'b1;
      //hazard = 2;
		end
	else if (((it_MEM.opcode == SW || it_MEM.opcode == SC) ) && ((it_ID.rt == it_MEM.rs) || it_MEM.rt == it_ID.rs)) begin
			pc_enable = 1'b1;
			enable_ID = 1'b0;
			flush_EX = 1'b1;
      //hazard = 2;
		end
		/*else if(it_MEM.opcode == LW)
		begin
			if((it_ID.rs == it_MEM.rt && it_ID.opcode != RTYPE)  || ((rt_ID.rt == it_MEM.rt || rt_ID.rs == it_MEM.rt) && rt_ID.opcode == RTYPE))
			begin
				pc_enable = 1'b1;
				enable_ID = 1'b0;
				flush_EX = 1'b1;
				hazard = 2'b10;
			end
		end*/
	end


end
endmodule




