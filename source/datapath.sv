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

////SIGNALS FOR CPU TRACKER
opcode_t opcode;
funct_t funct;
logic [15:0] imm16;

assign opcode = fdif.instr_ID[31:26];
assign funct = fdif.instr_ID[5:0];
assign imm16 = it.imm;


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

//assign outputs of control unit to inputs of ID/EX latch
//JIHAN
assign deif.enable =  dpif.ihit || dpif.dhit;
assign deif.flush =  dpif.halt;
assign deif.memtoReg = memtoReg;
assign deif.memWr = memWr;
assign deif.ALUop = aluif.ALUOP;
assign deif.ALU_Src = ALU_Src;
assign deif.EXTop = EXTop;
assign deif.halt = temp_halt;
assign deif.PC_Src = PC_Src;
assign deif.RegDst = RegDst;
assign deif.RegWr = RegWr;
assign deif.Wsel = Wsel;
assign deif.busA = rfif.rdat1;
assign deif.busB = rfif.rdat2;
assign deif.imemaddr_ID = fdif.imemaddr_ID;
assign deif.instr_ID = fdif.instr_ID;
assign deif.opcode = opcode;
assign deif.funct = funct;
assign deif.imm16 = imm16;

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

	r_t rt, rt_ID;
	i_t it;

  //when register file is writing
	assign rt = mwif.instr_WB;
	assign rfif.wsel = (mwif.RegDst_WB == 2'b1) ? rt.rd :  (mwif.RegDst_WB == 2'd2) ? 5'd31 : rt.rt;
	assign rfif.WEN = mwif.RegWr_WB && (dpif.dhit || dpif.ihit);


  //when register file is reading
  assign rt_ID = fdif.instr_ID;
	assign rfif.rsel1 = rt_ID.rs;
	assign rfif.rsel2 = rt_ID.rt;

	assign it = fdif.instr_ID;

	always_comb
	begin
		if(mwif.Wsel_WB == 2'd1)
			rfif.wdat = mwif.imemaddr_WB + 4;
		else if (mwif.Wsel_WB == 2'd2)
			rfif.wdat = meif.extended_WB;
		else
		begin
			if (mwif.memtoReg_WB == 1'b1)
				rfif.wdat = dpif.dmemload; //i think this is right?
			else
				rfif.wdat = mwif.Output_Port_WB;
		end
	end

	register_file RF(CLK, nRST, rfif);

	/*
	module extender
(
	input logic EXTop,
	input logic [15:0]imm16,
	output word_t extended
);*/
	word_t extended;
	extender EXT(.EXTop(deif.EXTop_EX), .imm16(deif.imm16_EX), .extended(extended));

	assign dpif.dmemstore = emif.busB_MEM;
	assign dpif.dmemaddr = emif.Output_Port_MEM;

	assign aluif.Port_A = deif.busA_EX;
	assign aluif.Port_B = ALU_Src ? extended : rfif.deif.busB_EX;

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
