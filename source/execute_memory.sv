`include "exdecute_memory_if.vh"

module execute_memory (
input CLK, nRST,dhit
execute_memory_if.exmem emif
);

always_ff @(posedge CLK, negedge nRST)
begin	
	if(!nRST || emif.flush || dhit)
	begin
		emif.RegWr_MEM <= 1'b0;
		emif.RegDst_MEM <= 2'b0;
		emif.memtoReg_MEM <= 1'b0;
		emif.memWr_MEM <= 1'b0;
		emif.PC_Src_MEM <= 2'b0;
		emif.Wsel_MEM <= 2'b0;
		emif.busA_MEM <= '0;
		emif.busB_MEM <= '0;
		emif.next_addr_MEM <= '0;
		emif.imemaddr_MEM <= '0;
		emif.jump_addr_MEM <= '0;
		emif.branch_addr_MEM <= '0;
		emif.extend_MEM <= '0;
		emif.rs_MEM <= '0;
		emif.rt_MEM <= '0;
		emif.opcode_MEM <= '0;
		emif.funct_MEM <= '0;
		emif.imm16_MEM <= '0;
		emif.shamt_MEM <= '0;
		emif.zero_MEM <= 1'b0;
		emif.Output_Port_MEM <= '0;
	end
	else if(emif.enable)
	begin
		emif.RegWr_MEM <= emif.RegWr_EX;
		emif.RegDst_MEM <= emif.RegDst_EX;
		emif.memtoReg_MEM <= emif.memtoReg_EX;
		emif.memWr_MEM <= emif.memWr_EX;
		emif.PC_Src_MEM <= emif.PC_Src_EX;
		emif.Wsel_MEM <= emif.Wsel_EX;
		emif.busA_MEM <= emif.busA_EX;
		emif.busB_MEM <= emif.busB_EX;
		emif.next_addr_MEM <= emif.next_addr_EX;
		emif.imemaddr_MEM <= emif.imemaddr_EX;
		emif.jump_addr_MEM <= emif.jump_addr;
		emif.branch_addr_MEM <= emif.branch_addr;
		emif.extend_MEM <= emif.extended;
		emif.rs_MEM <= emif.rs_EX;
		emif.rt_MEM <= emif.rt_EX;
		emif.opcode_MEM <= emif.opcode_EX;
		emif.funct_MEM <= emif.funct_EX;
		emif.imm16_MEM <= emif.imm16_EX;
		emif.shamt_MEM <= emif.shamt_EX;
		emif.zero_MEM <= emif.zero;
		emif.Output_Port_MEM <= emif.Output_Port;
	end
	else
	begin
		emif.RegWr_MEM <= emif.RegWr_MEM;
		emif.RegDst_MEM <= emif.RegDst_MEM;
		emif.memtoReg_MEM <= emif.memtoReg_MEM;
		emif.memWr_MEM <= emif.memtoReg_MEM;
		emif.PC_Src_MEM <= emif.PC_Src_MEM;
		emif.Wsel_MEM <= emif.Wsel_MEM;
		emif.busA_MEM <= emif.busA_MEM;
		emif.busB_MEM <= emif.busB_MEM;
		emif.next_addr_MEM <= emif.next_addr_MEM;
		emif.imemaddr_MEM <= emif.imemaddr_MEM;
		emif.jump_addr_MEM <= emif.jump_addr_MEM;
		emif.branch_addr_MEM <= emif.branch_addr_MEM;
		emif.extend_MEM <= emif.extended_MEM;
		emif.rs_MEM <= emif.rt_MEM;
		emif.rt_MEM <= emif.rt_MEM;
		emif.opcode_MEM <= emif.opcode_MEM;
		emif.funct_MEM <= emif.funct_MEM;
		emif.imm16_MEM <= emif.imm16_MEM;
		emif.shamt_MEM <= emif.shamt_MEM;
		emif.zero_MEM <= emif.zero_MEM;
		emif.Output_Port_MEM <= emif.Output_Port_MEM;
	end
end
endmodule
		

