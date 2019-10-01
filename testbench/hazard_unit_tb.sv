`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module hazard_unit_tb;
   parameter PERIOD = 10;

   logic CLK = 0, nRST;
   always #(PERIOD/2) CLK++;

		task check_output;
      input logic act_flush_ID;
			input logic exp_flush_ID;

			input logic act_flush_EX;
      input logic exp_flush_EX;

      input logic act_flush_MEM;
      input logic exp_flush_MEM;

      input logic act_enable_ID;
      input logic exp_enable_ID;

      input logic act_enable_EX;
      input logic exp_enable_EX;

      input logic exp_enable_MEM;
      input logic act_enable_MEM;
      input string test_name;

		begin

			if( act_flush_ID == expected_flush_ID)
				$display("%s flush signal in IF/ID latch Correct.", test_name);
      else
        $display("%s flush signal in IF/ID latch Incorrect.", test_name);

			if(act_flush_EX == exp_flush_EX)
				$display("%s flush signal in ID/EX latch Correct.", test_name);
			else
				$display("%s flush signal in ID/EX latch incorrect.", test_name);

			if(act_flush_MEM == exp_flush_MEM)
				$display("%s flush signal in EX/MEM latch Correct.", test_name);
			else
				$display("%s flush signal in EX/MEM latch incorrect.", test_name);

			if(act_enable_ID == exp_enable_ID)
				$display("%s enable signal in IF/ID latch Correct.", test_name);
			else
				$display("%s enable signal in IF/ID latch incorrect.", test_name);

			if(act_enable_EX == exp_enable_EX)
				$display("%s enable signal in ID/EX latch Correct.", test_name);
			else
				$display("%s enable signal in ID/EX latch incorrect.", test_name);

			if(act_enable_MEM == exp_enable_MEM)
				$display("%s enable signal in EX/MEM latch Correct.", test_name);
			else
				$display("%s enable signal in EX/MEM latch incorrect.", test_name);


		end
		endtask



  logic word_t instr_ID, instr_EX, instr_MEM;
  logic flush_ID, flush_EX, flush_MEM, enable_ID, enable_EX, enable_MEM;
  test PROG(instr_ID, instr_EX, instr_MEM, flush_ID, flush_EX, flush_MEM, enable_ID, enable_EX, enable_MEM);

  hazard_unit DUT(instr_ID, instr_EX, instr_MEM, flush_ID, flush_EX,
flush_MEM,enable_ID,enable_EX,enable_MEM);

endmodule

program test(
  input logic word_t instr_ID, instr_EX, instr_MEM,
  output logic flush_ID, flush_EX, flush_MEM, enable_ID, enable_EX,enable_MEM
);

		string test_name;

		initial
	  begin

	  test_name ="Test bench initialization";

		#(0.1);
	  instr_ID = '0;
		instr_EX = '0;
		instr_MEM = '0;

    //Test 1: No Hazard
	  test_name ="Test 1: No Hazard Test";

    instr_ID =  32'b00000000101001100100100000100000;
		instr_EX =  32'b00000000101001100101000000100000;

    #(PERIOD);
    check_output(flush_ID,0,flush_EX,0,flush_MEM,0,enable_ID,1, enable_EX, 1,
enable_MEM, 1,test_name)

    //Test 2: Jump Instruction Hazard
    #(PERIOD);
	  test_name ="Test 2: Jump Instruction Hazard";

	  instr_ID = '0;
		instr_EX = '0;
		instr_MEM = 32'b00001000101001100101000000100000;

    #(PERIOD);
    check_output(flush_ID,1,flush_EX,1,flush_MEM,1,enable_ID,1, enable_EX, 1,
enable_MEM, 1,test_name)

    //Test 3: JAL Instruction Hazard
    #(PERIOD);
	  test_name ="Test 3: JAL Instruction Hazard";

	  instr_ID = '0;
		instr_EX = '0;
		instr_MEM = 32'b00001100101001100101000000100000;

    #(PERIOD);
    check_output(flush_ID,1,flush_EX,1,flush_MEM,1,enable_ID,1, enable_EX, 1,
enable_MEM, 1,test_name)

    //Test 4: RAW Hazard R-instruction (Dependency in Decode and Execute Stage)
    #(PERIOD);
	  test_name ="Test 4: RAW Hazard R-Instruction (ID and EX)";

	  instr_ID = 32'b00000000101001100100100000100000;
		instr_EX = 32'b00000000101001100010100000100000;
		instr_MEM = '0;

    #(PERIOD);
    check_output(flush_ID,0,flush_EX,1,flush_MEM,0,enable_ID,0, enable_EX, 1,
enable_MEM, 1,test_name)


    //Test 5: RAW Hazard R-instruction (Dependency in Decode and Memory Stage)
    #(PERIOD);
	  test_name ="Test 5: RAW Hazard R-Instruction (ID and MEM)";

	  instr_ID =  32'b00000000101001100100100000100000;
		instr_EX = '0;
		instr_MEM = 32'b00000000101001100010100000100000;

    #(PERIOD);
    check_output(flush_ID,0,flush_EX,1,flush_MEM,0,enable_ID,0, enable_EX, 1,
enable_MEM, 1,test_name)

    //Test 6: RAW Hazard I-Type Instruction (Dependency in Decode and Execute Stage)
    #(PERIOD);
	  test_name ="Test 6: RAW Hazard I-Instruction (ID and EX)";

	  instr_ID =  32'b00000000101001100100100000100000;
		instr_EX =  32'b00000000101001100010100000100000;
		instr_MEM = '0;

    #(PERIOD);
    check_output(flush_ID,0,flush_EX,1,flush_MEM,0,enable_ID,0, enable_EX, 1,
enable_MEM, 1,test_name)


    //Test 7: RAW Hazard I-type Instruction (Dependency in Decode and Memory Stage)
    #(PERIOD);
	  test_name ="Test 7: RAW Hazard I-Instruction (ID and MEM)";

	  instr_ID =  32'b00000000101001100100100000100000;
		instr_EX = '0;
		instr_MEM =  32'b00000000101001100010100000100000;

    #(PERIOD);
    check_output(flush_ID,0,flush_EX,1,flush_MEM,0,enable_ID,0, enable_EX, 1,
enable_MEM, 1,test_name)


$finish;
  end
endprogram
