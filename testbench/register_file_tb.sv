/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;
	
  
	

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG (CLK, nRST, rfif);
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif
	
	

		

endmodule

program test(
	input logic CLK,
	output logic nRST,
	register_file_if.tb rfif
);
		int tb_test_num;
		string tb_test_case;
		parameter PERIOD = 10;

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
		initial 
	  begin
	
		nRST = 1'b1;
		tb_test_num = 0;
		tb_test_case ="Test bench initialization";

		#(0.1);
		rfif.WEN = 0;
		rfif.wsel = 0;
		rfif.rsel1 = 0;
		rfif.rsel2 = 0;
		rfif.wdat = 0;
		//******************************************************************
		// Test Case 1: Power on Reset
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Power on Reset";
		
		reset_dut();
		#(PERIOD/2);
		rfif.rsel1 = 5'b0;
		rfif.rsel2 = 5'b0;
		
		
	
		 #(PERIOD * 5);
		
		//*******************************************************************
		// Test Case 2: writing to register 0
		//*******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "writing to register 0";
		
		reset_dut();
		rfif.WEN = 1'b1;
		rfif.wsel = 5'b0;
		rfif.wdat = 32'hf;
		rfif.rsel1 = 5'b0;
		rfif.rsel2 = 5'b0;
		#(PERIOD/2);
		
		
		#(PERIOD * 5);

		//*******************************************************************
		// Test Case 3: Reading just rdat1
		//*******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "reading using rsel1";
		
		reset_dut();
		rfif.WEN = 1'b1;
		rfif.wsel = 5'd20;
		rfif.wdat = 32'hf;
		rfif.rsel1 = 5'd20;
		rfif.rsel2 = 5'b0;
		#(PERIOD/2);
		
		
		//*******************************************************************
		// Test Case 4: Reading just rdat2
		//*******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "reading using rsel2";
		
		reset_dut();
		rfif.WEN = 1'b1;
		rfif.wsel = 5'd20;
		rfif.wdat = 32'hfffffff;
		rfif.rsel1 = 5'd0;
		rfif.rsel2 = 5'd20;
		#(PERIOD/2);
		
		#(PERIOD * 5);
		
		//*******************************************************************
		// Test Case 5: Reading both rdat1 and rdat2
		//*******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "reading using rsel1 and rsel2";
		
		reset_dut();
		rfif.WEN = 1'b1;
		rfif.wsel = 5'd20;
		rfif.wdat = 32'hf;
		rfif.rsel1 = 5'd20;
		rfif.rsel2 = 5'd20;
		#(PERIOD/2);
		
		#(PERIOD * 5);
		
		//*******************************************************************
		// Test Case 6: 100%toggle
		//*******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "100%toggle";
		
		reset_dut();
		rfif.WEN = 1'b1;
		rfif.wdat = 32'b11111111111111111111111111111111;
		rfif.wsel = 5'd1;
		#(PERIOD);
		rfif.wsel = 5'd2;
		#(PERIOD);
		rfif.wsel = 5'd3;
		#(PERIOD);
		rfif.wsel = 5'd4;
		#(PERIOD);
		rfif.wsel = 5'd5;
		#(PERIOD);
		rfif.wsel = 5'd6;
		#(PERIOD);
		rfif.wsel = 5'd7;
		#(PERIOD);
		rfif.wsel = 5'd8;
		#(PERIOD);
		rfif.wsel = 5'd9;
		#(PERIOD);
		rfif.wsel = 5'd10;
		#(PERIOD);		
		rfif.wsel = 5'd11;
		#(PERIOD);
		rfif.wsel = 5'd12;
		#(PERIOD);
		rfif.wsel = 5'd13;
		#(PERIOD);
		rfif.wsel = 5'd14;
		#(PERIOD);
		rfif.wsel = 5'd15;
		#(PERIOD);
		rfif.wsel = 5'd16;
		#(PERIOD);
		rfif.wsel = 5'd17;
		#(PERIOD);
		rfif.wsel = 5'd18;
		#(PERIOD);
		rfif.wsel = 5'd19;
		#(PERIOD);
		rfif.wsel = 5'd20;
		#(PERIOD);
		rfif.wsel = 5'd21;
		#(PERIOD);
		rfif.wsel = 5'd22;
		#(PERIOD);
		rfif.wsel = 5'd23;
		#(PERIOD);
		rfif.wsel = 5'd24;
		#(PERIOD);
		rfif.wsel = 5'd25;
		#(PERIOD);
		rfif.wsel = 5'd26;
		#(PERIOD);
		rfif.wsel = 5'd27;
		#(PERIOD);
		rfif.wsel = 5'd28;
		#(PERIOD);
		rfif.wsel = 5'd29;
		#(PERIOD);
		rfif.wsel = 5'd30;
		#(PERIOD);
		rfif.wsel = 5'd31;
		#(PERIOD);
		rfif.rsel1 = 5'd1;
		#(PERIOD);
		rfif.rsel1 = 5'd2;
		#(PERIOD);
		rfif.rsel1 = 5'd3;
		#(PERIOD);
		rfif.rsel1 = 5'd4;
		#(PERIOD);
		rfif.rsel1 = 5'd5;
		#(PERIOD);
		rfif.rsel1 = 5'd6;
		#(PERIOD);
		rfif.rsel1 = 5'd7;
		#(PERIOD);
		rfif.rsel1 = 5'd8;
		#(PERIOD);
		rfif.rsel1 = 5'd9;
		#(PERIOD);
		rfif.rsel1 = 5'd10;
		#(PERIOD);		
		rfif.rsel1 = 5'd11;
		#(PERIOD);
		rfif.rsel1 = 5'd12;
		#(PERIOD);
		rfif.rsel1 = 5'd13;
		#(PERIOD);
		rfif.rsel1 = 5'd14;
		#(PERIOD);
		rfif.rsel1 = 5'd15;
		#(PERIOD);
		rfif.rsel1 = 5'd16;
		#(PERIOD);
		rfif.rsel1 = 5'd17;
		#(PERIOD);
		rfif.rsel1 = 5'd18;
		#(PERIOD);
		rfif.rsel1 = 5'd19;
		#(PERIOD);
		rfif.rsel1 = 5'd20;
		#(PERIOD);
		rfif.rsel1 = 5'd21;
		#(PERIOD);
		rfif.rsel1 = 5'd22;
		#(PERIOD);
		rfif.rsel1 = 5'd23;
		#(PERIOD);
		rfif.rsel1 = 5'd24;
		#(PERIOD);
		rfif.rsel1 = 5'd25;
		#(PERIOD);
		rfif.rsel1 = 5'd26;
		#(PERIOD);
		rfif.rsel1 = 5'd27;
		#(PERIOD);
		rfif.rsel1 = 5'd28;
		#(PERIOD);
		rfif.rsel1 = 5'd29;
		#(PERIOD);
		rfif.rsel1 = 5'd30;
		#(PERIOD);
		rfif.rsel1 = 5'd31;

		#(PERIOD);
		rfif.rsel2 = 5'd1;
		#(PERIOD);
		rfif.rsel2 = 5'd2;
		#(PERIOD);
		rfif.rsel2 = 5'd3;
		#(PERIOD);
		rfif.rsel2 = 5'd4;
		#(PERIOD);
		rfif.rsel2 = 5'd5;
		#(PERIOD);
		rfif.rsel2 = 5'd6;
		#(PERIOD);
		rfif.rsel2 = 5'd7;
		#(PERIOD);
		rfif.rsel2 = 5'd8;
		#(PERIOD);
		rfif.rsel2 = 5'd9;
		#(PERIOD);
		rfif.rsel2 = 5'd10;
		#(PERIOD);		
		rfif.rsel2 = 5'd11;
		#(PERIOD);
		rfif.rsel2 = 5'd12;
		#(PERIOD);
		rfif.rsel2 = 5'd13;
		#(PERIOD);
		rfif.rsel2 = 5'd14;
		#(PERIOD);
		rfif.rsel2 = 5'd15;
		#(PERIOD);
		rfif.rsel2 = 5'd16;
		#(PERIOD);
		rfif.rsel2 = 5'd17;
		#(PERIOD);
		rfif.rsel2 = 5'd18;
		#(PERIOD);
		rfif.rsel2 = 5'd19;
		#(PERIOD);
		rfif.rsel2 = 5'd20;
		#(PERIOD);
		rfif.rsel2 = 5'd21;
		#(PERIOD);
		rfif.rsel2 = 5'd22;
		#(PERIOD);
		rfif.rsel2 = 5'd23;
		#(PERIOD);
		rfif.rsel2 = 5'd24;
		#(PERIOD);
		rfif.rsel2 = 5'd25;
		#(PERIOD);
		rfif.rsel2 = 5'd26;
		#(PERIOD);
		rfif.rsel2 = 5'd27;
		#(PERIOD);
		rfif.rsel2 = 5'd28;
		#(PERIOD);
		rfif.rsel2 = 5'd29;
		#(PERIOD);
		rfif.rsel2 = 5'd30;
		#(PERIOD);
		rfif.rsel2 = 5'd31;
		
		//*******************************************************************
		// Test Case 7: Writing to a register when WEN is 0
		//*******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Writing to a register when WEN is 0";
		
		reset_dut();
		rfif.WEN = 1'b0;
		rfif.wsel = 5'd1;
		rfif.wdat = 32'hfffffff;
		rfif.rsel1 = 5'd1;
		rfif.rsel2 = 5'd1;
		
		reset_dut();
		
	end		
				
endprogram
