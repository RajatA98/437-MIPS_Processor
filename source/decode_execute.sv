`include "decode_execute_if.vh"
import cpu_types_pkg::*;
module decode_execute(

	input CLK, nRST,
	decode_execute_if.IDEX idex
);

always_ff @(posedge CLK, negedge nRST)
begin
		if(!nRST || idex.flush)
		begin
			idex.memtoReg_EX <= 1'b0;
			idex.memtWr_EX <= 1'b0;
			idex.ALUop_EX <= '0;
			idex.ALU_Src_EX <= 1'b0;
			idex.EXTop_EX <= 2'b0;
			idex.halt_EX <= 1'b0;
			idex.PC_Src_EX <= 2'b0;
			idex.RegDst_EX <= 2'b0;
			idex.RegWr_EX <= 1'b0;
			idex.Wsel_EX <= 2'b0;
			idex.busA_EX <= '0;
			idex.busB_EX <= '0;
			idex.imemaddr_EX <= '0;
			idex.instr_EX <= '0;
			
		end
		else if(idex.enable)
		begin
			idex.idex.memtoReg_EX <= idex.memtoReg;
			idex.memtWr_EX <= idex.memWr;
			idex.ALUop_EX <= idex.ALUop;
			idex.ALU_Src_EX <= idex.ALU_Src;
			idex.EXTop_EX <= idex.EXTop;
			idex.halt_EX <= idex.halt;
			idex.PC_Src_EX <= idex.PC_Src;
			idex.RegDst_EX <= idex.RegDst;
			idex.RegWr_EX <= idex.RegWr;
			idex.Wsel_EX <= idex.Wsel;
			idex.busA_EX <= idex.busA;
			idex.busB_EX <= idex.busB;
			idex.imemaddr_EX <= idex.imemaddr;
			idex.instr_EX <= idex.instr;
		end
		else
		begin
			idex.idex.memtoReg_EX <= idex.memtoReg_EX;
			idex.memtWr_EX <= idex.idex.memWr_EX;
			idex.ALUop_EX <= idex.ALUop_EX;
			idex.ALU_Src_EX <= idex.ALU_Src_EX;
			idex.EXTop_EX <= idex.EXTop_EX;
			idex.halt_EX <= idex.halt_EX;
			idex.PC_Src_EX <= idex.PC_Src_EX;
			idex.RegDst_EX <= idex.RegDst_EX;
			idex.RegWr_EX <= idex.RegWr_EX;
			idex.Wsel_EX <= idex.Wsel_EX;
			idex.busA_EX <= idex.busA_EX;
			idex.busB_EX <= idex.busB_EX;
			idex.imemaddr_EX <= idex.imemaddr_EX;
			idex.instr_EX <= idex.instr_EX;
		end
end
endmodule	
			
