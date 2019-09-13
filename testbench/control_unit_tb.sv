`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
module control_unit_tb;

	parameter PERIOD = 10;

  logic CLK = 0, nRST;
	
	always #(PERIOD/2) CLK++;
	//import cpu_types_pkg::*;
	
	
	word_t iload;
	logic equal;
	//output to request unit
	logic memtoReg, memWr;
	//output to ALU
	aluop_t ALUop;
	logic ALU_Src;
	//output to extender
	logic [1:0] EXTop;
	//output to PC
	logic halt;
	logic [1:0]PC_Src;
	//output to regfile
	logic [1:0]RegDst;
	logic RegWr;
	logic [1:0]Wsel;
	//output to cache
	logic iREN;
	
	
	test PROG(CLK, nRST, memtoReg, memWr, ALUop, ALU_Src, EXTop, halt, PC_Src, RegDst, RegWr, Wsel, iREN, iload, equal); 
	
	`ifndef MAPPED
		control_unit DUT(
			iload,
			equal,
			memtoReg, 
			memWr,
			ALUop,
			ALU_Src,
			EXTop,
			halt, 
			PC_Src,
			RegDst,
			RegWr,
			Wsel,
			iREN
		);
		`else
			control_unit DUT(
			.\iload (iload),
			.\equal (equal),
			.\memtoReg (memtoReg), 
			.\memWr (memWr),
			.\ALUop (ALUop),
			.\ALU_Src (ALU_Src),
			.\EXTop (EXTop),
			.\halt (halt), 
			.\PC_Src (PC_Src),
			.\RegDst (RegDst),
			.\RegWr (RegWr),
			.\Wsel (Wsel),
			.\iREN (iREN)
		);
`endif
endmodule

program test(

	
	input logic CLK,
	output logic nRST,
	//output to request unit
	input logic memtoReg, 
	input logic memWr,
	//output to ALU
	input aluop_t ALUop,
	input logic ALU_Src,
	//output to extender
	input logic [1:0] EXTop,
	//output to PC
	input logic halt,
	input logic [1:0]PC_Src,
	//output to regfile
	input logic [1:0]RegDst,
	input logic RegWr,
	input logic [1:0]Wsel,
	//output to cache
	input logic iREN,
	output word_t iload,
	output logic equal
);

	int tb_test_num;
		string tb_test_case;
		logic tb_blip = 0;
		
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
			input string test;
			input logic expected_memtoReg; 
			input logic expected_memWr;
			//output to ALU
			input aluop_t expected_ALUop;
			input logic expected_ALU_Src;
			//output to extender
			input logic [1:0] expected_EXTop;
			//output to PC
			input logic expected_halt;
			input logic [1:0]expected_PC_Src;
			//output to regfile
			input logic [1:0]expected_RegDst;
			input logic expected_RegWr;
			input logic [1:0]expected_Wsel;
			//output to cache
			input logic expected_iREN;
		begin
			@(negedge CLK)
			tb_blip = 1'b1;
			assert(memtoReg == expected_memtoReg)
				$display("Correct memtoReg at %s",test);
			else
				$display("Incorrect memtoReg at %s",test);

			assert(memWr == expected_memWr)
				$display("Correct memWr at %s",test);
			else
				$display("Incorrect memWr at %s",test);

			assert(ALUop == expected_ALUop)
				$display("Correct ALUop at %s",test);
			else
				$display("Incorrect ALUop at %s",test);

			assert(ALU_Src == expected_ALU_Src)
				$display("Correct ALU_Src at %s",test);
			else
				$display("Incorrect ALU_Src at %s",test);

			assert(EXTop == expected_EXTop)
				$display("Correct EXTop at %s",test);
			else
				$display("Incorrect EXTop at %s",test);

			assert(halt == expected_halt)
				$display("Correct halt at %s",test);
			else
				$display("Incorrect halt at %s",test);

			assert(PC_Src == expected_PC_Src)
				$display("Correct PC_Src at %s",test);
			else
				$display("Incorrect PC_Src at %s",test);

			assert(RegDst == expected_RegDst)
				$display("Correct RegDst at %s",test);
			else
				$display("Incorrect RegDst at %s",test);

			assert(RegWr == expected_RegWr)
				$display("Correct RegWr at %s",test);
			else
				$display("Incorrect RegWr at %s",test);

			assert(Wsel == expected_Wsel)
				$display("Correct Wsel at %s",test);
			else
				$display("Incorrect Wsel at %s",test);

			assert(iREN == expected_iREN)
				$display("Correct iREN at %s",test);
			else
				$display("Incorrect iREN at %s",test);
			#(0.2);
			tb_blip = 0;
		end
		endtask

		initial 
	  begin
			nRST = 1'b1;
			tb_test_num = 0;
			tb_test_case ="Test bench initialization";
			#(0.1);
			iload = '0;
			equal = 1'b0;
			//******************************************************************
			// Test Case 1: Power on Reset
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "Power on Reset";
	
			reset_dut();
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_OR, 1'b0, 2'b0, 1'b0, 2'b0, 2'b0, 1'b0, 2'b0, 1'b1);
			#(PERIOD);
			//******************************************************************
			// Test Case 2: RType SLLV
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "RType SLLV";
			iload [5:0] = SLLV;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_SLL, 1'b0, 2'b0, 1'b0, 2'b0, 2'b1, 1'b1, 2'b0, 1'b1);
			#(PERIOD);
			//******************************************************************
			// Test Case 3: RType SRLV
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "RType SRLV";
			iload [5:0] = SRLV;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_SRL, 1'b0, 2'b0, 1'b0, 2'b0, 2'b1, 1'b1, 2'b0, 1'b1);
			#(PERIOD);
			//******************************************************************
			// Test Case 4: RType JR
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "RType JR";
			iload [5:0] = JR;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_OR, 1'b0, 2'b0, 1'b0, 2'b11, 2'b10, 1'b0, 2'b0, 1'b1);
					#(PERIOD);
			//******************************************************************
			// Test Case 5: RType ADD
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "RType ADD";
			iload [5:0] = ADD;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_ADD, 1'b0, 2'b0, 1'b0, 2'b0, 2'b1, 1'b1, 2'b0, 1'b1);
			#(PERIOD);
			//******************************************************************
			// Test Case 6: RType ADDU
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "RType ADD";
			iload [5:0] = ADDU;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_ADD, 1'b0, 2'b0, 1'b0, 2'b0, 2'b1, 1'b1, 2'b0, 1'b1);
					#(PERIOD);	
			//******************************************************************
			// Test Case 7: RType SUB
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "RType SUB";
			iload [5:0] = SUB;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_SUB, 1'b0, 2'b0, 1'b0, 2'b0, 2'b1, 1'b1, 2'b0, 1'b1);
						#(PERIOD);
			//******************************************************************
			// Test Case 8: RType AND
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "RType AND";
			iload [5:0] = AND;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_AND, 1'b0, 2'b0, 1'b0, 2'b0, 2'b1, 1'b1, 2'b0, 1'b1);
					#(PERIOD);	
			//******************************************************************
			// Test Case 9: RType OR
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "RType OR";
			iload [5:0] = OR;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_OR, 1'b0, 2'b0, 1'b0, 2'b0, 2'b1, 1'b1, 2'b0, 1'b1);
			#(PERIOD);
			//******************************************************************
			// Test Case 10: RType XOR
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "RType XOR";
			iload [5:0] = XOR;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_XOR, 1'b0, 2'b0, 1'b0, 2'b0, 2'b1, 1'b1, 2'b0, 1'b1);
			#(PERIOD);
			//******************************************************************
			// Test Case 11: RType NOR
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "RType NOR";
			iload [5:0] = NOR;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_NOR, 1'b0, 2'b0, 1'b0, 2'b0, 2'b1, 1'b1, 2'b0, 1'b1);
						#(PERIOD);
			//******************************************************************
			// Test Case 12: RType SLT
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "RType SLT";
			iload [5:0] = SLT;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_SLT, 1'b0, 2'b0, 1'b0, 2'b0, 2'b1, 1'b1, 2'b0, 1'b1);
				#(PERIOD);
			//******************************************************************
			// Test Case 13: RType SLTU
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "RType SLTU";
			iload [5:0] = SLTU;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_SLTU, 1'b0, 2'b0, 1'b0, 2'b0, 2'b1, 1'b1, 2'b0, 1'b1);
						#(PERIOD);
			//******************************************************************
			// Test Case 14: J
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "J";
			iload [31:26] = J;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_OR, 1'b0, 2'b0, 1'b0, 2'b11, 2'b0, 1'b0, 2'b0, 1'b1);
			#(PERIOD);
			//******************************************************************
			// Test Case 15: JAL
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "JAL";
			iload [31:26] = JAL;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_OR, 1'b0, 2'b0, 1'b0, 2'b11, 2'b10, 1'b1, 2'b1, 1'b1);
			#(PERIOD);
			//******************************************************************
			// Test Case 15: BEQ equal is asserted
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "BEQ equal is asserted";
			iload [31:26] = BEQ;
			equal =1'b1;
				
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_SUB, 1'b0, 2'b0, 1'b0, 2'b1, 2'b0, 1'b0, 2'b0, 1'b1);
				#(PERIOD);			
			//******************************************************************
			// Test Case 15: BEQ equal is deasserted
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "BEQ equal is deasserted";
			iload [31:26] = BEQ;
			equal =1'b0;
				
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_SUB, 1'b0, 2'b0, 1'b0, 2'b0, 2'b0, 1'b0, 2'b0, 1'b1);
					#(PERIOD);	
			//******************************************************************
			// Test Case 16: BNE equal is asserted
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "BNE equal is asserted";
			iload [31:26] = BNE;
			equal =1'b1;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_SUB, 1'b0, 2'b0, 1'b0, 2'b0, 2'b0, 1'b0, 2'b0, 1'b1);
					#(PERIOD);			
			//******************************************************************
			// Test Case 17: BNE equal is deasserted
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "BNE equal is deasserted";
			iload [31:26] = BNE;
			equal =1'b0;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_SUB, 1'b0, 2'b0, 1'b0, 2'b1, 2'b0, 1'b0, 2'b0, 1'b1);
						#(PERIOD);		
			//******************************************************************
			// Test Case 18: ADDI
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "ADDI";
			iload [31:26] = ADDI;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_ADD, 1'b1, 2'b0, 1'b0, 2'b0, 2'b0, 1'b1, 2'b0, 1'b1);
					#(PERIOD);		
			//******************************************************************
			// Test Case 19: ADDIU
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "ADDIU";
			iload [31:26] = ADDIU;
				
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_ADD, 1'b1, 2'b0, 1'b0, 2'b0, 2'b0, 1'b1, 2'b0, 1'b1);
			#(PERIOD);	
			//******************************************************************
			// Test Case 20: SLTI
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "SLTI";
			iload [31:26] = SLTI;
				
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_SLT, 1'b1, 2'b0, 1'b0, 2'b0, 2'b0, 1'b1, 2'b0, 1'b1);
						#(PERIOD);		
			//******************************************************************
			// Test Case 21: SLTIU
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "SLTIU";
			iload [31:26] = SLTIU;
					
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_SLTU, 1'b1, 2'b0, 1'b0, 2'b0, 2'b0, 1'b1, 2'b0, 1'b1);
				#(PERIOD);	
			//******************************************************************
			// Test Case 22: ANDI
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "ANDI";
			iload [31:26] = ANDI;
				
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_AND, 1'b1, 2'b1, 1'b0, 2'b0, 2'b0, 1'b1, 2'b0, 1'b1);
				#(PERIOD);		
			//******************************************************************
			// Test Case 23: ORI
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "ORI";
			iload [31:26] = ORI;
					
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_OR, 1'b1, 2'b1, 1'b0, 2'b0, 2'b0, 1'b1, 2'b0, 1'b1);
						#(PERIOD);	
			//******************************************************************
			// Test Case 24: XORI
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "XORI";
			iload [31:26] = XORI;
				
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_XOR, 1'b1, 2'b1, 1'b0, 2'b0, 2'b0, 1'b1, 2'b0, 1'b1);
	#(PERIOD);		
			//******************************************************************
			// Test Case 25: LUI
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "LUI";
			iload [31:26] = LUI;
					
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_OR, 1'b0, 2'b10, 1'b0, 2'b0, 2'b0, 1'b1, 2'b10, 1'b1);
					#(PERIOD);	
			//******************************************************************
			// Test Case 26: LW
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "LW";
			iload [31:26] = LW;
			
			check_outputs(tb_test_case, 1'b1,1'b0, ALU_ADD, 1'b1, 2'b0, 1'b0, 2'b0, 2'b0, 1'b1, 2'b0, 1'b1);
						#(PERIOD);
			//******************************************************************
			// Test Case 26: SW
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "SW";
			iload [31:26] = SW;
						
			check_outputs(tb_test_case, 1'b0,1'b1, ALU_ADD, 1'b1, 2'b0, 1'b0, 2'b0, 2'b0, 1'b0, 2'b0, 1'b1);
						#(PERIOD);
			//******************************************************************
			// Test Case 28: HALT
			//******************************************************************
			tb_test_num = tb_test_num + 1;
			tb_test_case = "HALT";
			iload [31:26] = HALT;
			
			check_outputs(tb_test_case, 1'b0,1'b0, ALU_OR, 1'b0, 2'b0, 1'b1, 2'b0, 2'b0, 1'b0, 2'b0, 1'b1);
			#(PERIOD);			
		end
endprogram
			
			
