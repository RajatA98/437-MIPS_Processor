`include "memory_wb_if.vh"
`include "cpu_types_pkg.vh"

module memory_wb(
  input logic CLK, nRST,
  memory_wb_if.mw mwif
);

  import cpu_types_pkg::*;

  always_ff @ (posedge CLK, negedge nRST) begin
        if (nRST == 0 || mwif.flush) begin
            mwif.RegWr_WB <= 1'b0;
						mwif.RegDst_WB <= 2'b0;
						mwif.memtoReg_WB <= 1'b0;
						mwif.memWr_WB <= 1'b0;
						//mwif.PC_Src_WB <= 2'b0;
						mwif.Wsel_WB <= 2'b0;
						//mwif.busA_WB <= '0;
						mwif.busB_WB <= '0;
						mwif.next_addr_WB <= '0;
						mwif.imemaddr_WB <= '0;
						mwif.jump_addr_WB <= '0;
						mwif.branch_addr_WB <= '0;
						mwif.extended_WB <= '0;
						mwif.rs_WB <= '0;
						mwif.rt_WB <= '0;
						mwif.opcode_WB <= ORI;
						mwif.funct_WB <= OR;
						mwif.imm16_WB <= '0;
						mwif.shamt_WB <= '0;
						//mwif.zero_WB <= 1'b0;
						mwif.Output_Port_WB <= '0;
						mwif.halt_WB <= '0;
						mwif.instr_WB <= '0;
						mwif.dload_WB <= '0;
        end
				else if (mwif.flush && mwif.enable) begin
            mwif.RegWr_WB <= 1'b0;
						mwif.RegDst_WB <= 2'b0;
						mwif.memtoReg_WB <= 1'b0;
						mwif.memWr_WB <= 1'b0;
						//mwif.PC_Src_WB <= 2'b0;
						mwif.Wsel_WB <= 2'b0;
						//mwif.busA_WB <= '0;
						mwif.busB_WB <= '0;
						mwif.next_addr_WB <= '0;
						mwif.imemaddr_WB <= '0;
						mwif.jump_addr_WB <= '0;
						mwif.branch_addr_WB <= '0;
						mwif.extended_WB <= '0;
						mwif.rs_WB <= '0;
						mwif.rt_WB <= '0;
						mwif.opcode_WB <= ORI;
						mwif.funct_WB <= OR;
						mwif.imm16_WB <= '0;
						mwif.shamt_WB <= '0;
						//mwif.zero_WB <= 1'b0;
						mwif.Output_Port_WB <= '0;
						mwif.halt_WB <= '0;
						mwif.instr_WB <= '0;
        end
        else if (mwif.enable) begin
            mwif.RegWr_WB <= mwif.RegWr_MEM;
						mwif.RegDst_WB <= mwif.RegDst_MEM;
						mwif.memtoReg_WB <= mwif.memtoReg_MEM;
						mwif.memWr_WB <= mwif.memWr_MEM;
						//mwif.PC_Src_WB <= mwif.PC_Src_MEM;
						mwif.Wsel_WB <= mwif.Wsel_MEM;
						//mwif.busA_WB <= mwif.busA_MEM;
						mwif.busB_WB <= mwif.busB_MEM;
						mwif.next_addr_WB <= mwif.next_addr_MEM;
						mwif.imemaddr_WB <= mwif.imemaddr_MEM;
						mwif.jump_addr_WB <= mwif.jump_addr_MEM;
						mwif.branch_addr_WB <= mwif.branch_addr_MEM;
						mwif.extended_WB <= mwif.extended_MEM;
						mwif.rs_WB <= mwif.rs_MEM;
						mwif.rt_WB <= mwif.rt_MEM;
						mwif.opcode_WB <= mwif.opcode_MEM;
						mwif.funct_WB <= mwif.funct_MEM;
						mwif.imm16_WB <= mwif.imm16_MEM;
						mwif.shamt_WB <= mwif.shamt_MEM;
						//mwif.zero_WB <= mwif.zero_MEM;
						mwif.Output_Port_WB <= mwif.Output_Port_MEM;
						mwif.halt_WB <= mwif.halt_MEM;
						mwif.instr_WB <= mwif.instr_MEM;
						mwif.dload_WB <= mwif.dload;
        end
        
        else begin
            mwif.RegWr_WB <= mwif.RegWr_WB;
						mwif.RegDst_WB <= mwif.RegDst_WB;
						mwif.memtoReg_WB <= mwif.memtoReg_WB;
						mwif.memWr_WB <= mwif.memWr_WB;
						//mwif.PC_Src_WB <= mwif.PC_Src_WB;
						mwif.Wsel_WB <= mwif.Wsel_WB;
						//mwif.busA_WB <= mwif.busA_WB;
						mwif.busB_WB <= mwif.busB_WB;
						mwif.next_addr_WB <= mwif.next_addr_WB;
						mwif.imemaddr_WB <= mwif.imemaddr_WB;
						mwif.jump_addr_WB <= mwif.jump_addr_WB;
						mwif.branch_addr_WB <= mwif.branch_addr_WB;
						mwif.extended_WB <= mwif.extended_WB;
						mwif.rs_WB <= mwif.rs_WB;
						mwif.rt_WB <= mwif.rt_WB;
						mwif.opcode_WB <= mwif.opcode_WB;
						mwif.funct_WB <= mwif.funct_WB;
						mwif.imm16_WB <= mwif.imm16_WB;
						mwif.shamt_WB <= mwif.shamt_WB;
						//mwif.zero_WB <= mwif.zero_WB;
						mwif.Output_Port_WB <= mwif.Output_Port_WB;
						mwif.halt_WB <= mwif.halt_WB;
						mwif.instr_WB <= mwif.instr_WB;
						mwif.dload_WB <= mwif.dload_WB;
        end
end
endmodule
