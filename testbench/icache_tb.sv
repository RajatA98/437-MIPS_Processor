`include "cpu_types_pkg.vh"
`include "caches_if.vh"
`include "cpu_ram_if.vh"
`include "cache_control_if.vh"
`timescale 1 ns / 1 ns

module icache_tb;


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
	test PROG (CLK, nRST, dcif, ccif);
	ram RAM(CLK, nRST, rif);

  memory_control MCU(CLK, nRST, ccif);

	icache  DUT(CLK, nRST, dcif, cif0);

endmodule

program test(
  input logic CLK,
	output logic nRST,
	datapath_cache_if.icache_tb dcif,
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


    cif0.iaddr = 0;
    cif0.iREN = 0;

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

      cif0.iaddr = i << 2;
      cif0.iREN = 1;
      repeat (4) @(posedge CLK);
      if (cif0.iload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif0.iload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif0.iload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      //cif0.tbCTRL = 0;
      cif0.iREN = 0;
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

		//******************************************************************
		// Test Case 1: Capacity Misses
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Test Capacity Misses";
		reset_dut();
    #(PERIOD);
    dcif.imemREN = 1;
		dcif.imemaddr = {26'd0,4'd0,2'b0}; //addr 0   0
		 @ (posedge dcif.ihit)
		#(PERIOD);
		dcif.imemaddr = {26'd0,4'd1,2'b0}; //addr 8   4
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd2,2'b0}; //addr 10  8
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd3,2'b0}; //addr 18  C
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd4,2'b0}; //addr 60  12
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd5,2'b0};	//addr 28  14
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd6,2'b0}; //addr 30  18
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd7,2'b0}; //addr 38  1C
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd8,2'b0};
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd9,2'b0};
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd10,2'b0};
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd11,2'b0};
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd12,2'b0};
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd13,2'b0};
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd14,2'b0};
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd15,2'b0};
    @ (posedge dcif.ihit)
		#(PERIOD);

    //everything is filled up
    #(PERIOD);

    dcif.imemREN = 1;
    dcif.imemaddr = {26'd1,4'd7,2'b0}; //addr 5C  
    #(PERIOD);
		if(cif0.iREN)
		begin
			$display("Correct Operation during %s",tb_test_case);
		end
		else
		begin
			$display("Incorrect Operation during %s",tb_test_case);
		end
    @(posedge dcif.ihit)
		if( 'hf == dcif.imemload)
		begin
			$display("Correct Output during %s",tb_test_case);
		end
		else
		begin
			$display("Incorrect Output during %s",tb_test_case);
		end
		#(PERIOD);
    dcif.imemREN = 0;

		//******************************************************************
		// Test Case 2: Conflict Misses
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Test Conflict Misses";


    dcif.imemREN = 1;
    dcif.imemaddr = {26'd1,4'd6,2'b0};	//addr 70  1A
    @(posedge dcif.ihit)
		if( 'he == dcif.imemload)
		begin
			$display("Correct Output during %s",tb_test_case);
		end
		else
		begin
			$display("Incorrect Output during %s",tb_test_case);
		end

		#(PERIOD)


		//******************************************************************
		// Test Case 3: Compulsory Misses
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Test Compulsory Misses";

    reset_dut();

    dcif.imemREN = 1'b1;
		dcif.imemaddr = {26'd0,4'd0,2'b0}; //addr 0   0

    @ (posedge dcif.ihit)
		#(PERIOD);
		dcif.imemaddr = {26'd0,4'd1,2'b0}; //addr 8   4
				if(4 == cif0.iload)
				begin
					$display("Incorrect Output during %s iteration 2",tb_test_case);
				end
				else
				begin
					$display("Correct Output during %s iteration 2",tb_test_case);
				end
    @ (posedge dcif.ihit)
		#(PERIOD)
    dcif.imemaddr = {26'd0,4'd2,2'b0}; //addr 10  8
				if(8 == cif0.iload)
				begin
					$display("Incorrect Output during %s iteration 3",tb_test_case);
				end
				else
				begin
					$display("Correct Output during %s iteration 3",tb_test_case);
				end
    @ (posedge dcif.ihit)
		#(PERIOD);
    dcif.imemaddr = {26'd0,4'd3,2'b0}; //addr 18  C
				if('hC == cif0.iload)
				begin
					$display("Incorrect Output during %s iteration 3",tb_test_case);
				end
				else
				begin
					$display("Correct Output during %s iteration 3",tb_test_case);
				end

    @ (posedge dcif.ihit)
		dcif.imemREN = 1'b0;
		#(PERIOD);


		//******************************************************************
		// Test Case 4: Toggle Coverage
		//******************************************************************
		/*tb_test_num = tb_test_num + 1;
		tb_test_case ="Icache Toggle Coverage";

		dcif.imemaddr = 32'hffffffff;
		@(posedge dcif.ihit);
		#(PERIOD);
		dcif.imemaddr = 32'hffffffff;
		@(posedge dcif.ihit);
		#(PERIOD);
		dcif.imemaddr = 32'h0;
		@(posedge dcif.ihit);
		dcif.imemaddr = 32'h0;
		#(PERIOD);*/

		

	$finish;
  end

endprogram





