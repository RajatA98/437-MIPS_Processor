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
  aluop_t ALUop;

 //flush and enable signals
	//logic flush_ID_BP, flush_EX_BP, flush_MEM_BP,
	logic flush_ID, flush_EX, flush_MEM, enable_ID, enable_EX, enable_MEM;
 logic fw_enable, hazard_enable;
	logic flush_ID_fw, flush_EX_fw, flush_MEM_fw;

//PIPELINE STAGES CALLED BY JIHAN
fetch_decode FD(CLK, nRST, fdif);
decode_execute DE(CLK, nRST, deif);
execute_memory EM(CLK, nRST, dpif.dhit, emif);
memory_wb MW(CLK, nRST, mwif);

//fetch decode latch signal input assignments
assign fdif.imemload = dpif.imemload;
assign fdif.flush = dpif.halt || ((flush_ID /*|| flush_ID_BP*/) && hazard_enable) || (flush_ID_fw && fw_enable);
assign fdif.enable = hazard_enable ? (dpif.ihit || dpif.dhit) && (enable_ID) : (dpif.ihit || dpif.dhit);
assign fdif.imemaddr = dpif.imemaddr;
//assign fdif.next_addr = next_addr;

//assign dpif.halt = mwif.halt_WB;

always_ff @(posedge CLK, negedge nRST) begin
	if (!nRST)
			dpif.halt <= '0;
	else
			dpif.halt <= mwif.halt_WB;
end


////SIGNALS FOR CPU TRACKER
opcode_t opcode;
funct_t funct;
logic [15:0] imm16;
r_t rt_fd;
i_t it;
assign rt_fd = fdif.instr_ID;
assign opcode = rt_fd.opcode;
assign funct = rt_fd.funct;
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
		.equal(aluif.zero),
		.memtoReg(memtoReg),
		.memWr(memWr),
		.ALUop(ALUop),
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
assign deif.enable = hazard_enable ? (dpif.ihit || dpif.dhit) && (enable_EX) : (dpif.ihit || dpif.dhit); //check
assign deif.flush =  dpif.halt || ((flush_EX) && hazard_enable)|| (flush_EX_fw && fw_enable);
assign deif.memtoReg = memtoReg;
assign deif.memWr = memWr;
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
assign deif.imm16 = imm16;
assign deif.shamt = fdif.instr_ID[10:6];

assign deif.opcode = opcode_t'(opcode);
assign deif.funct = funct_t'(funct);
assign deif.ALUop = aluop_t'(ALUop); //check syntax
assign deif.final_wsel = rfif.wsel;
assign deif.next_addr_ID = fdif.next_addr_ID;

/////////////////////////DECODE STAGE/////////////////////
	r_t rt, rt_ID;
	
	i_t it_b;
	assign it_b = dpif.imemload;

///branch extender in decode stage
word_t branch_extender;
always_comb begin
		if (it_b.imm[15])
			branch_extender = {16'hffff,it_b.imm};
		else
			branch_extender = {16'b0,it_b.imm};
end

  //when register file is write back mode
	assign rt = mwif.instr_WB;
	//assign rfif.wsel = (mwif.RegDst_WB == 2'b1) ? rt.rd :  (mwif.RegDst_WB == 2'd2) ? 5'd31 : rt.rt;
	always_comb
	begin
		if(mwif.RegDst_WB == 2'd1)
			rfif.wsel = rt.rd;
		else if(mwif.RegDst_WB == 2'd2)
			rfif.wsel = 5'd31;
		else
			rfif.wsel = rt.rt;
	end

	assign rfif.WEN = mwif.RegWr_WB; /*&& (dpif.dhit || dpif.ihit);*/


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
			rfif.wdat = mwif.extended_WB;
		else
		begin
			if (mwif.memtoReg_WB == 1'b1)
				rfif.wdat = mwif.dload_WB; //i think this is right?
			else
				rfif.wdat = mwif.Output_Port_WB;
		end
	end

	register_file RF(CLK, nRST, rfif);	word_t next_addr;

word_t branch_addr;
assign branch_addr = (branch_extender << 2) + (dpif.imemaddr + 4);

	
	
	logic not_taken;

	logic bp_choose;
	logic pc_halt, pc_enable; 
	//pc_enable_bp;
	
always_comb
	begin


    
	 if (emif.PC_Src_MEM == 2'd2) begin
			//j_temp = dpif.imemaddr + 4;
			//for jump
      next_addr = emif.jump_addr_MEM;
			fdif.next_addr = emif.jump_addr_MEM;
		end
		/*else if (not_taken)
		begin
			next_addr = ;
			fdif.next_addr = ;
		end*/
		
		else if(emif.PC_Src_MEM == 2'd3) begin
			next_addr = emif.busA_MEM;
			fdif.next_addr = emif.busA_MEM;
		end
		else if ((bp_choose && hazard_enable) || not_taken) begin
      //for branch
      next_addr = emif.imemaddr_MEM + 4;
			fdif.next_addr = emif.imemaddr_MEM + 4;
		end
		else if (it_b.opcode == BEQ || it_b.opcode == BNE) begin
      //for branch
      next_addr = branch_addr;
			fdif.next_addr = branch_addr;
		end
		else begin
			next_addr = dpif.imemaddr + 4;
			fdif.next_addr = dpif.imemaddr + 4;
		end
end

//////////////////////EXECUTE STAGE////////////////////////

	/*
	module extender
(
	input logic EXTop,
	input logic [15:0]imm16,
	output word_t extended
);*/
	word_t extended;
	extender EXT(.EXTop(deif.EXTop_EX), .imm16(deif.imm16_EX), .extended(extended));

word_t busB;
logic [1:0] Asel, Bsel;
////MUXES FOR FORWARDING
always_comb begin
  aluif.Port_A = deif.busA_EX;
  emif.busB_EX = deif.busB_EX;
  if (fw_enable) begin //need forwarding
      if (Asel == 0)
        aluif.Port_A = deif.busA_EX;
      else if (Asel == 1)
        aluif.Port_A = emif.Output_Port_MEM;
      else if (Asel == 2)
        aluif.Port_A = rfif.wdat;

      if (Bsel == 0)
       emif.busB_EX = deif.busB_EX;
      else if (Bsel == 1)
        emif.busB_EX = emif.Output_Port_MEM;
      else if (Bsel == 2)
        emif.busB_EX = rfif.wdat;

  end
end


  assign aluif.Port_B =  deif.ALU_Src_EX ? extended : emif.busB_EX;
  assign aluif.ALUOP = deif.ALUop_EX;

	alu ALU(aluif);

word_t jump_addr_EX;
assign jump_addr_EX =  {deif.imemaddr_EX[31:28], deif.instr_EX[25:0] << 2};


//connecting signals to input of EX/MEM latch
  assign emif.flush = dpif.halt || ((flush_MEM) && hazard_enable) || (flush_MEM_fw && fw_enable);
  assign emif.enable = hazard_enable ? (dpif.ihit || dpif.dhit) && (enable_MEM) : (dpif.ihit || dpif.dhit);
  assign emif.RegWr_EX = deif.RegWr_EX;
  assign emif.RegDst_EX = deif.RegDst_EX;
  assign emif.memtoReg_EX = deif.memtoReg_EX;
  assign emif.memWr_EX = deif.memWr_EX;
  assign emif.PC_Src_EX = deif.PC_Src_EX;
  assign emif.Wsel_EX = deif.Wsel_EX;
  assign emif.busA_EX = deif.busA_EX;
	//assign emif.busB_EX = deif.busB_EX ;
  assign emif.imemaddr_EX = deif.imemaddr_EX;
  assign emif.jump_addr = jump_addr_EX;
  assign emif.branch_addr = branch_addr;
  assign emif.zero = aluif.zero;
  assign emif.Output_Port = aluif.Output_Port;
  assign emif.opcode_EX = opcode_t'(deif.opcode_EX);
  assign emif.funct_EX = funct_t'(deif.funct_EX);
  assign emif.imm16_EX = deif.imm16_EX;
  assign emif.instr_EX = deif.instr_EX;
  assign emif.extended = extended;
	assign emif.halt_EX = deif.halt_EX;
	assign emif.final_wsel_EX = deif.final_wsel_EX;
	assign emif.next_addr_EX = deif.next_addr_EX;
	assign emif.shamt_EX = deif.shamt_EX;



/////////////////////MEMORY STAGE///////////////////////
	assign dpif.dmemstore = emif.busB_MEM;
	assign dpif.dmemaddr = emif.Output_Port_MEM;

///replacement for request unit?????

assign dpif.dmemWEN =emif.memWr_MEM;
assign dpif.dmemREN =emif.memtoReg_MEM;

/*
logic n_dmemWEN,  n_dmemREN;
	always_comb
	begin
		n_dmemWEN = emif.memWr_MEM;
		n_dmemREN =emif.memtoReg_MEM;
		if(dpif.dhit)
		begin
			n_dmemWEN = 0;
			n_dmemREN = 0;
		end
	end

	always_ff @(posedge CLK, negedge nRST)
	begin
		if (!nRST)
		begin
			dpif.dmemWEN <= '0;
			dpif.dmemREN <= '0;
		end
		else
		begin
			dpif.dmemWEN <= n_dmemWEN;
			dpif.dmemREN <= n_dmemREN;
		end
	end*/

//assigning inputs to MEM/WB latch
assign mwif.flush = dpif.halt;
assign mwif.enable = dpif.ihit || dpif.dhit; //check again
assign mwif.memtoReg_MEM = emif.memtoReg_MEM;
assign mwif.Output_Port_MEM = emif.Output_Port_MEM;
assign mwif.RegDst_MEM = emif.RegDst_MEM;
assign mwif.RegWr_MEM = emif.RegWr_MEM;
assign mwif.opcode_MEM = opcode_t'(emif.opcode_MEM);
assign mwif.funct_MEM = funct_t'(emif.funct_MEM);
assign mwif.imm16_MEM = emif.imm16_MEM;
assign mwif.instr_MEM = emif.instr_MEM;
assign mwif.imemaddr_MEM = emif.imemaddr_MEM;
assign mwif.extended_MEM = emif.extended_MEM;
assign mwif.busB_MEM = emif.busB_MEM;
assign mwif.Wsel_MEM = emif.Wsel_MEM;
assign mwif.halt_MEM = emif.halt_MEM;
assign mwif.dload = dpif.dmemload;
assign mwif.final_wsel_MEM = emif.final_wsel_MEM;
assign mwif.next_addr_MEM = emif.next_addr_MEM;
assign mwif.jump_addr_MEM = emif.jump_addr_MEM;
assign mwif.branch_addr_MEM = emif.branch_addr_MEM;
assign mwif.shamt_MEM = emif.shamt_MEM;

logic [4:0] final_rt, final_rs;

assign final_rs = mwif.instr_WB[25:21];
assign final_rt = mwif.instr_WB[20:16];


///////LOGIC FOR FORWARDING UNIT TO OVERRIDE HAZARD UNIT
logic [1:0] hazard_detect;


always_comb begin
  fw_enable = 1; //if hazard is not detected, should not be a forwarding
  hazard_enable = 0; //would determine if flush and enable signals are being considered or not*/

	if(hazard_detect != 0)
	begin
		if(hazard_detect == 2)
		begin
			hazard_enable = 1;			
			if(Asel !=0)
				fw_enable = 1;
			else
				fw_enable = 0;
				
		end
		else
		begin
			hazard_enable = 1;
    	fw_enable = 0;
		end
	end
/*
  if (hazard_detect != 0) begin
    if (hazard_detect == 1) begin //dependency of decoded instruction is in EXECUTE stage
       if (deif.memtoReg_EX == 1) begin
          hazard_enable = 1;
          fw_enable = 0;
       end
       else begin
          hazard_enable = 0;
          fw_enable = 1;
       end
    end
    else if (hazard_detect == 2) begin
       if (emif.memtoReg_MEM == 1) begin  //dependency of decoded instruction is in MEMORY stage
          hazard_enable = 1;
          fw_enable = 0;
       end
       else begin
          hazard_enable = 0;
          fw_enable = 1;
       end
		end
		else if (hazard_detect == 3) begin
			hazard_enable = 1;
			fw_enable = 0;
		end
  end*/
end

////////////////BACK TO FETCH STAGE//////////////////////

	/*module pc
(
	input logic CLK, nRST,
	//input from cache
	input logic ihit,
	//input from control unit
	input logic halt,
	//input from mux
	input word_t next_addr,
	output logic iaddr
);
	*/



	always_comb
	begin
			flush_EX_fw = 1'b0;
			flush_ID_fw = 1'b0;
			flush_MEM_fw = 1'b0;
			not_taken = 1'b0;

		if (emif.instr_MEM[31:26] == BEQ)
		begin
			if(emif.zero_MEM != 1)
			begin
				flush_EX_fw = 1'b1;
				flush_ID_fw = 1'b1;
				flush_MEM_fw = 1'b1;
				not_taken = 1'b1;
				
			end
		end

		else if (emif.instr_MEM[31:26]  == BNE)
		begin
			if(emif.zero_MEM == 1)
			begin
				flush_EX_fw = 1'b1;
				flush_ID_fw = 1'b1;
				flush_MEM_fw = 1'b1;
				not_taken = 1'b1;
			end
		end

	end
	
	assign pc_halt = dpif.halt || ((pc_enable) && hazard_enable);

	pc PC(.CLK(CLK), .nRST(nRST),.ihit(dpif.ihit), .halt(pc_halt), .next_addr(next_addr), .iaddr(dpif.imemaddr));

//	branch_predictor BP(.zero(emif.zero_MEM), .instr(emif.instr_MEM), .pc_enable(pc_enable_bp), .flush_ID(flush_ID_BP), .flush_EX(flush_EX_BP), .flush_MEM(flush_MEM_BP), .bp_choose(bp_choose));

hazard_unit HU(.instr_ID(fdif.instr_ID), .instr_EX(deif.instr_EX), .instr_MEM(emif.instr_MEM),.RegWr_EX(deif.RegWr_EX),.memWr_EX(deif.memWr_EX), .RegWr_MEM(emif.RegWr_MEM),.memWr_MEM(emif.memWr_MEM), .flush_ID(flush_ID), .flush_EX(flush_EX), .flush_MEM(flush_MEM), .pc_enable(pc_enable), .enable_ID(enable_ID), .enable_EX(enable_EX), .enable_MEM(enable_MEM),.hazard(hazard_detect));

	

  forwarding_unit FU(.instr_EX(deif.instr_EX), .instr_MEM(emif.instr_MEM),
.instr_WB(mwif.instr_WB), .RegWr_MEM(emif.RegWr_MEM),
.memWr_MEM(emif.memWr_MEM), .memtoReg_MEM(emif.memtoReg_MEM),
.RegWr_WB(mwif.RegWr_WB), .memtoReg_WB(mwif.memtoReg_WB), .Asel(Asel),
.Bsel(Bsel));

endmodule
