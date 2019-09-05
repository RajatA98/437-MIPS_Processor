/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

	
	always_comb
	begin
	//output to cache
	//instructions
	ccif.iload = '0;
	ccif.iwait = 1'b1;
	//data
	ccif.dload = '0;
	ccif.dwait = 1'b1;
	//output to RAM
	ccif.ramaddr = '0;
	ccif.ramREN = '0;
	ccif.ramWEN = '0;
	ccif.ramstore = '0;
	
	if(ccif.dWEN == 1'b1)
	begin
		ccif.ramWEN = ccif.dWEN;
		ccif.ramaddr = ccif.daddr;
		ccif.ramstore = ccif.dstore;
		if(ccif.ramstate == ACCESS)
		begin
			ccif.dwait = 1'b0;
		end
	end
	
	else if(ccif.dREN == 1'b1)
	begin
		ccif.ramREN = ccif.dREN;
		ccif.ramaddr = ccif.daddr;
		ccif.dload = ccif.ramload;
		if(ccif.ramstate == ACCESS)
		begin
			
			ccif.dwait = 1'b0;
		end
	end
	else if (ccif.iREN == 1'b1)
	begin
		ccif.ramREN = ccif.iREN;
		ccif.ramaddr = ccif.iaddr;
		ccif.iload = ccif.ramload;
		if(ccif.ramstate == ACCESS)
		begin
			
			ccif.iwait = 1'b0;
		end
	end

	end	
	
	

	
	
	

endmodule
