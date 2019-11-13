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
  cache_control_if    #(.CPUS(2))       ccif (cif0, cif1);
	datapath_cache_if dcif0();
	datapath_cache_if dcif1();

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
	test PROG (CLK, nRST, dcif0, dcif1, ccif);
	ram RAM(CLK, nRST, rif);

  memory_control MCU(CLK, nRST, ccif);

	dcache DC0(CLK, nRST, dcif0, cif0);
	dcache DC1(CLK, nRST, dcif1, cif1);

endmodule
program test(
	input logic CLK,
	output logic nRST,
	datapath_cache_if.dcache_tb dcif0, dcif1,
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
    logic [31:0] i;
		parameter PERIOD = 10;


		initial
		begin

		tb_test_num = 0;
		tb_test_case ="Test bench initialization";
    reset_dut();
		#(0.1);

		dcif0.halt = 1'b0;
		dcif0.dmemREN = 1'b0;
		dcif0.dmemWEN = 1'b0;
		dcif0.dmemstore = '0;
		dcif0.dmemaddr = '0;
		dcif1.halt = 1'b0;
		dcif1.dmemREN = 1'b0;
		dcif1.dmemWEN = 1'b0;
		dcif1.dmemstore = '0;
		dcif1.dmemaddr = '0;

		#(PERIOD);

		
		//******************************************************************
		// Test Case 1: I->M M->I
		//******************************************************************

    tb_test_num = tb_test_num + 1;
		tb_test_case ="I->M M->I";
		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF00;
		dcif0.dmemaddr =  32'h80;
		@(posedge cif1.ccwait)
		if(cif1.cctrans)
			$display("Correct Output during %s", tb_test_case);
		else
			$display("Incorrect Output during %s",tb_test_case);
		#(PERIOD);
		dcif0.halt = 1'b1;
		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF4;
		dcif1.dmemaddr = 32'h80;
		@(posedge cif0.ccwait)
		if(cif0.cctrans)
			$display("Correct Output during %s", tb_test_case);
		else
			$display("Incorrect Output during %s",tb_test_case);
		#(PERIOD);
		dcif1.halt = 1'b1;
		#(PERIOD);
		dcif0.halt = 1'b0;
		dcif0.dmemREN = 1'b0;
		dcif0.dmemWEN = 1'b0;
		dcif0.dmemstore = '0;
		dcif0.dmemaddr = '0;
		dcif1.halt = 1'b0;
		dcif1.dmemREN = 1'b0;
		dcif1.dmemWEN = 1'b0;
		dcif1.dmemstore = '0;
		dcif1.dmemaddr = '0;
		reset_dut();
		//******************************************************************
		// Test Case 2: S->M M->S
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case ="S->M M->S";
		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF00;
		dcif0.dmemaddr =  32'h80;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
	  dcif0.dmemstore = 32'h40;
		dcif0.dmemaddr =  32'h80;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;
		dcif0.halt = 1'b1;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemREN = 1'b1;	
		dcif1.dmemaddr =  32'h80;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		if (dcif1.dmemload == 32'h40)
		$display("Correct Output during %s", tb_test_case);
		else
			$display("Incorrect Output during %s",tb_test_case);
		#(PERIOD);
		dcif1.halt = 1'b1;
		#(PERIOD);
		dcif0.halt = 1'b0;
		dcif0.dmemREN = 1'b0;
		dcif0.dmemWEN = 1'b0;
		dcif0.dmemstore = '0;
		dcif0.dmemaddr = '0;
		dcif1.halt = 1'b0;
		dcif1.dmemREN = 1'b0;
		dcif1.dmemWEN = 1'b0;
		dcif1.dmemstore = '0;
		dcif1.dmemaddr = '0;
		reset_dut();
		//******************************************************************
		// Test Case 2: S->M S->I
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case ="S->M S->I";
		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr =  32'h80;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;
		dcif1.halt = 1'b1;
		dcif0.dmemREN = 1'b1;
		dcif0.dmemaddr =  32'h80;
		@(posedge dcif0.dhit)
		if (dcif0.dmemload == 32'hF0)
		$display("Correct Output during %s", tb_test_case);
		else
			$display("Incorrect Output during %s",tb_test_case);
		dcif0.halt = 1'b1;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		reset_dut();
		//******************************************************************
		// Test Case Toggle 
		//******************************************************************
		dcif0.halt = 1'b0;
		dcif0.dmemREN = 1'b0;
		dcif0.dmemWEN = 1'b0;
		dcif0.dmemstore = '0;
		dcif0.dmemaddr = '0;
		dcif1.halt = 1'b0;
		dcif1.dmemREN = 1'b0;
		dcif1.dmemWEN = 1'b0;
		dcif1.dmemstore = '0;
		dcif1.dmemaddr = '0;
		reset_dut();
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Toggle Coverage";
		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr =  {26'h6,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr =  {26'h7,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr =  {26'h8,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF0;
		dcif0.dmemaddr = {26'h6,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF5;
		dcif0.dmemaddr =  {26'h7,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif0.dmemWEN = 1'b0;

		#(PERIOD);
		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF0;
		dcif0.dmemaddr =  {26'h8,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;

		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr =  {26'h6,6'b001000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr =  {26'h7,6'b001000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr =  {26'h8,6'b001000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif1.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr =  {26'h9,6'b001000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);


		//@(posedge dcif0.dhit)
		dcif0.halt = 1'b1;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.halt = 1'b1;
	reset_dut();
		//******************************************************************
		// Test Case Toggle 
		//******************************************************************
		dcif0.halt = 1'b0;
		dcif0.dmemREN = 1'b0;
		dcif0.dmemWEN = 1'b0;
		dcif0.dmemstore = '0;
		dcif0.dmemaddr = '0;
		dcif1.halt = 1'b0;
		dcif1.dmemREN = 1'b0;
		dcif1.dmemWEN = 1'b0;
		dcif1.dmemstore = '0;
		dcif1.dmemaddr = '0;
		reset_dut();
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Toggle Coverage";
		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr =  {26'h6,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr =  {26'h7,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr =  {26'h8,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr =  {26'h9,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		


		//@(posedge dcif0.dhit)
		dcif0.halt = 1'b1;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.halt = 1'b1;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);








		//******************************************************************
		// Test Case 
		//******************************************************************
		dcif0.halt = 1'b0;
		dcif0.dmemREN = 1'b0;
		dcif0.dmemWEN = 1'b0;
		dcif0.dmemstore = '0;
		dcif0.dmemaddr = '0;
		dcif1.halt = 1'b0;
		dcif1.dmemREN = 1'b0;
		dcif1.dmemWEN = 1'b0;
		dcif1.dmemstore = '0;
		dcif1.dmemaddr = '0;
		reset_dut();
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Toggle Coverage cache 0";
		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF0;
		dcif0.dmemaddr =  {26'h6,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF0;
		dcif0.dmemaddr =  {26'h7,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF0;
		dcif0.dmemaddr =  {26'h8,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr = {26'h6,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF5;
		dcif1.dmemaddr =  {26'h7,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif1.dmemWEN = 1'b0;

		#(PERIOD);
		dcif1.dmemWEN = 1'b1;
		dcif1.dmemstore = 32'hF0;
		dcif1.dmemaddr =  {26'h8,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif1.dmemWEN = 1'b0;

		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF0;
		dcif0.dmemaddr =  {26'h6,6'b001000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF0;
		dcif0.dmemaddr =  {26'h7,6'b001000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF0;
		dcif0.dmemaddr =  {26'h8,6'b001000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif0.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF0;
		dcif0.dmemaddr =  {26'h9,6'b001000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);


		//@(posedge dcif0.dhit)
		dcif1.halt = 1'b1;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.halt = 1'b1;
	reset_dut();
		//******************************************************************
		// Test Case Toggle 
		//******************************************************************
		dcif0.halt = 1'b0;
		dcif0.dmemREN = 1'b0;
		dcif0.dmemWEN = 1'b0;
		dcif0.dmemstore = '0;
		dcif0.dmemaddr = '0;
		dcif1.halt = 1'b0;
		dcif1.dmemREN = 1'b0;
		dcif1.dmemWEN = 1'b0;
		dcif1.dmemstore = '0;
		dcif1.dmemaddr = '0;
		reset_dut();
		tb_test_num = tb_test_num + 1;
		tb_test_case ="Toggle Coverage cache0";
		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF0;
		dcif0.dmemaddr =  {26'h6,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF0;
		dcif0.dmemaddr =  {26'h7,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF0;
		dcif0.dmemaddr =  {26'h8,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		dcif0.dmemWEN = 1'b1;
		dcif0.dmemstore = 32'hF0;
		dcif0.dmemaddr =  {26'h9,6'b000000};
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.dmemWEN = 1'b0;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);

		


		//@(posedge dcif0.dhit)
		dcif1.halt = 1'b1;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		dcif0.halt = 1'b1;
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);
		#(PERIOD);






  dump_memory();
  $finish;
  end
endprogram
