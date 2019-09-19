`include "memory_wb_if.vh"
`include "cpu_types_pkg.vh"

module memory_wb(
  input logic CLK, nRST,
  memory_wb_if.mw mwif
);

  import cpu_types_pkg::*;

  always_ff @ (posedge CLK, negedge nRST) begin
        if (nRST == 0) begin
            mwif.MemtoReg_WB <= '0;
            mwif.Output_Port_WB <= '0;
            mwif.RegWr_WB <= '0;
            mwif.RegDst_WB <= '0;
            mwif.imemaddr_WB <= '0;
            mwif.opcode_WB <= '0;
            mwif.funct_WB <= '0;
            mwif.imm16_WB <= '0;
            mwif.instr_WB <= '0;
        end
        else if (mwif.enable) begin
            mwif.MemtoReg_WB <= mwif.MemtoReg_MEM;
            mwif.Output_Port_WB <= mwif.Output_Port_MEM;
            mwif.RegWr_WB <= mwif.RegWr_MEM;
            mwif.RegDst_WB <= mwif.RegDst_MEM;
            mwif.imemaddr_WB <= mwif.imemaddr_MEM;
            mwif.opcode_WB <= mwif.opcode_MEM;
            mwif.funct_WB <= mwif.funct_MEM;
            mwif.imm16_WB <= mwif.imm16_MEM;
            mwif.instr_WB <= mwif.instr_MEM;
        end
        else if (mwif.flush) begin
            mwif.MemtoReg_WB <= '0;
            mwif.Output_Port_WB <= '0;
            mwif.RegWr_WB <= '0;
            mwif.RegDst_WB <= '0;
            mwif.imemaddr_WB <= '0;
            mwif.opcode_WB <= '0;
            mwif.funct_WB <= '0;
            mwif.imm16_WB <= '0;
            mwif.instr_WB <= '0;
        end
        else begin
            mwif.MemtoReg_WB <= mwif.MemtoReg_WB;
            mwif.Output_Port_WB <= mwif.Output_Port_WB;
            mwif.RegWr_WB <= mwif.RegWr_WB;
            mwif.RegDst_WB <= mwif.RegDst_WB;
            mwif.imemaddr_WB <= mwif.imemaddr_WB;
            mwif.opcode_WB <= mwif.opcode_WB;
            mwif.funct_WB <= mwif.funct_WB;
            mwif.imm16_WB <= mwif.imm16_WB;
            mwif.instr_WB <= mwif.instr_WB;
        end
endmodule
