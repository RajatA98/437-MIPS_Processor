/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

	`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

//output logic select


typedef enum logic [3:0] { 
										ARBITRATE,
										INSTR,
										SNOOP,
										SHARED_WB1,
										SHARED_WB2,
										WAIT,
										RAM1,
										RAM2,
										WB1,
										WB2} states;

states n_state, state;
logic busrequest0, busrequest1, writerequest, readrequest, drequest1, drequest0, flag, choose, n_choose, n_cinv0, n_cinv1, n_cwait0, n_cwait1;
word_t n_csnoopaddr0, n_csnoopaddr1, c_dload0, c_dload1, n_dload0, n_dload1;


always_ff @(posedge CLK, negedge nRST)
begin
	if(!nRST)
		state <= ARBITRATE;
	else
		state <= n_state;
end
always_ff @(posedge CLK, negedge nRST)
begin
	if(!nRST)
		choose <= 1'b0;
	else if(flag)
		choose <= n_choose;
	else
		choose <= choose;
end	


assign busrequest0 = (ccif.dWEN[0] || ccif.dREN[0] || ccif.iREN[0]);
assign busrequest1 = (ccif.dWEN[1] || ccif.dREN[1] || ccif.iREN[1]);
assign drequest0 = (ccif.dWEN[0] || ccif.dREN[0]);
assign drequest1 = (ccif.dWEN[1] || ccif.dREN[1]);
assign writerequest = (ccif.dWEN[0] || ccif.dWEN[1]);
assign readrequest = (ccif.dREN[0] || ccif.dREN[1]);

// NEXT STATE LOGIC 

always_comb
begin
	n_state = state;
	ccif.dwait[0] = 1'b1;
	ccif.dwait[1] = 1'b1;
	ccif.iwait[0] = 1'b1;
	ccif.iwait[1] = 1'b1;
	case(state)
		
		ARBITRATE:
		begin

			if(busrequest1 || busrequest0) begin
				if (writerequest) begin
					n_state = WB1;
				end
				else if(readrequest)begin // this is prioritized?
					n_state = SNOOP;
				end
				else begin
					n_state = INSTR;
				end
			end
			else begin
				n_state = ARBITRATE;
			end
		end
		INSTR:
		begin
			if(ccif.ramstate == ACCESS)
			begin
				if(choose)
				begin
					ccif.iwait[1] = 1'b0;
				end
				else
				begin
					ccif.iwait[0] = 1'b0;
				end
					
				n_state = ARBITRATE;
		
			end
			else
				n_state = INSTR;
		end
		SNOOP:
		begin
			if(choose)
			begin	
				if(ccif.cctrans[0])
				begin
					if(ccif.ccwrite[0])
					begin
						n_state = SHARED_WB1;
					end
					else if(!ccif.ccwrite[0])
					begin
						n_state = RAM1;
					end
				end
				else
				begin
					n_state = SNOOP;
				end
			end

			else
			begin
				if(ccif.cctrans[1])
				begin
					if(ccif.ccwrite[1])
					begin
						n_state = SHARED_WB1;
					end
					else if(!ccif.ccwrite[1])
					begin
						n_state = RAM1;
					end
				end
				else
				begin
					n_state = SNOOP;
				end
			end

		end
		SHARED_WB1:
		begin
			if(ccif.ramstate == ACCESS)
			begin
				if(choose)
				begin
					ccif.dwait[0] = 1'b0;
				end
				else
				begin
					ccif.dwait[1] = 1'b0;
				end
				n_state = SHARED_WB2;
			end
			else
			begin
				n_state = SHARED_WB1;
			end
		end
		SHARED_WB2:
		begin
			if(ccif.ramstate == ACCESS)
			begin
				if(choose)
				begin
					ccif.dwait[0] = 1'b0;
				end
				else
				begin
					ccif.dwait[1] = 1'b0;
				end
				n_state = WAIT;
			end
			else
			begin
				n_state = SHARED_WB2;
			end
		end
		WAIT:
		begin
				n_state = ARBITRATE;
		end
		RAM1:
		begin
			if(ccif.ramstate == ACCESS)
			begin
				if(choose)
				begin
					ccif.dwait[1] = 1'b0;
				end
				else
				begin
					ccif.dwait[0] = 1'b0;
				end
				n_state = RAM2;
			end
			else
			begin
				n_state = RAM1;
			end
		end
		RAM2:
		begin
			
			if(ccif.ramstate == ACCESS)
			begin
				if(choose)
				begin
					ccif.dwait[1] = 1'b0;
				end
				else
				begin
					ccif.dwait[0] = 1'b0;
				end
				
					n_state = ARBITRATE;
				
			end
			else
			begin
				n_state = RAM2;
			end
			
		end
		WB1:
		begin
			if(ccif.ramstate == ACCESS)
			begin
				if(choose)
				begin
					ccif.dwait[1] = 1'b0;
				end
				else
				begin
					ccif.dwait[0] = 1'b0;
				end
				n_state = WB2;
			end
			else
			begin
				n_state = WB1;
			end
		end
		WB2:
		begin
			if(ccif.ramstate == ACCESS)
			begin
				if(choose)
				begin
					ccif.dwait[1] = 1'b0;
				end
				else
				begin
					ccif.dwait[0] = 1'b0;
				end
				
					n_state = ARBITRATE;
				
			end
			else
			begin
				n_state = WB2;
			end
		end
	endcase
end

//latch inputs to RAM 
logic n_ramREN, n_ramWEN;
word_t n_ramaddr, n_ramstore;

always_ff @ (posedge CLK, negedge nRST) begin
	if(!nRST) begin
		ccif.ramREN <= '0;
		ccif.ramWEN <= '0;
		ccif.ramaddr <= '0;
		ccif.ramstore <= '0;
	end
	else begin
		ccif.ramREN <= n_ramREN;
		ccif.ramWEN <= n_ramWEN;
		ccif.ramaddr <= n_ramaddr;
		ccif.ramstore <= n_ramstore;
	end
end



always_comb
begin
	n_dload0 = c_dload0;
	n_dload1 = c_dload1;
	flag = 1'b0;
	n_choose = choose;
	//ccif.ccwait[0] = 1'b0;
	//ccif.ccwait[1] = 1'b0;
	//ccif.ccwait[0] = 1'b0;
	//ccif.ccwait[1] = 1'b0;
	/*ccif.ccinv[0] = 1'b0;
	ccif.ccinv[1] = 1'b0;
	ccif.ccsnoopaddr[0] = '0;
	ccif.ccsnoopaddr[1] = '0;*/
	ccif.iload[0] = '0;
	ccif.iload[1] = '0;
	//latch0wb = 1'b0;
	//latch1wb = 1'b1;
	///ccif.ccwait[0];
	n_csnoopaddr0 = ccif.ccsnoopaddr[0]; 
	n_cinv0 = ccif.ccinv[0];
	n_cwait0 = 0;
	n_cwait1 = 0;
	n_csnoopaddr1 = ccif.ccsnoopaddr[1]; 
	n_cinv1 = ccif.ccinv[1];
	
	//what i commented out to latch inputs to RAM 
  //ccif.ramaddr = '0;
	//ccif.ramREN = '0;
	//ccif.ramWEN = '0;
	//ccif.ramstore = '0;

	n_ramREN = '0;
	n_ramWEN = '0;
  //n_ramaddr = '0;
  n_ramstore = '0;

	//ccif.dload[1] = '0;
	//ccif.dload[0] = '0;
	//ccif.dwait[0] = 1'b1;
	//ccif.dwait[1] = 1'b1;
	//ccif.iwait[0] = 1'b1;
	//ccif.iwait[1] = 1'b1;
	case(state)
		ARBITRATE:
		begin
					if(busrequest1 || busrequest0) begin
									flag = 1'b1;
									//d request
									if (drequest0 && drequest1) begin
										if(choose)
											n_choose = 1'b0;
										else
											n_choose = 1'b1;
									end
									else if (drequest0 && !drequest1) begin
											n_choose = 0;
									end
									else if (!drequest0 && drequest1) begin
											n_choose = 1;
									end
									//i request
									else if (ccif.iREN[0] && ccif.iREN[1]) begin
										if(choose)
											n_choose = 1'b0;
										else
											n_choose = 1'b1;
									end
									else if (ccif.iREN[0]) begin
											n_choose = '0;
									end
									else if (ccif.iREN[1]) begin
											n_choose = '1;
									end
					end
		end
		INSTR:
		begin
			if(choose)
			begin	
				n_ramREN = ccif.iREN[1];
				//n_ramaddr = ccif.iaddr[1];
				ccif.iload[1] = ccif.ramload;

				/*what i commented out to latch inputs to RAM 
				ccif.ramREN = ccif.iREN[1];
				ccif.ramaddr = ccif.iaddr[1];
				ccif.iload[1] = ccif.ramload;*/
				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.iwait[1] = 1'b0;
				end*/
			end
			else
			begin
				n_ramREN = ccif.iREN[0];
				//n_ramaddr = ccif.iaddr[0];
				ccif.iload[0] = ccif.ramload;

/*what i commented out to latch inputs to RAM 
				ccif.ramREN = ccif.iREN[0];
				ccif.ramaddr = ccif.iaddr[0];
				ccif.iload[0] = ccif.ramload;*/
				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.iwait[0] = 1'b0;
				end*/
			end
		end
		SNOOP:
		begin
			if(choose)
			begin
				n_cwait0 = 1'b1;
				n_csnoopaddr0 = ccif.daddr[1];
				n_cinv0 = ccif.ccwrite[1];
				//ccif.ccwait[0] = 1'b1;
				//ccif.ccsnoopaddr[0] = ccif.daddr[1];
				//ccif.ccinv[0] = ccif.ccwrite[1];
			end
			else
			begin
				n_cwait1 = 1'b1;
				n_csnoopaddr1 = ccif.daddr[0];
				n_cinv1 = ccif.ccwrite[0];
				//ccif.ccwait[1] = 1'b1;
				//ccif.ccsnoopaddr[1] = ccif.daddr[0];
				//ccif.ccinv[1] = ccif.ccwrite[0];
			end
			
				
		end
		SHARED_WB1:
		begin
			
			if(choose)
			begin
				n_cwait0 = 1'b1;

				n_ramWEN = ccif.dWEN[0];
				n_ramaddr = ccif.daddr[0];
				n_ramstore = ccif.dstore[0];
				n_dload1 = ccif.dstore[0];

				//latch1wb = 1'b1;
/*what i commented out to latch inputs to RAM 
				ccif.ramWEN = ccif.dWEN[0];
				ccif.ramaddr = ccif.daddr[0];
				ccif.ramstore = ccif.dstore[0];
				n_dload1 = ccif.dstore[0];*/
				//ccif.ccwait[0] = 1'b1;
				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.dwait[1] = 1'b0;
				end*/
			end
			else
			begin
				n_cwait1 = 1'b1;

				n_ramWEN = ccif.dWEN[1];
				n_ramaddr = ccif.daddr[1];
				n_ramstore = ccif.dstore[1];

				//latch0wb = 1'b1;

/*what i commented out to latch inputs to RAM 
				ccif.ramWEN = ccif.dWEN[1];
				ccif.ramaddr = ccif.daddr[1];
				ccif.ramstore = ccif.dstore[1];
				n_dload0 = ccif.dstore[1];*/
				//ccif.ccwait[1] = 1'b1;
				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.dwait[0] = 1'b0;
				end*/
			end

				
		end
		SHARED_WB2:
		begin
			if(choose)
			begin
				n_cwait0 = 1'b1;	

				n_ramWEN = ccif.dWEN[0];
				n_ramaddr = ccif.daddr[0];
				n_ramstore = ccif.dstore[0];
				n_dload1 = ccif.dstore[0];

				//latch1wb = 1'b1;

/*what i commented out to latch inputs to RAM 
				ccif.ramWEN = ccif.dWEN[0];
				ccif.ramaddr = ccif.daddr[0];
				ccif.ramstore = ccif.dstore[0];
				n_dload1 = ccif.dstore[0];*/
				//ccif.ccwait[0] = 1'b1;
				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.dwait[1] = 1'b0;
				end*/
				
			end
			else
			begin
				n_cwait1 = 1'b1;

				//latch0wb = 1'b1;

				n_ramWEN = ccif.dWEN[1];
				n_ramaddr = ccif.daddr[1];
				n_ramstore = ccif.dstore[1];
				n_dload0 = ccif.dstore[1];

/*what i commented out to latch inputs to RAM 
				ccif.ramWEN = ccif.dWEN[1];
				ccif.ramaddr = ccif.daddr[1];
				ccif.ramstore = ccif.dstore[1];
				n_dload0 = ccif.dstore[1];*/
				//ccif.ccwait[1f] = 1'b1;
				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.dwait[0] = 1'b0;
				end*/
			end

		end
		RAM1:
		begin
			if(choose)
			begin	
				n_ramREN = ccif.dREN[1];
				n_ramaddr = ccif.daddr[1];

/*what i commented out to latch inputs to RAM 
				ccif.ramREN = ccif.dREN[1];
				ccif.ramaddr = ccif.daddr[1];*/
				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.dwait[1] = 1'b0;
				end*/
				//ccif.dload[1] = ccif.ramload;
			end
			else
			begin
				n_ramREN = ccif.dREN[0];
				n_ramaddr = ccif.daddr[0];


/*what i commented out to latch inputs to RAM 
				ccif.ramREN = ccif.dREN[0];
				ccif.ramaddr = ccif.daddr[0];*/
				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.dwait[0] = 1'b0;
				end*/
				//ccif.dload[0] = ccif.ramload;
			end
		end
		RAM2:
		begin
			if(choose)
			begin	
				n_ramREN = ccif.dREN[1];
				n_ramaddr = ccif.daddr[1];

/*what i commented out to latch inputs to RAM 
				ccif.ramREN = ccif.dREN[1];
				ccif.ramaddr = ccif.daddr[1];*/
				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.dwait[1] = 1'b0;
				end*/
				//ccif.dload[1] = ccif.ramload;
			end
			else
			begin

				n_ramREN = ccif.dREN[0];
				n_ramaddr = ccif.daddr[0];

/*what i commented out to latch inputs to RAM 
				ccif.ramREN = ccif.dREN[0];
				ccif.ramaddr = ccif.daddr[0];*/
				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.dwait[0] = 1'b0;
				end*/
				//ccif.dload[0] = ccif.ramload;
			end
		end
		WB1:
		begin
			if(choose)
			begin	
				n_ramWEN = ccif.dWEN[1];
				n_ramaddr = ccif.daddr[1];
				n_ramstore = ccif.dstore[1];

/*what i commented out to latch inputs to RAM 
				ccif.ramWEN = ccif.dWEN[1];
				ccif.ramaddr = ccif.daddr[1];
				ccif.ramstore = ccif.dstore[1];*/
				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.dwait[1] = 1'b0;
				end*/
			end
			else
			begin
				n_ramWEN = ccif.dWEN[0];
				n_ramaddr = ccif.daddr[0];
				n_ramstore = ccif.dstore[0];


/*what i commented out to latch inputs to RAM 
				ccif.ramWEN = ccif.dWEN[0];
				ccif.ramaddr = ccif.daddr[0];
				ccif.ramstore = ccif.dstore[0];*/
				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.dwait[0] = 1'b0;
				end*/
			end
		end
		WB2:
		begin
			if(choose)
			begin	

				n_ramWEN = ccif.dWEN[1];
				n_ramaddr = ccif.daddr[1];
				n_ramstore = ccif.dstore[1];

/*what i commented out to latch inputs to RAM 
				ccif.ramWEN = ccif.dWEN[1];
				ccif.ramaddr = ccif.daddr[1];
				ccif.ramstore = ccif.dstore[1];*/

				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.dwait[1] = 1'b0;
				end*/
			end
			else
			begin
				n_ramWEN = ccif.dWEN[0];
			  n_ramaddr = ccif.daddr[0];
				n_ramstore = ccif.dstore[0];

/*what i commented out to latch inputs to RAM 
				ccif.ramWEN = ccif.dWEN[0];
				ccif.ramaddr = ccif.daddr[0];
				ccif.ramstore = ccif.dstore[0];*/
				/*if(ccif.ramstate == ACCESS)
				begin
					ccif.dwait[0] = 1'b0;
				end*/
			end
		end
	endcase
end

always_ff @(posedge CLK, negedge nRST)
begin
	if(!nRST)
	begin
		c_dload0 <= '0;
		c_dload1 <= '0;
	end
	else
	begin
		c_dload0 <= n_dload0;
		c_dload1 <= n_dload1;
	end
end

always_ff @(posedge CLK, negedge nRST)
begin
	if(!nRST)
	begin
		ccif.ccwait[0] <= 1'b0;
		ccif.ccwait[1] <= 1'b0;
		ccif.ccinv[0] <= 1'b0;
		ccif.ccinv[1] <= 1'b0;
		ccif.ccsnoopaddr[0] <= '0;
		ccif.ccsnoopaddr[1] <= '0;
	end
	else
	begin
		ccif.ccwait[0] <= n_cwait0;
		ccif.ccwait[1] <= n_cwait1;
		ccif.ccinv[0] <=  n_cinv0;
		ccif.ccinv[1] <=  n_cinv1;
		ccif.ccsnoopaddr[0] <= n_csnoopaddr0;
		ccif.ccsnoopaddr[1] <= n_csnoopaddr1;
	end
end

assign ccif.dload[0] = ((state == SHARED_WB1 || state == SHARED_WB2 || state == WAIT)? c_dload0 : (state == RAM1 || state == RAM2) && !choose)? ccif.ramload : '0;
assign ccif.dload[1] = ((state == SHARED_WB1 || state == SHARED_WB2 || state == WAIT)? c_dload1 : (state == RAM1 || state == RAM2) && choose)? ccif.ramload : '0;
//assign ccif.dwait[0] = ((ccif.ramstate == ACCESS) && drequest0 && !choose) ? 1'b0:1'b1;		
//assign ccif.dwait[1] = ((ccif.ramstate == ACCESS) && drequest1 && choose) ? 1'b0:1'b1;		
//assign ccif.iwait[0] = ((ccif.ramstate == ACCESS) && !drequest0 && !choose) ? 1'b0:1'b1;		
//assign ccif.iwait[1] = ((ccif.ramstate == ACCESS) && !drequest1 && choose) ? 1'b0:1'b1;	

/*	
	always_comb
	begin
	//output to cache
	//instructions
	ccif.iload = '0;
	ccif.iwait = 1'b1;
	//data
	ccif.dload = '0;
	ccif.dwait = 1'b1;
	//output to RAM
	ccif.ramaddr = '0;
	ccif.ramREN = '0;
	ccif.ramWEN = '0;
	ccif.ramstore = '0;
	
	if(ccif.dWEN == 1'b1)
	begin
		ccif.ramWEN = ccif.dWEN;
		ccif.ramaddr = ccif.daddr;
		ccif.ramstore = ccif.dstore;
		if(ccif.ramstate == ACCESS)
		begin
			ccif.dwait = 1'b0;
		end
	end
	
	else if(ccif.dREN == 1'b1)
	begin
		ccif.ramREN = ccif.dREN;
		ccif.ramaddr = ccif.daddr;
		ccif.dload = ccif.ramload;
		if(ccif.ramstate == ACCESS)
		begin
			
			ccif.dwait = 1'b0;
		end
	end
	else if (ccif.iREN == 1'b1)
	begin
		ccif.ramREN = ccif.iREN;
		ccif.ramaddr = ccif.iaddr;
		ccif.iload = ccif.ramload;
		if(ccif.ramstate == ACCESS)
		begin
			
			ccif.iwait = 1'b0;
		end
	end

	end	
	
	
*/
	
	
	

endmodule
