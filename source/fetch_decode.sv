`include "fetch_decode_if.vh"
`include "cpu_types_pkg.vh"

module fetch_decode(
    input logic CLK, nRST,
    fetch_decode_if.fd fdif
);

  import cpu_types_pkg::*;
	
	r_t rt;
	

	assign rt = fdif.instr_ID;



  always_ff @ (posedge CLK, negedge nRST) begin
      if (nRST == 0) begin
        fdif.imemaddr_ID <= '0;
        fdif.instr_ID <= '0;
				fdif.next_addr_ID <= '0;
      end
			/*else if ((rt.opcode == RTYPE && rt.funct == JR) && dhit)
			begin
				fdif.imemaddr_ID <= fdif.imemaddr_ID;
        fdif.instr_ID <= fdif.instr_ID;
				fdif.next_addr_ID <= fdif.next_addr_ID;
			end*/
			else if (fdif.flush && fdif.enable)
			begin
				fdif.imemaddr_ID <= '0;
        fdif.instr_ID <= '0;
				fdif.next_addr_ID <= '0;
			end
      else if (fdif.enable) begin
        fdif.imemaddr_ID <= fdif.imemaddr;
        fdif.instr_ID <= fdif.imemload;
				fdif.next_addr_ID <= fdif.next_addr;
      end
      else begin
        fdif.imemaddr_ID <= fdif.imemaddr_ID;
        fdif.instr_ID <= fdif.instr_ID;
				fdif.next_addr_ID <= fdif.next_addr_ID;
      end
  end


endmodule
