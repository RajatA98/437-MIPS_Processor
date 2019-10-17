`timescale 1 ns / 1 ns

module arp_tb;

  parameter PERIOD_RX = 10;
	parameter PERIOD_TX = 10;

  logic CLK_RX = 0;
	logic CLK_TX = 0;

	logic ARESET;
	logic [41:0] MY_MAC;
	logic [31:0] MY_IPV4;
	
	logic DATA_VALID_RX;
	logic [7:0] DATA_RX;
	
	logic DATA_ACK_TX;
	logic DATA_VALID_TX;
	logic [7:0] DATA_TX;

  // clock
  always #(PERIOD_RX/2) CLK_RX++;

  always #(PERIOD_TX/2) CLK_TX++;
  // test program
  test PROG (ARESET, MY_MAC, MY_IPV4,
	 CLK_RX,
	 DATA_VALID_RX,
	 DATA_RX,
	 CLK_TX,
	 DATA_ACK_TX,
	 DATA_VALID_TX,
	 DATA_TX);
  // DUT
  arp DUT(
  	.ARESET(ARESET), 
		.MY_MAC(MY_MAC), 
		.MY_IPV4(MY_IPV4),
		.CLK_RX(CLK_RX),
		.DATA_VALID_RX(DATA_VALID_RX),
	 	.DATA_RX(DATA_RX),
		.CLK_TX(CLK_TX),
		.DATA_ACK_TX(DATA_ACK_TX),
		.DATA_VALID_TX(DATA_VALID_TX),
	  .DATA_TX(DATA_TX)
  );		

endmodule

program test(
	output logic ARESET,
	output logic [41:0] MY_MAC,
	output logic [31:0] MY_IPV4,
	input logic CLK_RX,
	output logic DATA_VALID_RX,
	output logic [7:0] DATA_RX,
	input logic CLK_TX,
	output logic DATA_ACK_TX,
	input logic DATA_VALID_TX,
	input logic [7:0] DATA_TX
);
		parameter PERIOD_RX = 10;
		parameter PERIOD_TX = 10;
		initial
	  begin		
		ARESET = 1'b1;
		#(PERIOD_RX * 5);
	
		ARESET = 1'b0;

		#(0.1);
		
	 	MY_MAC = '0;
	  MY_IPV4 = '0;
	 	DATA_VALID_RX = '0;
	 	DATA_RX = '0;
	 	DATA_ACK_TX = '0;
		
		
		ARESET = 1'b1;
		#(PERIOD_RX * 5);
	
		ARESET = 1'b0;

		
		
	
		 #(PERIOD_RX * 5);
			DATA_VALID_RX = 1'b1;
			DATA_RX = 8'hff;
			#(PERIOD_RX * 5)
			DATA_ACK_TX = 1'b1;
			DATA_RX = 8'h00;
			#(PERIOD_RX)
			DATA_ACK_TX = '0;
			DATA_RX = 8'h01;
			#(PERIOD_RX)
			DATA_RX = 8'h42;
			#(PERIOD_RX)
			DATA_RX = 8'h6f;
			DATA_VALID_RX = 1'b0;
	end		
				
endprogram
