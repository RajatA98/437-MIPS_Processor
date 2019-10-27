/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/


// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

module caches (
  input logic CLK, nRST,
  datapath_cache_if dcif,
  caches_if cif
);

  import cpu_types_pkg::*;
  word_t instr;
  word_t daddr;

	/*word_t MMIO;

	assign MMIO = 'hF00;

	assign dcif2.halt = dcif.halt;
	assign dcif2.dmemREN = (dcif.dmemaddr == MMIO)? 1'b0 : dcif.dmemREN; 
	assign dcif2.dmemWEN = (dcif.dmemaddr == MMIO)? 1'b0 : dcif.dmemWEN; 
	assign dcif2.datomic = dcif.datomic;
	assign dcif2.dmemstore = dcif.dmemstore;
	assign dcif2.dmemaddr = dcif.dmemaddr;
	
	assign dcif.dhit = ((dcif2.dmemaddr == MMIO) && (dcif.dmemREN || dcif.dmemWEN))? 1'b1 : dcif2.dhit;
	assign dcif.dmemload =  ((dcif2.dmemaddr == MMIO) && (dcif.dmemREN))? SW[17:0] : dcif2.dmemload; 
	assign dcif.flushed = dcif2.flushed;

	always_ff @(posedge CLK, negedge nRST)
	begin
		if(!nRST)
		begin
			LEDR <= '0;
		end
		else
		begin
			if ((dcif2.dmemaddr == MMIO) && dcif.dmemWEN)
			begin
				LEDR <= dcif2.dmemstore[17:0];

			end
			else
			begin
				LEDR <= LEDR;
			end
		end
	end*/
	

  // icache
  icache  ICACHE(CLK, nRST, dcif, cif);
  // dcache
  dcache  DCACHE(CLK, nRST, dcif, cif);

  // single cycle instr saver (for memory ops)
  /*always_ff @(posedge CLK)
  begin
    if (!nRST)
    begin
      instr <= '0;
      daddr <= '0;
    end
    else
    if (dcif.ihit)
    begin
      instr <= cif.iload;
      daddr <= dcif.dmemaddr;
    end
  end*/


  // dcache invalidate before halt
  //assign dcif.flushed = dcif.halt;

  //singlecycle
/*
  assign dcif.ihit = (dcif.imemREN) ? ~cif.iwait : 0;
  assign dcif.dhit = (dcif.dmemREN|dcif.dmemWEN) ? ~cif.dwait : 0;
  assign dcif.imemload = cif.iload;
  assign dcif.dmemload = cif.dload;


  assign cif.iREN = dcif.imemREN;
  assign cif.dREN = dcif.dmemREN;
  assign cif.dWEN = dcif.dmemWEN;
  assign cif.dstore = dcif.dmemstore;
  assign cif.iaddr = dcif.imemaddr;
  assign cif.daddr = dcif.dmemaddr;*/

endmodule
