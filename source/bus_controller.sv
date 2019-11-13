`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
module bus_controller(
input logic CLK, nRST, 
caches_if.cc ccif,
//output logic select

);

typedef enum logic {
										IDLE, 
										ARBITRATE,
										I,
										SNOOP,
										SHARED_WB1,
										SHARED_WB2,
										RAM1,
										RAM2,
										WRITE_UPDATES,
										WB1,
										WB2} states;

states n_state, state;
logic busrequest, writerequest, readrequest, drequest, flag, choose, n_choose;
always_ff @(posedge CLK, negedge nRST)
begin
	if(!nRST)
		state <= IDLE;
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

assign busrequest = (ccif.dWEN[0] || ccif.dWEN[1] || ccif.dREN[0] || ccif.dREN[1] || ccif.iREN[0] || ccif.iREN[1]);
assign drequest = (ccif.dWEN[0] || ccif.dWEN[1] || ccif.dREN[0] || ccif.dREN[1])
assign writerequest = (ccif.dWEN[0] || ccif.dWEN[1])
assign readrequest = (ccif.dREN[0] || ccif.dREN[1]);
always_comb
begin
	n_state = state;
	case(state)
		
		IDLE:
		begin
			if(busrequest)
				n_state = ARBITRATE;
			else
				n_state = IDLE;
		end
		ARBITRATE:
		begin
			if(drequest)
				n_state = SNOOP;
			else
				n_state = I;
		end
		I:
		begin
			if(ccif.ramstate == ACCESS)
				n_state = ARBITRATE;
			else
				n_state = I;
		end
		SNOOP:
		begin
			if(busrequest)
			begin
				n_state = ARBITRATE;
			end
			else
			begin
				if(choose)
				begin	
					if(ccif.cctrans[0])
					begin
						if(ccif.ccwrite[0] && readrequest)
						begin
							n_state = SHARED_WB1;
						end
						else if(!ccif.ccwrite[0] && readrequest)
						begin
							n_state = RAM1;
						end
					end
					else if(!ccif.cctrans[0])
					begin
						if(ccif.ccwrite[0] && writerequest)
						begin
							n_state = WRITE_UPDATES;
						end
						else if(!ccif.ccwrite[0] && writerequest)
						begin
							n_state = WB1;
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
						if(ccif.ccwrite[1] && readrequest)
						begin
							n_state = SHARED_WB1;
						end
						else if(!ccif.ccwrite[1] && readrequest)
						begin
							n_state = RAM1;
						end
					end
					else if(!ccif.cctrans[1])
					begin
						if(ccif.ccwrite[1] && writerequest)
						begin
							n_state = WRITE_UPDATES;
						end
						else if(!ccif.ccwrite[1] && writerequest)
						begin
							n_state = WB1;
						end
						else
						begin
							n_state = SNOOP;
						end
					end
				end
			end
		end
		SHARED_WB1:
		begin
			if(ccif.ramstate == ACCESS)
			begin
				n_state = SHARED_WB2;
			end
			else
			begin
				n_state = SHARED_WB1;
			end
		end
		SHARED_WB2:
		begin
			if(choose)
			begin
				if(!ccif.ccwrite[0] && (ccif.ramstate == ACCESS))
				begin
					if(busrequest)
					begin
						n_state = ARBITRATE;
					end
					else
					begin
						n_state = IDLE;
					end
				end
				else if(ccif.ccwrite[0] || (ccif.ramstate != ACCESS))
				begin
					n_state = SHARED_WB2;
				end
			end
			else
			begin
				if(!ccif.ccwrite[1] && (ccif.ramstate == ACCESS))
				begin
					if(busrequest)
					begin
						n_state = ARBITRATE;
					end
					else
					begin
						n_state = IDLE;
					end
				end
				else if(ccif.ccwrite[1] || (ccif.ramstate != ACCESS))
				begin
					n_state = SHARED_WB2;
				end
			end
		end
		RAM1:
		begin
			if(ccif.ramstate == ACCESS)
			begin
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
				if(busrequest)
				begin
					n_state = ARBITRATE;
				end
				else
				begin
					n_state = IDLE;
				end
			end
			else
			begin
				n_state = RAM2;
			end
			
		end
		WRITE_UPDATES:
		begin
			if(busrequest)
			begin
				n_state = ARBITRATE;
			end
			else
			begin
				n_state = IDLE;
			end
			
		end
		WB1:
		begin
			if(ccif.ramstate == ACCESS)
			begin
				n_state = SHARED_WB2;
			end
			else
			begin
				n_state = SHARED_WB1;
			end
		end
		WB2:
		begin
			if(choose)
			begin
				if(!ccif.ccwrite[0] && (ccif.ramstate == ACCESS))
				begin
					if(busrequest)
					begin
						n_state = ARBITRATE;
					end
					else
					begin
						n_state = IDLE;
					end
				end
				else if(ccif.ccwrite[0] || (ccif.ramstate != ACCESS))
				begin
					n_state = SHARED_WB2;
				end
			end
			else
			begin
				if(!ccif.ccwrite[1] && (ccif.ramstate == ACCESS))
				begin
					if(busrequest)
					begin
						n_state = ARBITRATE;
					end
					else
					begin
						n_state = IDLE;
					end
				end
				else if(ccif.ccwrite[1] || (ccif.ramstate != ACCESS))
				begin
					n_state = SHARED_WB2;
				end
			end
		end
	endcase
end
always_comb
begin
	ccif.dload[0] = '0;
	ccif.dload[1] = '0;
	flag = 1'b0;
	n_choose = choose
	ccif.ccwait[0] = 1'b0;
	ccif.ccwait[1] = 1'b0;
	ccif.ccinv[0] = 1'b0;
	ccif.ccinv[1] = 1'b0;
	ccif.ccsnoopaddr[0] = '0;
	ccif.ccsnoopaddr[1] = '0;
	
	case(state)
		IDLE:
		begin
		end
		ARBITRATE:
		begin
			flag = 1'b1;
			if(choose)
				n_choose = 1'b0;
			else
				n_choose = 1'b1;
			
		end
		I:
		begin
			if(choose)
			begin	
				ccif.ramREN = ccif.iREN[1];
				ccif.ramaddr = ccif.iaddr[1];
				ccif.iload[1] = ccif.ramload;
			end
			else
			begin
				ccif.ramREN = ccif.iREN[0];
				ccif.ramaddr = ccif.iaddr[0];
				ccif.iload[0] = ccif.ramload;
			end
		end
		SNOOP:
		begin
			if(choose)
			begin
				ccif.ccwait[0] = 1'b1;
				ccif.ccsnoopaddr[0] = ccif.daddr[1];
			end
			else
			begin
				ccif.ccwait[1] = 1'b1;
				ccif.ccsnoopaddr[1] = ccif.daddr[0];
			end
				
		end
		SHARED_WB1:
		begin
			if(choose)
			begin	
				ccif.ramWEN = ccif.dWEN[0];
				ccif.ramaddr = ccif.daddr[1];
				ccif.ramstore = ccif.dstore[0];
			end
			else
			begin
				ccif.ramWEN = ccif.dWEN[1];
				ccif.ramaddr = ccif.daddr[0];
				ccif.ramstore = ccif.dstore[1];
			end

				
		end
		SHARED_WB2:
		begin
			if(choose)
			begin	
				ccif.ramWEN = ccif.dWEN[0];
				ccif.ramaddr = ccif.daddr[1];
				ccif.ramstore = ccif.dstore[0];
			end
			else
			begin
				ccif.ramWEN = ccif.dWEN[1];
				ccif.ramaddr = ccif.daddr[0];
				ccif.ramstore = ccif.dstore[1];
			end
		end
		RAM1:
		begin
			if(choose)
			begin	
				ccif.ramREN = ccif.dREN[1];
				ccif.ramaddr = ccif.daddr[1];
				ccif.dload[1] = ccif.ramload;
			end
			else
			begin
				ccif.ramREN = ccif.dREN[0];
				ccif.ramaddr = ccif.daddr[0];
				ccif.dload[0] = ccif.ramload;
			end
			end
		end
		RAM2:
		begin
			if(choose)
			begin	
				ccif.ramREN = ccif.dREN[1];
				ccif.ramaddr = ccif.daddr[1];
				ccif.dload[1] = ccif.ramload;
			end
			else
			begin
				ccif.ramREN = ccif.dREN[0];
				ccif.ramaddr = ccif.daddr[0];
				ccif.dload[0] = ccif.ramload;
			end
		end
		WRITE_UPDATES:
		begin
			if(choose)
			begin
				ccif.ccinv[0] = 1'b1;
			end
			else
			begin
				ccif.ccinv[1] = 1'b1;
			end
		end
		WB1:
		begin
			if(choose)
			begin	
				ccif.ramWEN = ccif.dWEN[1];
				ccif.ramaddr = ccif.daddr[1];
				ccif.ramstore = ccif.dstore[1];
			end
			else
			begin
				ccif.ramWEN = ccif.dWEN[0];
				ccif.ramaddr = ccif.daddr[0];
				ccif.ramstore = ccif.dstore[0];
			end
		end
		WB2:
		begin
			if(choose)
			begin	
				ccif.ramWEN = ccif.dWEN[1];
				ccif.ramaddr = ccif.daddr[1];
				ccif.ramstore = ccif.dstore[1];
			end
			else
			begin
				ccif.ramWEN = ccif.dWEN[0];
				ccif.ramaddr = ccif.daddr[0];
				ccif.ramstore = ccif.dstore[0];
			end
		end
	endcase
end


assign ccif.dwait = ((ccif.ramstate == ACCESS) && drequest) ? 1'b0:1'b1;		
assign ccif.dwait = ((ccif.ramstate == ACCESS) && !drequest) ? 1'b0:1'b1;		
	

