`include "cpu_types_pkg.vh"

module branch_predictor(
  input logic zero,
  input logic [31:0] instr,
  output logic pc_enable, flush_ID, flush_EX, flush_MEM, bp_choose
);
  import cpu_types_pkg::*;

opcode_t opcode;

assign opcode = opcode_t'(instr[31:26]);

always_comb begin
	flush_ID = 0;
  flush_EX = 0;
  flush_MEM = 0;
	pc_enable = 0;
	bp_choose = 0;
  if (opcode == BNE) begin
     if (zero == 0) begin //bne right
        flush_ID = 1;
        flush_EX = 1;
        flush_MEM = 1;
				pc_enable = 0;
				bp_choose = 1;
     end
  end

  else if (opcode == BEQ) begin
    if (zero == 1) begin //beq right
        flush_ID = 1;
        flush_EX = 1;
        flush_MEM = 1;
				pc_enable = 0;
				bp_choose = 1;
    end
	end
end
endmodule
