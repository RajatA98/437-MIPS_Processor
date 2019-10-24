`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module forwarding_unit
(
  input word_t instr_EX, instr_MEM, instr_WB,
  input logic RegWr_MEM, memWr_MEM, memtoReg_MEM, RegWr_WB, memtoReg_WB,
  output logic [1:0] Asel, Bsel
);

r_t rt_EX, rt_MEM, rt_WB;
i_t it_EX, it_MEM, it_WB;


//parses the instruction
assign rt_EX = instr_EX;
assign rt_MEM = instr_MEM;
assign rt_WB = instr_WB;
assign it_EX = instr_EX;
assign it_MEM = instr_MEM;
assign it_WB = instr_WB;

always_comb begin
//default values
  Asel = '0;
  Bsel = '0;

  ////Asel and Bsel mux to choose busA that goes to ALU, detected from both EX/MEM and MEM/WB
  if (((RegWr_MEM) && (memtoReg_MEM == 0)) || (RegWr_WB && memtoReg_WB == 0))  begin //NOT LOAD INSTRUCTIONS
      if (rt_EX.opcode == RTYPE) begin ///////////////EX stage is R type//////////////////

          //Determining Asel
          //for rs
          if ((it_MEM.opcode != SW && (rt_EX.rs == rt_MEM.rd) && (rt_MEM.opcode == RTYPE) && (rt_MEM.rd != 0)) || (it_MEM.opcode != RTYPE && it_MEM.opcode != SW && it_MEM.rt != 0 && (rt_EX.rs == it_MEM.rt))  || (it_MEM.opcode == JAL && rt_EX.rs == 6'd31)) begin
             Asel = 2'd1; //output port from MEM
          end
          else if  (( it_WB.opcode != SW &&(rt_EX.rs == rt_WB.rd) && (rt_WB.opcode == RTYPE) && (rt_WB.rd != 0)) || (it_WB.opcode != RTYPE && it_WB.opcode != SW && it_WB.rt != 0 && (rt_EX.rs == it_WB.rt)) || (it_WB.opcode == JAL && rt_EX.rs == 6'd31)) begin
          //if no hazard in the EX/MEM, then go to MEM/WB
            Asel = 2'd2;
          end


          //Determining Bsel
          //for rt
          if ((it_MEM.opcode != SW && (rt_EX.rt == rt_MEM.rd) && (rt_MEM.opcode == RTYPE) && (rt_MEM.rd != 0)) || (it_MEM.opcode != RTYPE && it_MEM.opcode != SW && (it_MEM.rt != 0 && rt_EX.rt == it_MEM.rt)) || (it_MEM.opcode == JAL && rt_EX.rt == 6'd31)) begin
             Bsel = 2'd1; //output from MEM
          end
          else if (( it_WB.opcode != SW &&(rt_EX.rt == rt_WB.rd) && (rt_WB.opcode == RTYPE) && (rt_WB.rd != 0)) || ((it_WB.opcode != RTYPE && it_WB.opcode != SW) && it_WB.opcode != SW &&(it_WB.rt != 0 && rt_EX.rt == it_WB.rt))  || (it_WB.opcode == JAL && rt_EX.rt == 6'd31))  begin
             Bsel = 2'd2; //output from WB
          end

      end


      else if (it_EX.opcode == SW) begin ////////////////EX stage is SW////////////////

          //Determining Asel
          //for rs
          if (((it_EX.rs == rt_MEM.rd) && (rt_MEM.opcode == RTYPE) && (rt_MEM.rd!= 0)) || ((it_MEM.opcode != RTYPE && it_MEM.opcode != SW) && it_MEM.rt != 0 && (it_EX.rs == it_MEM.rt)) || (rt_MEM.opcode == JAL && it_EX.rs == 6'd31)) begin
             Asel = 2'd1; //output port from MEM
          end
          else if  (((it_EX.rs == rt_WB.rd) && (rt_WB.opcode == RTYPE) && (rt_WB.rd != 0)) || ((it_WB.opcode != RTYPE && it_WB.opcode != SW) && it_WB.rt != 0 && (it_EX.rs == it_WB.rt)) || (rt_WB.opcode == JAL && it_EX.rs == 6'd31)) 
					begin
          //if not in the EX/MEM, then go to MEM/WB
            Asel = 2'd2; //output from WB
          end
					
          //Determining Bsel
          if (((it_EX.rt == rt_MEM.rd) && (rt_MEM.opcode == RTYPE) && (rt_MEM.rd != 0)) || ((it_MEM.opcode != RTYPE && it_MEM.opcode != SW) && it_MEM.rt != 0 && (it_EX.rt == it_MEM.rt))|| (rt_MEM.opcode == JAL && it_EX.rt == 6'd31)) begin
             Bsel = 2'd1; //output from MEM
          end
          else if (((it_EX.rt == rt_WB.rd) && (rt_WB.opcode == RTYPE) && (rt_WB.rd != 0)) || ((it_WB.opcode != RTYPE && it_WB.opcode != SW) && it_WB.rt != 0 && (it_EX.rt == it_WB.rt)) || (rt_WB.opcode == JAL && it_EX.rt == 6'd31))  begin
             Bsel = 2'd2; //output from WB
          end
					
      end


      else if (it_EX.opcode != RTYPE) begin ////////////////EX stage is I type, not SW/////////////////

          //Determining Asel
          //just rs
          if (((it_EX.rs == rt_MEM.rd) && (rt_MEM.opcode == RTYPE) && (rt_MEM.rd != 0)) || ((it_MEM.opcode != RTYPE && it_MEM.opcode != SW) && it_MEM.rt != 0 && (it_EX.rs == it_MEM.rt))|| (rt_MEM.opcode == JAL && it_EX.rs == 6'd31)) begin
             Asel = 2'd1; //output port from MEM
          end
          else if  (((it_EX.rs == rt_WB.rd) && (rt_WB.opcode == RTYPE) && (rt_WB.rd != 0)) || ((it_WB.opcode != RTYPE && it_WB.opcode != SW) && it_WB.rt != 0 && (it_EX.rs == it_WB.rt))|| (rt_WB.opcode == JAL && it_EX.rs == 6'd31)) begin
          //if no hazard in the EX/MEM, then go to MEM/WB
            Asel = 2'd2;
          end

      end
  end

	if (memtoReg_WB == 1) begin
          //Determining Asel
          //just rs
          if (rt_EX.rs == it_WB.rt) begin
             Asel = 2'd2; //output port from MEM
          end

          if (rt_EX.rt == it_WB.rt) begin
             Bsel = 2'd2; //output port from MEM
          end

	end

end

endmodule

