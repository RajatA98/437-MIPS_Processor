`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module forwarding_unit_tb;
   parameter PERIOD = 10;

   logic CLK = 0, nRST;
   always #(PERIOD/2) CLK++;

		


  logic word_t instr_WB, instr_EX, instr_MEM;
  logic RegWr_EX, memWr_EX, memtoReg_EX, RegWr_MEM, memWr_MEM, memtoReg_MEM, RegWr_WB, memtoReg_WB;
	logic logic [1:0] Asel, Bsel;
  test PROG(instr_WB, instr_EX, instr_MEM, RegWr_EX, memWr_EX, memtoReg_EX, RegWr_MEM, memWr_MEM, memtoReg_MEM, RegWr_WB, memtoReg_WB, Asel, Bsel );

  forwarding_unit DUT( instr_EX, instr_MEM,instr_WB, RegWr_EX, memWr_EX, memtoReg_EX, RegWr_MEM, memWr_MEM, memtoReg_MEM, RegWr_WB, memtoReg_WB, Asel, Bsel);
task check_output;
      input logic [1:0] exp_Asel;
			input logic [1:0] exp_Bsel;

      input string test_name;

		begin

			if(Asel == exp_Asel)
				$display("%s Asel signal Correct.", test_name);
      else
        $display("%s Asel signal Incorrect.", test_name);

			if(Bsel == exp_Bsel)
				$display("%s Bsel signal Correct.", test_name);
      else
        $display("%s Bsel signal Incorrect.", test_name);

		end
		endtask

endmodule

program test(
  output logic word_t instr_WB, instr_EX, instr_MEM,
	output logic logic RegWr_EX, memWr_EX, memtoReg_EX, RegWr_MEM, memWr_MEM, memtoReg_MEM, RegWr_WB, memtoReg_WB,
  input logic [1:0] Asel, Bsel
);

		r_t rt;
		j_t jt;
		i_t it;
		
		

		string test_name;

		initial
	  begin

	  test_name ="Test bench initialization";

		#(0.1);
	  instr_WB = '0;
		instr_EX = '0;
		instr_MEM = '0;
		RegWr_EX = 1'b0; 
		memWr_EX = 1'b0; 
		memtoReg_EX = 1'b0; 
		RegWr_MEM = 1'b0; 
		memWr_MEM = 1'b0; 
		memtoReg_MEM = 1'b0; 
		RegWr_WB = 1'b0; 
		memtoReg_WB = 1'b0;

    //Test 1: No Hazard
	  test_name ="Test 1: No Hazard Test";
		RegWr_MEM = 1'b1;
    rt.opcode = RTYPE;
		rt.rs = 5'd1;
		rt.rt = 5'd2;
		rt.rd = 5'd3;
		rt.shamt = 5'b0;
		rt.funct = OR;
		
		instr_EX = {rt.opcode,rt.rs,rt.rt,rt.rd,rt.shamt,rt.funct};
		
		rt.rd = 5'd4;
		instr_MEM = {rt.opcode,rt.rs,rt.rt,rt.rd,rt.shamt,rt.funct};
	
		

    #(PERIOD);
    check_output(2'd0, 2'd0, test_name)

    //Test 2: Jump Instruction Hazard
    #(PERIOD);
	  test_name ="Test 2: Jump Instruction Hazard";
		RegWr_MEM = 1'b0;
	  instr_WB = '0;
		instr_EX = '0;
		instr_MEM = 32'b00001000101001100101000000100000;

    #(PERIOD);
    check_output(2'd0, 2'd0, test_name)

    //Test 3: JAL Instruction Hazard
    #(PERIOD);
	  test_name ="Test 3: JAL Instruction Hazard";
		RegWR_MEM = 1'b1;
	  instr_WB = '0;
		instr_EX = '0;
		instr_MEM = 32'b00001100101001100101000000100000;

    #(PERIOD);
    check_output(2'd0, 2'd0, test_name)

    //Test 4: RAW Hazard R-instruction (Dependency in Decode and Execute Stage)
    #(PERIOD);
	  test_name ="Test 4: RAW Hazard R-Instruction (WB and EX)";
		RegWR_MEM = 1'b0;		
		RegWR_WB = 1'b1;
	  instr_WB = 32'b00000000101001100100100000100000;
		instr_EX = 32'b00000000101001100010100000100000;
		instr_MEM = '0;

    #(PERIOD);
    check_output(2'd2, 2'd2, test_name)


    //Test 5: RAW Hazard R-instruction (Dependency in Decode and Memory Stage)
    #(PERIOD);
	  test_name ="Test 5: RAW Hazard R-Instruction (WB and MEM)";
		RegWR_MEM = 1'b1;		
		RegWR_WB = 1'b0;
	  instr_WB =  32'b0;
		instr_EX = 32'b00000000101001100100100000100000;
		instr_MEM = 32'b00000000101001100010100000100000;

    #(PERIOD);
    check_output(2'd1, 2'd1, test_name)


    //Test 6: RAW Hazard I-Type Instruction (Dependency in Decode and Execute Stage)
    #(PERIOD);
	  test_name ="Test 6: RAW Hazard I-Instruction (WB and EX)";
		RegWR_MEM = 1'b0;		
		RegWR_WB = 1'b1;
	  instr_WB =  32'b00000000101001100100100000100000;
		instr_EX =  32'b00000000101001100010100000100000;
		instr_MEM = '0;

    #(PERIOD);
    check_output(2'd2, 2'd2, test_name)



    //Test 7: RAW Hazard I-type Instruction (Dependency in Decode and Memory Stage)
    #(PERIOD);
	  test_name ="Test 7: RAW Hazard I-Instruction (WB and MEM)";
		RegWR_MEM = 1'b1;		
		RegWR_WB = 1'b0;
	  instr_EX =  32'b00000000101001100100100000100000;
		instr_WB = '0;
		instr_MEM =  32'b00000000101001100010100000100000;

    #(PERIOD);
    check_output(2'd1, 2'd1, test_name)



$finish;
  end
endprogram
