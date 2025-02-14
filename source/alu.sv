`include "alu_if.vh" 
`include "cpu_types_pkg.vh"
module alu(
	alu_if.alu aluif
);
	import cpu_types_pkg::*;
	logic [32:0]temp;


	always_comb
	begin
			aluif.Output_Port = '0;
			aluif.overflow = 0;
			aluif.negative = 0;
			aluif.zero = 0;
			temp = '0;
		casez(aluif.ALUOP)
			
			
			ALU_SLL:
			begin
				aluif.Output_Port = aluif.Port_B<<aluif.Port_A[4:0];
				if(aluif.Output_Port == 32'd0)
					aluif.zero = 1'b1;
				if(aluif.Output_Port[31] == 1)
					aluif.negative = 1'b1;
			end
			ALU_SRL:
			begin
				aluif.Output_Port = aluif.Port_B>>aluif.Port_A[4:0];
				if(aluif.Output_Port == 32'd0)
					aluif.zero = 1'b1;
				if(aluif.Output_Port[31] == 1)
					aluif.negative = 1'b1;
			end
			ALU_ADD:
			begin
				aluif.Output_Port = aluif.Port_A + aluif.Port_B;
				if(aluif.Port_A[31] == 1'b1 && aluif.Port_B[31] == 1'b1 && aluif.Output_Port[31] == 1'b0)
					aluif.overflow = 1'b1;
				if(aluif.Port_A[31] == 1'b0 && aluif.Port_B[31] == 1'b0 && aluif.Output_Port[31] == 1'b1)
					aluif.overflow = 1'b1;
				if(aluif.Output_Port == 32'd0)
					aluif.zero = 1'b1;
				if(aluif.Output_Port[31] == 1)
					aluif.negative = 1'b1;
			end
			ALU_SUB:
			begin
				aluif.Output_Port = aluif.Port_A - aluif.Port_B;
				if(aluif.Port_A[31] == 1'b1 && aluif.Port_B[31] == 1'b0 && aluif.Output_Port[31] == 1'b0)
					aluif.overflow = 1'b1;
				if(aluif.Port_A[31] == 1'b0 && aluif.Port_B[31] == 1'b1 && aluif.Output_Port[31] == 1'b1)
					aluif.overflow = 1'b1;
				if(aluif.Output_Port == 32'd0)
					aluif.zero = 1'b1;
				if(aluif.Output_Port[31] == 1)
					aluif.negative = 1'b1;
			end
			ALU_AND:
			begin
				aluif.Output_Port = aluif.Port_A & aluif.Port_B;
				if(aluif.Output_Port == 32'd0)
					aluif.zero = 1'b1;
				if(aluif.Output_Port[31] == 1)
					aluif.negative = 1'b1;
			end
			ALU_OR:
			begin
				aluif.Output_Port = aluif.Port_A | aluif.Port_B;
				if(aluif.Output_Port == 32'd0)
					aluif.zero = 1'b1;
				if(aluif.Output_Port[31] == 1)
					aluif.negative = 1'b1;
			end
			ALU_XOR:
			begin
				aluif.Output_Port = aluif.Port_A ^ aluif.Port_B;
				if(aluif.Output_Port == 32'd0)
					aluif.zero = 1'b1;
				if(aluif.Output_Port[31] == 1)
					aluif.negative = 1'b1;
			end
			ALU_NOR:
			begin
				aluif.Output_Port = ~(aluif.Port_A | aluif.Port_B);
				if(aluif.Output_Port == 32'd0)
					aluif.zero = 1'b1;
				if(aluif.Output_Port[31] == 1)
					aluif.negative = 1'b1;
			end
			ALU_SLT:
			begin
				if(aluif.Port_A[31] == aluif.Port_B[31] && aluif.Port_A[31] == 1'b1)
				begin
					if(aluif.Port_A > aluif.Port_B)
						aluif.Output_Port = 32'b1;
					else
						aluif.Output_Port = 32'd0;
				end
				if(aluif.Port_A[31] == aluif.Port_B[31] && aluif.Port_A[31] == 1'b0)
				begin
					if(aluif.Port_A < aluif.Port_B)
						aluif.Output_Port = 32'b1;
					else
						aluif.Output_Port = 32'd0;
				end
				else if(aluif.Port_A[31] > aluif.Port_B[31])
					aluif.Output_Port = 32'b1;
				else
					aluif.Output_Port = 32'd0;
				if(aluif.Output_Port == 32'd0)
					aluif.zero = 1'b1;
				if(aluif.Output_Port[31] == 1)
					aluif.negative = 1'b1;
			end
			ALU_SLTU:
			begin
				if(aluif.Port_A < aluif.Port_B)
						aluif.Output_Port = 32'b1;
				else
						aluif.Output_Port = 0;
				if(aluif.Output_Port == 32'd0)
					aluif.zero = 1'b1;
				if(aluif.Output_Port[31] == 1)
					aluif.negative = 1'b1;
			end
		endcase
	end
	
	endmodule
			
			
			

				
			

