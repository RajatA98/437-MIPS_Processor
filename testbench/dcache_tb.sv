`include "cpu_types_pkg.vh"
`include "caches_if.vh"
`include "cpu_ram_if.vh"
`include "cache_control_if.vh"
`timescale 1 ns / 1 ns

module dcache_tb;

	import cpu_types_pkg::*;
	parameter PERIOD = 10;

	logic CLK = 0, nRST;
	always #(PERIOD/2) CLK++;
	// coherence interface
  caches_if                 cif0();
  // cif1 will not be used, but ccif expects it as an input
  caches_if                 cif1();
  cache_control_if    #(.CPUS(1))       ccif (cif0, cif1);
	datapath_cache_if dcif();
	
	//caches_if cif();
	cpu_ram_if rif();

	assign ccif.ramstate = rif.ramstate;
	assign ccif.ramload = rif.ramload;
	assign rif.ramaddr = ccif.ramaddr;
	assign rif.ramstore = ccif.ramstore;
	assign rif.ramREN = ccif.ramREN;
	assign rif.ramWEN = ccif.ramWEN;
	assign cif0.iREN = 1'b1;
	assign cif0.iaddr = '0;
	test PROG (CLK, nRST, dcif, ccif);
	ram RAM(CLK, nRST, rif);

  memory_control MCU(CLK, nRST, ccif);

	dcache  DUT(CLK, nRST, dcif, cif0);

endmodule
program test(
	input logic CLK,
	output logic nRST,
	datapath_cache_if.dcache_tb dcif,
	//caches_if.dcache_tb cif,
	cache_control_if ccif
	
);
	task reset_dut;
	begin
		
		nRST = 1'b0;
		
		@(posedge CLK);
		@(posedge CLK);
		
		@(negedge CLK);
		
		nRST = 1;
		
		@(posedge CLK);
		@(posedge CLK);
	end
	endtask
	
	task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    
    cif0.daddr = 0;
    cif0.dWEN = 0;
    cif0.dREN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      cif0.daddr = i << 2;
      cif0.dREN = 1;
      repeat (4) @(posedge CLK);
      if (cif0.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif0.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif0.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      //cif0.tbCTRL = 0;
      cif0.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask
		

		int tb_test_num;
		string tb_test_case;
		parameter PERIOD = 10;

		initial
		begin
		
			nRST = 1'b1;
		tb_test_num = 0;
		tb_test_case ="Test bench initialization";
		#(0.1);

		dcif.halt = 1'b0;
		dcif.dmemREN = 1'b0;
		dcif.dmemWEN = 1'b0;
		dcif.dmemstore = '0;
		dcif.dmemaddr = '0;
		
		#(PERIOD)
		//******************************************************************
		// Test Case 1: Compulsory Misses
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Test Compulsory Misses";
		word_t i;
		i = 32'd0;
		//load the dcache
		dcif.dmemREN = 1'b1;
		dcif.dmemaddr = {26'd0,3'd0,1'b0,2'b0}; //addr 0   0
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd0,1'b1,2'b0}; //addr 4   1
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd0,1'b0,2'b0}; //addr 40  2 
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd0,1'b1,2'b0}; //addr 44  3
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd1,1'b0,2'b0}; //addr 8   4 
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd1,1'b1,2'b0}; //addr C   5 
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd1,1'b0,2'b0}; //addr 48  6
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd1,1'b1,2'b0}; //addr 4C  7
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd2,1'b0,2'b0}; //addr 10  8
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd2,1'b1,2'b0}; //addr 14  9
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd2,1'b0,2'b0}; //addr 50  A
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd2,1'b1,2'b0}; //addr 54  B
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd3,1'b0,2'b0}; //addr 18  C
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd3,1'b1,2'b0}; //addr 1C  D
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd3,1'b0,2'b0}; //addr 58  E
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd3,1'b1,2'b0}; //addr 5C  F
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd4,1'b0,2'b0}; //addr 20  10
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd4,1'b1,2'b0}; //addr 24  11
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd4,1'b0,2'b0}; //addr 60  12
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd4,1'b1,2'b0}; //addr 64  13
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd5,1'b0,2'b0};	//addr 28  14
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd5,1'b1,2'b0};	//addr 2C  15
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd5,1'b0,2'b0};	//addr 68  16
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd5,1'b1,2'b0}; //addr 6C  17
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd6,1'b0,2'b0}; //addr 30  18
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd6,1'b1,2'b0}; //addr 34  19
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd6,1'b0,2'b0};	//addr 70  1A
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd6,1'b1,2'b0};	//addr 74  1B
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd7,1'b0,2'b0}; //addr 38  1C
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd0,3'd7,1'b1,2'b0}; //addr 3C  1D
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd7,1'b0,2'b0}; //addr 78  1E
		@(negedge cif0.dwait);	
		if(i != cif0.dload)
		begin
			$display("Incorrect Output durring %s iteration %d",tb_test_case, i)
		end
		else
		begin
			$display("Correct Output durring %s iteration %d",tb_test_case, i)
		end
		@(posedge dcif.dhit);
		i = i + 1;
		dcif.dmemaddr = {26'd1,3'd7,1'b1,2'b0}; //addr 7C  1F
		

		dcif.dmemREN = 1'b0;
		
		#(PERIOD)

		//******************************************************************
		// Test Case 2: Associativity
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Test Associativity";

		dcif.dmemWEN = 1'b1;
		dcif.dmemstore = 32'd1;
		dcif.dmemaddr = {26'hA,3'd0,1'b0,2'b0};
		@(posedge dcif.dhit);
		dcif.dmemstore = 32'd2;
		dcif.dmemaddr = {26'hB,3'd0,1'b0,2'b0};
		@(posedge dcif.dhit);
		dcif.dmemstore = 32'd3;
		dcif.dmemaddr = {26'hC,3'd0,1'b0,2'b0};
		@(posedge dcif.dhit);
		
		dcif.dmemWEN = 1'b0;
		dcif.dmemREN = 1'b1;
		dcif.dmemaddr = {26'hC,3'd0,1'b0,2'b0};
		if(dcif.dhit && dcif.dmemload == 32'd3)
		begin
			$display("%s Passed!", tb_test_case);
		end
		else
		begin
			$display("%s Failed!", tb_test_case);
		end
		dcif.dmemaddr = {26'hB,3'd0,1'b0,2'b0};
		if(dcif.dhit && dcif.dmemload == 32'd2)
		begin
			$display("%s Passed!", tb_test_case);
		end
		else
		begin
			$display("%s Failed!", tb_test_case );
		end
		#(PERIOD)
		dcif.dmemREN = 1'b0;
		
	
		

	
		//******************************************************************
		// Test Case 4: Read and Write to same tag different blocks
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Read and Write to same tag different blocks";
		
		dcif.dmemWEN = 1'b1;
		dcif.dmemstore = 32'd1;
		dcif.dmemaddr = {26'd0,3'd0,1'b0,2'b0};
		@(posedge dcif.dhit);
		dcif.dmemstore = 32'd2;
		dcif.dmemaddr = {26'd0,3'd0,1'b0,2'b0};
		@(posedge dcif.dhit);
		dcif.dmemstore = 32'd3;
		dcif.dmemaddr = {26'd0,3'd0,1'b1,2'b0};
		@(posedge dcif.dhit);
		dcif.dmemstore = 32'd4;
		dcif.dmemaddr = {26'd0,3'd0,1'b1,2'b0};
		@(posedge dcif.dhit);
		dcif.dmemWEN = 1'b0;
		dcif.dmemREN = 1'b1;
		dcif.dmemaddr = {26'd0,3'd0,1'b0,2'b0};
		if(dcif.dhit && dcif.dmemload == 32'd1)
		begin
			$display("%s Passed!", tb_test_case);
		end
		else
		begin
			$display("%s Failed!", tb_test_case);
		end
		dcif.dmemaddr = {26'd0,3'd0,1'b0,2'b0};
		if(dcif.dhit && dcif.dmemload == 32'd2)
		begin
			$display("%s Passed!", tb_test_case);
		end
		else
		begin
			$display("%s Failed!", tb_test_case);
		end
		dcif.dmemaddr = {26'd0,3'd0,1'b1,2'b0};
		if(dcif.dhit && dcif.dmemload == 32'd3)
		begin
			$display("%s Passed!", tb_test_case);
		end
		else
		begin
			$display("%s Failed!", tb_test_case);
		end
		dcif.dmemaddr = {26'd0,3'd0,1'b1,2'b0};
		if(dcif.dhit && dcif.dmemload == 32'd4)
		begin
			$display("%s Passed!", tb_test_case);
		end
		else
		begin
			$display("%s Failed!", tb_test_case);
		end
		dcif.dmemREN = 1'b0;
		#(PERIOD)

		//******************************************************************
		// Test Case 5: Capacity Misses
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Test Capacity Misses";
		dcif.dmemWEN = 1'b1;
		dcif.dmemstore = 32'd1;
		dcif.dmemaddr = {26'd10,3'd0,1'b0,2'b0};
		@(negedge cif0.dwait);	
		if(32'd1 == cif0.dstore && cif0.dWEN)
		begin
			$display("Correct Output durring %s",tb_test_case)
		end
		else
		begin
			$display("Incorrect Output durring %s",tb_test_case)
		end
	
		#(PERIOD)
		//******************************************************************
		// Test Case 6: Conflict Misses
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Test Conflict Misses";
		dcif.dmemWEN = 1'b1;
		dcif.dmemstore = 32'd2;
		dcif.dmemaddr = {26'd11,3'd1,1'b0,2'b0};
		@(negedge cif0.dwait);	
		if(32'd1 == cif0.dstore && cif0.dWEN)
		begin
			$display("Correct Output durring %s",tb_test_case)
		end
		else
		begin
			$display("Incorrect Output durring %s",tb_test_case)
		end
		#(PERIOD)
		//******************************************************************
		// Test Case 7: Writeback specification
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Test Writeback Specification";
		dcif.dmemWEN = 1'b1;
		dcif.dmemstore = 32'd1;
		dcif.dmemaddr = {26'd12,3'd0,1'b0,2'b0};
		@(negedge cif0.dwait);	
		if(32'd1 == cif0.dstore && cif0.dWEN)
		begin
			$display("Correct Output durring %s",tb_test_case)
		end
		else
		begin
			$display("Incorrect Output durring %s",tb_test_case)
		end
		dcif.dmemstore = 32'd2;
		dcif.dmemaddr = {26'd12,3'd0,1'b0,2'b0};
		@(negedge cif0.dwait);	
		if(32'd2 == cif0.dstore && cif0.dWEN)
		begin
			$display("Correct Output durring %s",tb_test_case)
		end
		else
		begin
			$display("Incorrect Output durring %s",tb_test_case)
		end
		dcif.dmemstore = 32'd3;
		dcif.dmemaddr = {26'd12,3'd0,1'b0,2'b0};
		if(dcif.dhit)
		begin
			$display("Correct Output durring %s",tb_test_case)
		end
		else
		begin
			$display("Incorrect Output durring %s",tb_test_case)
		end
		dcif.dmemWEN = 1'b0;
		#(PERIOD)

		
		//******************************************************************
		// Test Case 8: Toggles
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Test Writeback Specification";
		
		dcif.dmemstore = 32'hffffffff;
		dcif.dmemaddr = 32'hffffffff;
		@(posedge dcif.dhit);
		dcif.dmemaddr = {26'b11111111111111111111111111,3'b111,1'b0,2'b11};
		@(posedge dcif.dhit);
		dcif.dmemstore = 32'h0;
		dcif.dmemaddr = 32'h0;
		@(posedge dcif.dhit);
		dcif.dmemaddr = {26'b11111111111111111111111111,3'b111,1'b0,2'b11};

	//******************************************************************
		// Test Case 3: Flushing
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Test Flushing";
		reset_dut();
		dcif.dmemWEN = 1'b1;
		dcif.dmemstore = 32'd1;
		dcif.dmemaddr = {26'd0,3'd0,1'b0,2'b0};
		dcif.dmemstore = 32'd2;
		dcif.dmemaddr = {26'd0,3'd0,1'b0,2'b0};
		dcif.dmemstore = 32'd3;
		dcif.dmemaddr = {26'd0,3'd0,1'b0,2'b0};
		dcif.dmemstore = 32'd4;
		dcif.dmemaddr = {26'd0,3'd0,1'b0,2'b0};
		repeat (4) @(posedge dcif.dhit);
		dcif.dmemWEN = 1'b0;
		dcif.halt = 1'b1;
		@(negedge cif0.dwait);
		if(cif0.dstore != 32'd3)
		begin
			 $display("%s Failed!", tb_test_case);
		end
		@(negedge cif0.dwait);
		if(cif0.dstore != 32'd4)
		begin
			 $display("%s Failed!", tb_test_case);
		end
		@(posedge dcif.flushed)
			
		$display("%s Passed!", tb_test_case);

		dcif.halt = 1'b0;

endprogram

