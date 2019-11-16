`include "decode_execute_if.vh"
`include "cpu_types_pkg.vh"

module decode_execute(

	input CLK, nRST,
	decode_execute_if.idex deif
);
  import cpu_types_pkg::*;

always_ff @(posedge CLK, negedge nRST)
begin
		if(!nRST)
		begin
			deif.memtoReg_EX <= 1'b0;
			deif.memWr_EX <= 1'b0;
			deif.ALUop_EX <= ALU_OR;
			deif.ALU_Src_EX <= 1'b0;
			deif.EXTop_EX <= 2'b0;
			deif.halt_EX <= 1'b0;
			deif.PC_Src_EX <= 2'b0;
			deif.RegDst_EX <= 2'b0;
			deif.RegWr_EX <= 1'b0;
			deif.Wsel_EX <= 2'b0;
			deif.busA_EX <= '0;
			deif.busB_EX <= '0;
			deif.rs_EX <= '0;
			deif.rt_EX <= '0;
			deif.opcode_EX <= ORI;
			deif.funct_EX <= OR;
			deif.imm16_EX <= '0;
			deif.shamt_EX <= '0;
			deif.next_addr_EX <= '0;
			deif.imemaddr_EX <= '0;
			deif.instr_EX <= '0;
			deif.final_wsel_EX <= '0;
			deif.branch_addr_EX <= '0;
			deif.datomic_EX <= '0;
		end
		else if(deif.flush && deif.enable)
		begin
			deif.memtoReg_EX <= 1'b0;
			deif.memWr_EX <= 1'b0;
			deif.ALUop_EX <= ALU_OR;
			deif.ALU_Src_EX <= 1'b0;
			deif.EXTop_EX <= 2'b0;
			deif.halt_EX <= 1'b0;
			deif.PC_Src_EX <= 2'b0;
			deif.RegDst_EX <= 2'b0;
			deif.RegWr_EX <= 1'b0;
			deif.Wsel_EX <= 2'b0;
			deif.busA_EX <= '0;
			deif.busB_EX <= '0;
			deif.rs_EX <= '0;
			deif.rt_EX <= '0;
			deif.opcode_EX <= ORI;
			deif.funct_EX <= OR;
			deif.imm16_EX <= '0;
			deif.shamt_EX <= '0;
			deif.next_addr_EX <= '0;
			deif.imemaddr_EX <= '0;
			deif.instr_EX <= '0;
			deif.final_wsel_EX <= '0;
			deif.branch_addr_EX <= '0;
			deif.datomic_EX <= '0;
		end
		else if(deif.enable)
		begin
			deif.memtoReg_EX <= deif.memtoReg;
			deif.memWr_EX <= deif.memWr;
			deif.ALUop_EX <= deif.ALUop;
			deif.ALU_Src_EX <= deif.ALU_Src;
			deif.EXTop_EX <= deif.EXTop;
			deif.halt_EX <= deif.halt;
			deif.PC_Src_EX <= deif.PC_Src;
			deif.RegDst_EX <= deif.RegDst;
			deif.RegWr_EX <= deif.RegWr;
			deif.Wsel_EX <= deif.Wsel;
			deif.busA_EX <= deif.busA;
			deif.busB_EX <= deif.busB;
			deif.rs_EX <= deif.rs;
			deif.rt_EX <= deif.rt;
			deif.opcode_EX <= deif.opcode;
			deif.funct_EX <= deif.funct;
			deif.imm16_EX <= deif.imm16;
			deif.shamt_EX <= deif.shamt;
			deif.next_addr_EX <= deif.next_addr_ID;
			deif.imemaddr_EX <= deif.imemaddr_ID;
			deif.instr_EX <= deif.instr_ID;
			deif.final_wsel_EX <= deif.final_wsel;
			deif.branch_addr_EX <= deif.branch_addr;
			deif.datomic_EX <= deif.datomic;
		end
		else
		begin
			deif.memtoReg_EX <= deif.memtoReg_EX;
			deif.memWr_EX <= deif.memWr_EX;
			deif.ALUop_EX <= deif.ALUop_EX;
			deif.ALU_Src_EX <= deif.ALU_Src_EX;
			deif.EXTop_EX <= deif.EXTop_EX;
			deif.halt_EX <= deif.halt_EX;
			deif.PC_Src_EX <= deif.PC_Src_EX;
			deif.RegDst_EX <= deif.RegDst_EX;
			deif.RegWr_EX <= deif.RegWr_EX;
			deif.Wsel_EX <= deif.Wsel_EX;
			deif.busA_EX <= deif.busA_EX;
			deif.busB_EX <= deif.busB_EX;
			deif.rs_EX <= deif.rs_EX;
			deif.rt_EX <= deif.rt_EX;
			deif.opcode_EX <= deif.opcode_EX;
			deif.funct_EX <= deif.funct_EX;
			deif.imm16_EX <= deif.imm16_EX;
			deif.shamt_EX <= deif.shamt_EX;
			deif.next_addr_EX <= deif.next_addr_EX;
			deif.imemaddr_EX <= deif.imemaddr_EX;
			deif.instr_EX <= deif.instr_EX;
			deif.final_wsel_EX <= deif.final_wsel_EX;
			deif.branch_addr_EX <= deif.branch_addr_EX;
			deif.datomic_EX <= deif.datomic_EX;
		end
end
endmodule	
			
