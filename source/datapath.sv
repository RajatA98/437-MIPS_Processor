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
  // pc init
  parameter PC_INIT = 0;
	
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
	
	
	//control unit signals
	logic memtoReg, memWr, ALU_Src;
	logic [1:0]EXTop;
	logic temp_halt;
	logic [1:0]PC_Src;
	logic [1:0]RegDst;
	logic RegWr;
	logic [1:0]Wsel;
	
	control_unit CU(
		.iload(dpif.imemload), 
		.equal(aluif.zero),
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

	always_ff @(posedge CLK, negedge nRST)
	begin
		if(!nRST) 
			dpif.halt <= 1'b0;
		else if(temp_halt == 1'b1)
			dpif.halt <= 1'b1;
		else
			dpif.halt <= dpif.halt;

	end
	
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
	
	
	always_comb
	begin		
		if(PC_Src == 2'd3)
			current_addr = aluif.Port_A;
		else if (PC_Src == 2'd2)
			//j_temp = dpif.imemaddr + 4;
			current_addr = {dpif.imemaddr[31:28], dpif.imemload[25:0] << 2};
		else if (PC_Src == 2'd1)
			current_addr = (extended << 2) + (dpif.imemaddr + 4);
		else
			current_addr = dpif.imemaddr + 4;
	end
	
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
