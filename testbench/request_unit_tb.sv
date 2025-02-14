module request_unit_tb;

	parameter PERIOD = 10;

  logic CLK = 0, nRST;

	always #(PERIOD/2) CLK++;

	logic memtoReg, memWr, ihit, dhit, dREN, dWEN;



	test PROG(CLK, nRST, dREN, dWEN, memtoReg, memWr, ihit, dhit);

	`ifndef MAPPED
  request_unit DUT(CLK, nRST, memtoReg, memWr, ihit, dhit, dREN, dWEN );
`else
  request_unit DUT(
    .\memtoReg (memtoReg),
		.\memWr (memWr),
		.\ihit (ihit),
		.\dhit (dhit),
		.\dREN (dREN),
		.\dWEN (dWEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

program test(
	input logic CLK,
	output logic nRST,
	input logic dREN,
	input logic dWEN,
	output logic memtoReg, memWr, ihit, dhit
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


		task check_outputs;
			input logic expected_dREN;
			input logic expected_dWEN;
		begin

			if(dREN == expected_dREN)
				$display("Correct dREN");
			else
				$display("Incorrect dREN");
			if(dWEN == expected_dWEN)
				$display("Correct dWEN");
			else
				$display("Incorrect dWEN");
		end
		endtask

		initial
	  begin
			nRST = 1'b1;
			tb_test_num = 0;
			tb_test_case ="Test bench initialization";

			#(0.1);
			memtoReg = 1'b0;
			memWr = 1'b0;
			ihit = 1'b0;
			dhit =1'b0;
			//******************************************************************
			// Test Case 1: Power on Reset
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "Power on Reset";

			reset_dut();
			#(PERIOD);
			check_outputs(1'b0,1'b0);
			#(PERIOD);
			//******************************************************************
			// Test Case 2: setting 1 dREN and dWEN
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "setting 1 dREN and dWEN";

			ihit = 1'b1;
			memtoReg = 1'b1;
			memWr = 1'b1;
			#(PERIOD);
			check_outputs(1'b1,1'b1);
			#(PERIOD);
			memtoReg = 1'b0;
			memWr = 1'b0;

			//******************************************************************
			// Test Case 3: checking dhit
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "checking dhit";

			dhit = 1'b1;
			ihit = 1'b1;
			memtoReg = 1'b1;
			memWr = 1'b1;
			#(PERIOD);
			check_outputs(1'b0,1'b0);
			#(PERIOD);
			memtoReg = 1'b0;
			memWr = 1'b0;

			//******************************************************************
			// Test Case 4: checking if dWEN and dREN latch
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "checking if dWEN and dREN latch ";

			dhit = 1'b0;
			ihit = 1'b1;
			memtoReg = 1'b1;
			memWr = 1'b1;
			#(PERIOD);
			ihit = 1'b0;
			memtoReg = 1'b0;
			memWr = 1'b0;
			#(PERIOD);
			check_outputs(1'b1,1'b1);
			#(PERIOD);
			memtoReg = 1'b0;
			memWr = 1'b0;
			reset_dut();
		end
endprogram









