`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"
import cpu_types_pkg::*;

module control_unit
(
	//input instruction from cache
	input word_t iload,
	//input from ALU
	input logic equal,
	//output to request unit
	output logic memtoReg, memWr,
	//output to ALU
	output aluop_t ALUop,
	output logic ALU_Src,
	//output to extender
	output logic [1:0] EXTop,
	//output to PC
	output logic halt, 
	output logic [1:0]PC_Src,
	//output to regfile
	output logic [1:0]RegDst,
	output logic RegWr,
	output logic [1:0]Wsel,
	//output to cache
	output logic iREN
);
	
r_t rt;
assign rt = iload;	

always_comb
begin
	memtoReg = 1'b0;
	memWr = 1'b0;
	ALUop = ALU_OR;
	ALU_Src = 1'b0;
	EXTop = 2'b0;
	halt = 1'b0;
	PC_Src = 2'b0;
	RegDst = 2'b0;
	RegWr = 1'b0;
	Wsel = 2'b0;
	iREN = 1'b1;
	casez(rt.opcode)
		RTYPE:
		begin
			casez(rt.funct)
				SLLV:
				begin
					RegWr = 1'b1;
					ALUop = ALU_SLL;
					RegDst = 2'd1;
				end
				SRLV:
				begin
					RegWr = 1'b1;
					ALUop = ALU_SRL;
					RegDst = 2'd1;
				end
				JR:
				begin
					PC_Src = 2'd3;
					RegDst = 2'b10;
				end
				ADD:
				begin
					RegDst = 2'd1;
					RegWr = 1'b1;
					ALUop = ALU_ADD;				
				end
				ADDU:
				begin
					RegDst = 2'd1;
					RegWr = 1'b1;
					ALUop = ALU_ADD;
				end
				SUB:
				begin
					RegDst = 2'd1;
					RegWr = 1'b1;
					ALUop = ALU_SUB;
				end
				SUBU:
				begin
					RegDst = 2'd1;
					RegWr = 1'b1;
					ALUop = ALU_SUB;
				end
				AND:
				begin
					RegDst = 2'd1;
					RegWr = 1'b1;
					ALUop = ALU_AND;
				end
				OR:
				begin
					RegDst = 2'd1;
					RegWr = 1'b1;
					ALUop = ALU_OR;
				end
				XOR:
				begin
					RegDst = 2'd1;
					RegWr = 1'b1;
					ALUop = ALU_XOR;
				end
				NOR:
				begin
					RegDst = 2'd1;
					RegWr = 1'b1;
					ALUop = ALU_NOR;
				end
				SLT:
				begin
					RegDst = 2'd1;
					RegWr = 1'b1;
					ALUop = ALU_SLT;
				end
				SLTU:
				begin
					RegDst = 2'd1;
					RegWr = 1'b1;
					ALUop = ALU_SLTU;
				end
			endcase
		end
		J:
		begin
			PC_Src = 2'd2;
		end
		JAL://ask ta
		begin
			PC_Src = 2'd2;
			RegDst = 2'd2;
			RegWr = 1'b1;
			Wsel = 2'd1;
			
		end
		BEQ:
		begin
			ALUop = ALU_SUB;
			if(equal)
				PC_Src = 2'd1;
			
		end
		BNE:
		begin
			ALUop = ALU_SUB;
			if(!equal)
				PC_Src = 2'd1;
		end
		ADDI:
		begin
			RegWr = 1'b1;
			ALU_Src = 1'b1;	
			ALUop = ALU_ADD;			
		end
		ADDIU:
		begin
			RegWr = 1'b1;
			ALU_Src = 1'b1;	
			ALUop = ALU_ADD;
		end
		SLTI:
		begin
			RegWr = 1'b1;
			ALU_Src = 1'b1;	
			ALUop = ALU_SLT;
		end
		SLTIU:
		begin
			RegWr = 1'b1;
			ALU_Src = 1'b1;	
			ALUop = ALU_SLTU;
		end
		ANDI:
		begin
			RegWr = 1'b1;
			ALU_Src = 1'b1;
			EXTop = 2'd1;	
			ALUop = ALU_AND;
		end
		ORI:
		begin
			RegWr = 1'b1;
			ALU_Src = 1'b1;
			EXTop = 2'd1;	
			ALUop = ALU_OR;
		end
		XORI:
		begin
			RegWr = 1'b1;
			ALU_Src = 1'b1;
			EXTop = 2'd1;	
			ALUop = ALU_XOR;
		end
		LUI: //ask ta
		begin
			RegWr = 1'b1;
			EXTop = 2'd2;	
			Wsel = 2'd2;
		end
		LW:
		begin
			RegWr = 1'b1;
			ALU_Src = 1'b1;
			ALUop = ALU_ADD;
			memtoReg = 1'b1;
		end
		SW:
		begin
			
			ALU_Src = 1'b1;
			ALUop = ALU_ADD;
			memWr = 1'b1;
		end
		HALT:
		begin
			halt = 1'b1;
		end
	endcase
end
endmodule
