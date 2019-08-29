// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;

	import cpu_types_pkg::*;

	alu_if aluif ();

	test PROG(aluif);
`ifndef MAPPED
  alu DUT(aluif);
`else
  alu DUT(
		.\aluif.Output_Port (aluif.Output_Port),
    .\aluif.negative (aluif.negative),
    .\aluif.overflow (aluif.overflow),
    .\aluif.zero(aluif.zero),
    .\aluif.Port_A (aluif.Port_A),
    .\aluif.Port_B (aluif.Port_B),
		.\aluif.Port_B (aluif.ALUOP)
    
  );
`endif
	
endmodule

program test(
	alu_if.tb aluif
);
		
		import cpu_types_pkg::*;

		int tb_test_num;
		string tb_test_case;
		
		task check_outputs;
			input logic [31:0]expected_op;
			input logic expected_overflow;
			input logic expected_negative;
			input logic expected_zero;
		begin
				if(expected_op == aluif.Output_Port)
				begin
						$info("Correct output durring %s", tb_test_case);
				end
				else
				begin
						$error("Incorrect output durring %s", tb_test_case);
				end
				if(expected_overflow == aluif.overflow)
				begin
						$info("Correct overflow output durring %s", tb_test_case);
				end
				else
				begin
						$error("Incorrect overflow output durring %s", tb_test_case);
				end
				if(expected_negative == aluif.negative)
				begin
						$info("Correct negative output durring %s", tb_test_case);
				end
				else
				begin
						$error("Incorrect negative durring %s", tb_test_case);
				end
				if(expected_zero == aluif.zero)
				begin
						$info("Correct zero output durring %s", tb_test_case);
				end
				else
				begin
						$error("Incorrect zero output durring %s", tb_test_case);
				end
		end
		endtask

		initial
		begin
		tb_test_num = 0;
		tb_test_case = "Test bench initialization";
		#(0.1)
		aluif.Port_A = 32'd0;
		aluif.Port_B = 32'd0;
		aluif.ALUOP = ALU_SLL;
		//******************************************************************
		// Test Case 1: SLL functionality
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "SLL test";
		
		#(10);
		aluif.ALUOP = ALU_SLL;
		aluif.Port_A = 32'b11111111111111111111111111111111;
		aluif.Port_B = 32'b0;
		#(10)
		check_outputs(32'b11111111111111111111111111100000, 1'b0, 1'b1, 1'b0);
		//******************************************************************
		// Test Case 2: SRL functionality
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "SRL test";
		
		#(10);
		aluif.ALUOP = ALU_SRL;
		aluif.Port_A = 32'b11111111111111111111111111111111;
		aluif.Port_B = 32'b0;
		#(10)
		check_outputs(32'b00000111111111111111111111111111, 1'b0, 1'b1, 1'b0);
		//******************************************************************
		// Test Case 3: ADD functionality - overflow
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "ADD test";
		
		#(10);
		aluif.ALUOP = ALU_ADD;
		aluif.Port_A = 32'b11111111111111111111111111111111;
		aluif.Port_B = 32'd1;
		#(10)
		check_outputs(32'd0, 1'b1, 1'b0, 1'b1);
		
		#(10);
		aluif.ALUOP = ALU_ADD;
		aluif.Port_A = 32'd0;
		aluif.Port_B = 32'b11111111111111111111111111111111;
		#(10)
		check_outputs(32'b11111111111111111111111111111111, 1'b0, 1'b1, 1'b0);
		
		//******************************************************************
		// Test Case 4: SUB functionality
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "SUB test";
		
		#(10);
		aluif.ALUOP = ALU_SUB;
		aluif.Port_A = 32'b11111111111111111111111111111111;
		aluif.Port_B = 32'b1;
		#(10)
		check_outputs(32'b11111111111111111111111111111110, 1'b0, 1'b1, 1'b0);
		aluif.ALUOP = ALU_SUB;
		aluif.Port_A = 32'b11111111111111111111111111111111;
		aluif.Port_B = 32'b11111111111111111111111111111111;
		#(10)
		check_outputs(32'd0, 1'b0, 1'b0, 1'b1);
		//******************************************************************
		// Test Case 5: AND functionality
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "AND test";
		
		#(10);
		aluif.ALUOP = ALU_AND;
		aluif.Port_A = 32'b00011111111111111111111111111111;
		aluif.Port_B = 32'b11111111111111111111111111111111;
		#(10)
		check_outputs(32'b00011111111111111111111111111111, 1'b0, 1'b0, 1'b0);
		//******************************************************************
		// Test Case 6: OR functionality
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "OR test";
		
		#(10);
		aluif.ALUOP = ALU_OR;
		aluif.Port_A = 32'b00011111111111111111111111111111;
		aluif.Port_B = 32'b01111111111111111111111111111111;
		#(10)
		check_outputs(32'b01111111111111111111111111111111, 1'b0, 1'b0, 1'b0);
		//******************************************************************
		// Test Case 7: XOR functionality
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "XOR test";
		
		#(10);
		aluif.ALUOP = ALU_XOR;
		aluif.Port_A = 32'b00011111111111111111111111111110;
		aluif.Port_B = 32'b11111111111111111111111111111110;
		#(10)
		check_outputs(32'b11100000000000000000000000000000, 1'b0, 1'b1, 1'b0);
		//******************************************************************
		// Test Case 8: NOR functionality
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "NOR test";
		
		#(10);
		aluif.ALUOP = ALU_NOR;
		aluif.Port_A = 32'b00011111111111111111111111111110;
		aluif.Port_B = 32'b11111111111111111111111111111110;
		#(10)
		check_outputs( 32'b00000000000000000000000000000001, 1'b0, 1'b0, 1'b0);
		
		//******************************************************************
		// Test Case 9: SLT functionality
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "SLT test";
		
		#(10);
		aluif.ALUOP = ALU_SLT;
		aluif.Port_A = 32'b00011111111111111111111111111110;
		aluif.Port_B = 32'b11111111111111111111111111111110;
		#(10)
		check_outputs( 32'b00000000000000000000000000000000, 1'b0, 1'b0, 1'b1);

		//******************************************************************
		// Test Case 10: SLTU functionality
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "SLTU test";
		
		#(10);
		aluif.ALUOP = ALU_SLTU;
		aluif.Port_A = 32'b00011111111111111111111111111110;
		aluif.Port_B = 32'b11111111111111111111111111111110;
		#(10)
		check_outputs( 32'b00000000000000000000000000000001, 1'b0, 1'b0, 1'b0);
	end
endprogram
		
		
		

		
	
				
				
				

