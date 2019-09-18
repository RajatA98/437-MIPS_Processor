/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
//ADDED BY JIHAN
`include "fetch_decode_if.vh"
`include "decode_execute_if.vh"
`include "execute_memory_if.vh"
`include "memory_wb_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"



module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;
	alu_if aluif ();
	register_file_if rfif ();

  //INTERFACE ADDED BY JIHAN
  fetch_decode_if fdif ();
  decode_execute_if deif ();
  execute_memory_if emif ();
  memory_wb_if mwif ();


  // pc init
  parameter PC_INIT = 0;


	//control unit signals
	logic memtoReg, memWr, ALU_Src;
	logic [1:0]EXTop;
	logic temp_halt;
	logic [1:0]PC_Src;
	logic [1:0]RegDst;
	logic RegWr;
	logic [1:0]Wsel;


//PIPELINE STAGES CALLED BY JIHAN
fetch_decode FD(CLK, nRST, fdif);
decode_execute DE(CLK, nRST, deif);
execute_memory EM(CLK, nRST, emif);
memory_wb MW(CLK, nRST, mwif);

//fetch decode latch signal input assignments
assign fdif.imemload = dpif.imemload;
assign fdif.flush = dpif.halt;
assign fdif.enable = dpif.ihit || dpif.dhit;
assign fdif.imemaddr = dpif.imemaddr;


assign dpif.halt = deif.halt_EX;


	/*
		module control_unit
(
	//input instruction from cache
	input word_t iload,
	//input from ALU
	input logic equal,
	//output to request unit
	output logic memtoReg, memWr,
	//output to ALU
	output aluop_t ALUop,
	output logic ALU_Src,
	//output to extender
	output logic [1:0] EXTop,
	//output to PC
	output logic halt,
	output logic [1:0]PC_Src,
	//output to regfile
	output logic [1:0]RegDst,
	output logic RegWr,
	//output to cache
	output logic iREN
);*/


////CHANGED BY JIHAN (NEED TO CHECK)
	control_unit CU(
		.iload(fdif.instr_ID),
		.equal(emif.zero_MEM),
		.memtoReg(memtoReg),
		.memWr(memWr),
		.ALUop(aluif.ALUOP),
		.ALU_Src(ALU_Src),
		.EXTop(EXTop),
		.halt(temp_halt),
		.PC_Src(PC_Src),
		.RegDst(RegDst),
		.RegWr(RegWr),
		.Wsel(Wsel),
		.iREN(dpif.imemREN)
	);

//assign outputs of control unit to ID/EX latch
assign



	/*module request_unit
(
	input logic CLK, nRST,
	//input from control unit
	input logic memtoReg, memWr,
	//input from cache
	input logic dhit,
	//output to cache
	output logic dREN, dWEN
);*/

	request_unit RU(
		.CLK(CLK),
		.nRST(nRST),
		.memtoReg(memtoReg),
		.memWr(memWr),
		.ihit(dpif.ihit),
		.dhit(dpif.dhit),
		.dREN(dpif.dmemREN),
		.dWEN(dpif.dmemWEN)
	);

	r_t rt;
	i_t it;

	assign rt = dpif.imemload;


	assign rfif.rsel1 = rt.rs;

	assign rfif.rsel2 = rt.rt;

	assign rfif.wsel = RegDst == 2'b1 ? rt.rd :  RegDst == 2'd2 ? 5'd31 : rt.rt;



	//assign rfif.wdat = memtoReg ? dpif.dmemload : aluif.Output_Port;
	assign rfif.WEN = RegWr && (dpif.dhit || dpif.ihit);

	assign it = dpif.imemload;

 /*	logic [15:0]imm16;
	assign imm16 = dpif.imemload[15:0];*/
	word_t extended;

	/*
	module extender
(
	input logic EXTop,
	input logic [15:0]imm16,
	output word_t extended
);*/

	extender EXT(.EXTop(EXTop), .imm16(it.imm), .extended(extended));

	always_comb
	begin
		if(Wsel == 2'd1)
			rfif.wdat = dpif.imemaddr + 4;
		else if (Wsel == 2'd2)
			rfif.wdat = extended;
		else
		begin
			if (memtoReg == 1'b1)
				rfif.wdat = dpif.dmemload;
			else
				rfif.wdat = aluif.Output_Port;
		end
	end


	register_file RF(CLK, nRST, rfif);

	assign dpif.dmemstore = rfif.rdat2;
	assign dpif.dmemaddr = aluif.Output_Port;

	assign aluif.Port_A = rfif.rdat1;
	assign aluif.Port_B = ALU_Src ? extended : rfif.rdat2;

	alu ALU(aluif);

	word_t current_addr;


///CHANGED BY JIHAN///I THINK THIS IS RIGHT!!!!
always_comb
	begin
		if(emif.PC_Src_MEM == 2'd3)
			current_addr = emif.busA_MEM;
		else if (emif.PC_Src_MEM == 2'd2)
			//j_temp = dpif.imemaddr + 4;
			//for jump
      current_addr = emif.jump_addr_MEM;
		else if (emif.PC_Src_MEM == 2'd1)
      //for branch
      current_addr = emif.branch_addr_MEM;
		else
			current_addr = dpif.imemaddr + 4;
end

assign deif.jump_addr_EX =  {deif.imemaddr_EX[31:28], deif.instr_EX[25:0] << 2};
assign deif.branch_addr_EX = (deif.extended_EX << 2) + (deif.imemaddr_EX + 4);



	/*module pc
(
	input logic CLK, nRST,
	//input from cache
	input logic ihit,
	//input from control unit
	input logic halt,
	//input from mux
	input word_t current_addr,
	output logic iaddr
);
	*/


	pc PC(.CLK(CLK), .nRST(nRST),.ihit(dpif.ihit), .halt(dpif.halt), .current_addr(current_addr), .iaddr(dpif.imemaddr));



endmodule
