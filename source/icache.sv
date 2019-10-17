`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
module icache
(
	input logic CLK, nRST,
	datapath_cache_if.icache dcif,
	caches_if.icache cif
);

icachef_t addr;

icache_frame n_frames [15:0];

icache_frame frames [15:0];



assign addr = dcif.imemaddr;


typedef enum logic {LOOKUP, MISS} states;
states n_state, state;
always_ff @(posedge CLK, negedge nRST)
begin
		if(!nRST)
		begin
			state <= LOOKUP;
			frames[0] <= '0;
			frames[1] <= '0;
			frames[2] <= '0;
			frames[3] <= '0;
			frames[4] <= '0;
			frames[5] <= '0;
			frames[6] <= '0;
			frames[7] <= '0;
			frames[8] <= '0;
			frames[9] <= '0;
			frames[10] <= '0;
			frames[11] <= '0;
			frames[12] <= '0;
			frames[13] <= '0;
			frames[14] <= '0;
			frames[15] <= '0;
		end
		else
		begin
			state <= n_state;
			frames[0] <= n_frames[0];
			frames[1] <= n_frames[1];
			frames[2] <= n_frames[2];
			frames[3] <= n_frames[3];
			frames[4] <= n_frames[4];
			frames[5] <= n_frames[5];
			frames[6] <= n_frames[6];
			frames[7] <= n_frames[7];
			frames[8] <= n_frames[8];
			frames[9] <= n_frames[9];
			frames[10] <= n_frames[10];
			frames[11] <= n_frames[11];
			frames[12] <= n_frames[12];
			frames[13] <= n_frames[13];
			frames[14] <= n_frames[14];
			frames[15] <= n_frames[15];
		end
end

always_comb
begin
	cif.iREN = dcif.imemREN;
	cif.iaddr = dcif.imemaddr;
	n_state = state;
	n_frames = frames;
	case(state)
		LOOKUP:
		begin
			if(addr.tag == frames[addr.idx].tag && frames[addr.idx].valid)
			begin
				dcif.ihit = 1'b1;
				dcif.imemload = frames[addr.idx].data;
				n_state = LOOKUP;
			end
			else
			begin
				n_state = MISS;
			end
		end
		MISS:
		begin

			if(dcif.iwait)
				n_state = MISS;
			else
				n_frames[addr.idx].valid = 1'b1;
				n_frames[addr.idx].data = cif.iload;
				n_state = LOOKUP;
		end
	endcase
end

endmodule

