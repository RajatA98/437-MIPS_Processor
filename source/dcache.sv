//interfaces
`include "cpu_types_pkg.vh"
`include "caches_if.vh"
`include "datapath_cache_if.vh"

module dcache(
  input logic CLK, nRST,
  datapath_cache_if.dcache ddif,
  caches_if.dcache dmif
);

  import cpu_types_pkg::*;

  word_t hit_count, n_hit_count, prev_dmemaddr, current_dmemaddr, miss_cnt, n_miss_cnt;
	logic prev_dhit, halt_flag, n_halt_flag;

  //Cache Frames
  dcache_frame frame_a [7:0];
  dcache_frame next_frame_a [7:0];
  dcache_frame frame_b [7:0];
  dcache_frame next_frame_b [7:0];

  //parsing address input
  dcachef_t addr, snoopaddr, prev_snoopaddr;
  assign addr = ddif.dmemaddr;
	assign prev_dmemaddr = ddif.dmemaddr;
	assign snoopaddr = dmif.ccsnoopaddr;

	//assign prev_dhit = ddif.dhit;

  //getting the right set (really only used for reads)
  dcache_frame set_a, set_b;
  assign set_a = frame_a[addr.idx];
  assign set_b = frame_b[addr.idx];

typedef enum logic [3:0] {IDLE, STOP, MISS, MISS2, WBACK, WBACK2, FLUSH_A, NEXT_FLUSH_A, FLUSH_B, NEXT_FLUSH_B, SNOOP_WB1, SNOOP_WB2, WAIT} dcache_state_t;
dcache_state_t dcache_state, next_state, prev_state;

//to indicate which one is recently used
logic [7:0] used_a, used_b, n_used_a, n_used_b;
//logic n_cctrans, dmif.ccwrite;

//Comparing tags of set with address tag
logic match_a, match_b, hit, miss, lru_enable, hitcnt_enable, dirty, next_a, next_b, valid_a, valid_b, write_hit_a, write_hit_b;
assign match_a = (addr.tag == set_a.tag) ? 1 : 0;
assign match_b = (addr.tag == set_b.tag) ? 1 : 0;
assign valid_a = (set_a.valid && match_a) ? 1 : 0;
assign valid_b = (set_b.valid && match_b) ? 1 : 0;
assign write_hit_a = (set_a.valid && match_a && set_a.dirty) ? 1 : 0;
assign write_hit_b = (set_b.valid && match_b && set_b.dirty) ? 1 : 0;


//halt flag
always_ff @ (posedge CLK, negedge nRST) begin
    if (!nRST) begin
				halt_flag <= '0;
    end
    else begin
				halt_flag <= n_halt_flag;
    end
end

//track prev value of snoopaddress
always_ff @ (posedge CLK, negedge nRST) begin
    if (!nRST) begin
				prev_snoopaddr <= '0;
    end
    else begin
				prev_snoopaddr <= snoopaddr;
    end


end


//RMW register
word_t linkreg, n_linkreg;
logic rmw_valid, n_rmw_valid;

always_ff @ (posedge CLK, negedge nRST) begin
    if (!nRST) begin
      linkreg <= '0;
      rmw_valid <= '0;
    end
    else begin
      linkreg <= n_linkreg;
      rmw_valid <= n_rmw_valid;
    end
end


	//checking dmemaddr
	always_ff @ (posedge CLK, negedge nRST) begin
    if (!nRST) begin
			current_dmemaddr <= '0;
			prev_dhit <= 0;
			//c_enable <= 0;
    end
    else begin
  		current_dmemaddr <= prev_dmemaddr;
			prev_dhit <= ddif.dhit;
			//c_enable <= n_enable;
    end
	end


//Clock to update most recently used (avoid combinational loop?) and to update caches
always_ff @ (posedge CLK, negedge nRST) begin
    if (!nRST) begin
      used_a <= '0;
      used_b <= '0;
    end
    else if (lru_enable) begin
      used_a <= n_used_a;
      used_b <= n_used_b;
    end
    else begin
      used_a <= used_a;
      used_b <= used_b;
    end
end

//hit count registers
always_ff @ (posedge CLK, negedge nRST) begin
    if (!nRST) begin
			hit_count <= '0;
			miss_cnt <= '0;
			//dmif.cctrans <= '0;
    end
    else begin
			hit_count <= n_hit_count;
			miss_cnt <= n_miss_cnt;
			//dmif.cctrans <= n_cctrans;
    end
end


//Frame Registers
always_ff @ (posedge CLK, negedge nRST) begin
    if (!nRST) begin
      frame_a[0] <= '0;
      frame_a[1] <= '0;
      frame_a[2] <= '0;
      frame_a[3] <= '0;
      frame_a[4] <= '0;
      frame_a[5] <= '0;
      frame_a[6] <= '0;
      frame_a[7] <= '0;
      frame_b[0] <= '0;
      frame_b[1] <= '0;
      frame_b[2] <= '0;
      frame_b[3] <= '0;
      frame_b[4] <= '0;
      frame_b[5] <= '0;
      frame_b[6] <= '0;
      frame_b[7] <= '0;
    end

    else begin
      frame_a[0] <= next_frame_a[0];
      frame_a[1] <= next_frame_a[1];
      frame_a[2] <= next_frame_a[2];
      frame_a[3] <= next_frame_a[3];
      frame_a[4] <= next_frame_a[4];
      frame_a[5] <= next_frame_a[5];
      frame_a[6] <= next_frame_a[6];
      frame_a[7] <= next_frame_a[7];

      frame_b[0] <= next_frame_b[0];
      frame_b[1] <= next_frame_b[1];
      frame_b[2] <= next_frame_b[2];
      frame_b[3] <= next_frame_b[3];
      frame_b[4] <= next_frame_b[4];
      frame_b[5] <= next_frame_b[5];
      frame_b[6] <= next_frame_b[6];
      frame_b[7] <= next_frame_b[7];
    end
end

//Snoop Hit or Miss logic
logic dirty_snoop;
always_comb begin
			dirty_snoop = 0;
	    if (frame_a[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame a
					dirty_snoop = frame_a[snoopaddr.idx].dirty;
			end
			else if (frame_b[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame b
					dirty_snoop = frame_b[snoopaddr.idx].dirty;
			end
end



//Block Selection and Hit/Miss, and LRU logic
always_comb begin
    n_used_a = used_a;
    n_used_b = used_b;
    hit = 0;
    miss = 0;
    dirty = 0;

   if (ddif.dmemWEN) begin //processor write request
    if ((write_hit_a) && (!write_hit_b)) begin //only first set is valid
        n_used_a[addr.idx] = 1;
        n_used_b[addr.idx] = 0;
        hit = 1;
        dirty = set_a.dirty;
        //n_hit_count = hit_count + 1;
    end
    else if ((!write_hit_a) && (write_hit_b)) begin //only second set is valid
        n_used_a[addr.idx] = 0;
        n_used_b[addr.idx] = 1;
        hit = 1;
        dirty = set_b.dirty;
        //n_hit_count = hit_count + 1;

    end
    else if ((write_hit_a) && (write_hit_b)) begin //both are valid
        hit = 1;
        //n_hit_count = hit_count + 1;
        if (!used_a[addr.idx] && used_b[addr.idx]) begin //set a is least recently used
           n_used_a[addr.idx] = 1;
           n_used_b[addr.idx] = 0;
           dirty = set_a.dirty;
        end
        else if (!used_b[addr.idx] && used_a[addr.idx]) begin  //set b is least recently used
           n_used_a[addr.idx] = 0;
           n_used_b[addr.idx] = 1;
           dirty = set_b.dirty;
        end
        else if (!used_a[addr.idx]  && !used_b[addr.idx]) begin //both sets were never used - default to use set a
           n_used_a[addr.idx] = 1;
           n_used_b[addr.idx] = 0;
           dirty = set_a.dirty;
        end
    end
    else if ((!write_hit_a) && (!write_hit_b)) begin //none are valid // in here we want to keep LRU the same?????
        miss = 1;

				//the weirdness
				if (frame_a[addr.idx].tag == addr.tag) begin
           n_used_a[addr.idx] = 1;
           n_used_b[addr.idx] = 0;
           dirty = set_a.dirty;
				end 
				else if (frame_b[addr.idx].tag == addr.tag) begin
           n_used_a[addr.idx] = 0;
           n_used_b[addr.idx] = 1;
           dirty = set_b.dirty;
				end
			  else begin
        	if (!used_a[addr.idx] && used_b[addr.idx]) begin //set a is least recently used
           	n_used_a[addr.idx] = 1;
           	n_used_b[addr.idx] = 0;
           	dirty = set_a.dirty;
       	 	end
        	else if (!used_b[addr.idx] && used_a[addr.idx]) begin  //set b is least recently used
           	n_used_a[addr.idx] = 0;
           	n_used_b[addr.idx] = 1;
           	dirty = set_b.dirty;
        	end
       	 	else if (!used_a[addr.idx]  && !used_b[addr.idx]) begin //both sets were never used - default to use set a
           	n_used_a[addr.idx] = 1;
           	n_used_b[addr.idx] = 0;
           	dirty = set_a.dirty;
        	end
			  end
    end

   end

    else if (ddif.dmemREN) begin
    if (valid_a && !valid_b) begin //only first set is valid
        n_used_a[addr.idx] = 1;
        n_used_b[addr.idx] = 0;
        hit = 1;
        dirty = set_a.dirty;
        //n_hit_count = hit_count + 1;
    end
    else if (valid_b && !valid_a)begin //only second set is valid
        n_used_a[addr.idx] = 0;
        n_used_b[addr.idx] = 1;
        hit = 1;
        dirty = set_b.dirty;
        //n_hit_count = hit_count + 1;

    end
    else if (valid_a && valid_b)begin //both are valid
        hit = 1;
        //n_hit_count = hit_count + 1;
        if (!used_a[addr.idx] && used_b[addr.idx]) begin //set a is least recently used
           n_used_a[addr.idx] = 1;
           n_used_b[addr.idx] = 0;
           dirty = set_a.dirty;
        end
        else if (!used_b[addr.idx] && used_a[addr.idx]) begin  //set b is least recently used
           n_used_a[addr.idx] = 0;
           n_used_b[addr.idx] = 1;
           dirty = set_b.dirty;
        end
        else if (!used_a[addr.idx]  && !used_b[addr.idx]) begin //both sets were never used - default to use set a
           n_used_a[addr.idx] = 1;
           n_used_b[addr.idx] = 0;
           dirty = set_a.dirty;
        end
    end
    else if (!valid_a && !valid_b) begin //none are valid
        miss = 1;
        //n_hit_count = hit_count - 1;
        if (!used_a[addr.idx] && used_b[addr.idx]) begin //set a is least recently used
           n_used_a[addr.idx] = 1;
           n_used_b[addr.idx] = 0;
           dirty = set_a.dirty;
        end
        else if (!used_b[addr.idx] && used_a[addr.idx]) begin  //set b is least recently used
           n_used_a[addr.idx] = 0;
           n_used_b[addr.idx] = 1;
           dirty = set_b.dirty;
        end
        else if (!used_a[addr.idx]  && !used_b[addr.idx]) begin //both sets were never used - default to use set a
           n_used_a[addr.idx] = 1;
           n_used_b[addr.idx] = 0;
           dirty = set_a.dirty;
        end

    end
   end

end

//D-Cache Controller State Machine

logic [2:0] flush_count_a, flush_count_b, next_flush_count_a, next_flush_count_b;
//State Register
always_ff @ (posedge CLK, negedge nRST) begin
    if (!nRST) begin
      dcache_state <= IDLE;
      flush_count_a <= '0;
      flush_count_b <= '0;
			prev_state <= IDLE;
    end
    else begin
      dcache_state <= next_state;
      flush_count_a <= next_flush_count_a;
      flush_count_b <= next_flush_count_b;
			prev_state <= dcache_state;
    end
end



//Next State Logic
always_comb begin
		 next_flush_count_a = flush_count_a;
		 next_flush_count_b = flush_count_b;
	 	 n_miss_cnt = miss_cnt;
     next_state = dcache_state;
	   n_halt_flag = halt_flag;
   case(dcache_state)
   IDLE: begin
			if (dmif.ccwait && dirty_snoop) begin
				 next_state = SNOOP_WB1;
				 if (ddif.halt) begin
						n_halt_flag = 1;
				 end
				 else begin
						n_halt_flag = 0;
				 end
			end
      else if (ddif.halt) begin
         next_state = FLUSH_A;
      end
      else if ((ddif.dmemREN || ddif.dmemWEN) && miss && !dirty) begin //miss but no dirty bit
        next_state = MISS;
      end
      else if (((ddif.dmemREN && miss) || (ddif.dmemWEN && miss)) && dirty) begin
        next_state = WBACK;
      end
      else begin
        next_state = IDLE;
      end

   end

   STOP: begin
     if (!nRST) begin
        next_state = IDLE;
     end
     else begin
        next_state = STOP;
     end
   end
   MISS: begin
		 if (dmif.ccwait && dirty_snoop) begin
				 next_state = SNOOP_WB1;
			end

     else if (dmif.dwait) begin
        next_state = MISS;
     end
     else if (!dmif.dwait) begin
        next_state = MISS2;
				n_miss_cnt = miss_cnt + 1;
     end
   end
   MISS2: begin
     if (dmif.dwait) begin
        next_state = MISS2;
     end
     else if (!dmif.dwait) begin
        next_state = IDLE;
     end
   end
   WBACK: begin
		 if (dmif.ccwait && dirty_snoop) begin
				 next_state = SNOOP_WB1;
			end

     if (dmif.dwait) begin
        next_state = WBACK;
     end
     else if (!dmif.dwait) begin
        next_state = WBACK2;
     end
   end
   WBACK2: begin
     if (dmif.dwait) begin
        next_state = WBACK2;
     end
     else if (!dmif.dwait) begin
       next_state = MISS;
     end
   end
   /*HIT_COUNT: begin
     if (dmif.dwait) begin
        next_state = HIT_COUNT;
     end
     else if (!dmif.dwait) begin
       next_state = FLUSH_A;
     end
   end*/
   FLUSH_A: begin
			if (dmif.ccwait && dirty_snoop) begin
				 next_state = SNOOP_WB1;
			end
      else if (dmif.dwait && next_a) begin
        next_state = FLUSH_A;
      end
      else if (!dmif.dwait && next_a)  begin
        next_state = NEXT_FLUSH_A;
      end
      else if (!next_a) begin

		    if (flush_count_a == 7) begin
		      next_state = FLUSH_B;
		    end
		    else if (flush_count_a != 7) begin
		      next_state = FLUSH_A;
          next_flush_count_a = flush_count_a + 1;
		    end

      end
   end
   FLUSH_B: begin
			if (dmif.ccwait && dirty_snoop) begin
				 next_state = SNOOP_WB1;
			end

      else if (dmif.dwait && next_b) begin
          next_state = FLUSH_B;
      end
      else if (!dmif.dwait && next_b)  begin
        next_state = NEXT_FLUSH_B;
      end
      else if (!next_b) begin
				  if (flush_count_b == 7) begin
				    next_state = STOP;
				  end
				  else if (flush_count_b != 7) begin
				    next_state = FLUSH_B;
        		next_flush_count_b = flush_count_b + 1;
				  end
      end
   end

   NEXT_FLUSH_A: begin
      if (dmif.dwait) begin
          next_state = NEXT_FLUSH_A;
      end

      else if (!dmif.dwait) begin
		    if (flush_count_a == 7) begin
		      next_state = FLUSH_B;
		    end
		    else if (flush_count_a != 7) begin
		      next_state = FLUSH_A;
          next_flush_count_a = flush_count_a + 1;
		    end

      end
   end
   NEXT_FLUSH_B: begin
      if (dmif.dwait) begin
          next_state = NEXT_FLUSH_B;
      end
      else if (!dmif.dwait) begin
				  if (flush_count_b == 7) begin
				    next_state = STOP;
				  end
				  else if (flush_count_b != 7) begin
				    next_state = FLUSH_B;
        		next_flush_count_b = flush_count_b + 1;
				  end
      end
   end

	 /*SNOOP: begin
			if (dirty_snoop) begin
				 next_state = SNOOP_WB1;
			end
			else begin
				 next_state = IDLE;
			end
	 end*/
   SNOOP_WB1: begin
			if (dmif.dwait) begin
					next_state = SNOOP_WB1;
			end
			else begin
					next_state = SNOOP_WB2;
			end
	 end
	 SNOOP_WB2: begin
			if (dmif.dwait) begin
					next_state = SNOOP_WB2;
			end
			else begin
					next_state = WAIT;
			end
	 end
	 WAIT: begin
				if (halt_flag) begin
					next_state = FLUSH_A;
				end
				else begin
					next_state = IDLE;
				end
	  end

   endcase
end


//Output Logic (Remember to include mux to choose which set to write to)
//Check everything in here!!!!!!!!!!!!!!!!!!!!!!
always_comb begin
  //check default values
   ddif.dhit = 0;
   ddif.flushed = 0;
   dmif.dREN = 0;
   dmif.dWEN = 0;
   next_frame_a = frame_a;
   next_frame_b = frame_b;
   ddif.dmemload = '0; //maybe not
   dmif.daddr = ddif.dmemaddr;
   dmif.dstore = '0; //unsure
   dmif.daddr = '0; //unsure
   lru_enable = 0;
   next_a = 0;
   next_b = 0;
	 hitcnt_enable = 0;
   n_hit_count = hit_count;

	 //coherence additions
	 dmif.cctrans = 0;
	 dmif.ccwrite = ddif.dmemWEN;

   //atomicity additions
   n_rmw_valid = rmw_valid;
   n_linkreg = linkreg;

   case(dcache_state)
   IDLE: begin //basically where you check tags and stuff // in this state, LRU has not been updated yet
      lru_enable = 1;
      ddif.dhit = 0;


			if(dmif.ccwait) begin
					dmif.cctrans = 1;
					dmif.ccwrite = dirty_snoop;

          if ((dmif.ccsnoopaddr == linkreg) && ddif.datomic) begin
              n_rmw_valid = 0;
          end

					if (frame_a[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame a
							if (dmif.ccinv) begin
									next_frame_a[snoopaddr.idx].valid = '0;
									next_frame_a[snoopaddr.idx].dirty = '0;
							end
							else begin //no invalidate // not a requester write!
									next_frame_a[snoopaddr.idx].dirty = '0;
							end
					end
					else if (frame_b[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame b
							if (dmif.ccinv) begin
									next_frame_b[snoopaddr.idx].valid = '0;
									next_frame_b[snoopaddr.idx].dirty = '0;
							end
							else begin //no invalidate // not a requester write!
									next_frame_b[snoopaddr.idx].dirty = '0;
							end
					end
			end


			else if (!dmif.ccwait) begin
					 if (ddif.dmemWEN && hit) begin //write hit
						    ddif.dhit = 1;
								n_hit_count = hit_count + 1;
						 if (rmw_valid && (linkreg == ddif.dmemaddr)) begin
								n_rmw_valid = 0;
						 end
             if (ddif.datomic) begin //store conditional
                if (rmw_valid && (linkreg == ddif.dmemaddr)) begin //we got the lock
								   n_rmw_valid = 0;
						       if (n_used_a[addr.idx]) begin
						          next_frame_a[addr.idx].data[addr.blkoff] = ddif.dmemstore;
						       end
						       else if (n_used_b[addr.idx]) begin
						          next_frame_b[addr.idx].data[addr.blkoff] = ddif.dmemstore;
						       end
                   ddif.dmemload = 32'h1;
                end
                else begin //did not get lock
                   ddif.dmemload = '0;
                end

             end
             else begin
						    if (n_used_a[addr.idx]) begin
						      next_frame_a[addr.idx].data[addr.blkoff] = ddif.dmemstore;
						      //next_frame_a[addr.idx].dirty = 1;
						    end
						    else if (n_used_b[addr.idx]) begin
						      next_frame_b[addr.idx].data[addr.blkoff] = ddif.dmemstore;
						      //next_frame_b[addr.idx].dirty = 1;
						    end
             end
						end

						else if (ddif.dmemREN && hit) begin //read hit
						    ddif.dhit = 1;
								n_hit_count = hit_count + 1;

                if (ddif.datomic) begin //LL instruction
                    n_rmw_valid = 1;
                    n_linkreg = ddif.dmemaddr; //putting address to link register
                end

						    if (n_used_a[addr.idx]) begin
						      ddif.dmemload =  frame_a[addr.idx].data[addr.blkoff];
						    end
						    else if (n_used_b[addr.idx]) begin
						      ddif.dmemload = frame_b[addr.idx].data[addr.blkoff];
						    end
						end

			end

    end

   FLUSH_A: begin //look through all sets of to flush to memory
      dmif.dWEN = 0;
      dmif.daddr = 0;
      dmif.dstore = 0;
      next_a = 0;

		if(dmif.ccwait) begin
					dmif.cctrans = 1;
					dmif.ccwrite = dirty_snoop;


          if ((dmif.ccsnoopaddr == linkreg)) begin
              n_rmw_valid = 0;
          end

					if (frame_a[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame a
							if (dmif.ccinv) begin
									next_frame_a[snoopaddr.idx].valid = '0;
									next_frame_a[snoopaddr.idx].dirty = '0;
							end
							else begin //no invalidate // not a requester write!
									next_frame_a[snoopaddr.idx].dirty = '0;
							end
					end
					else if (frame_b[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame b
							if (dmif.ccinv) begin
									next_frame_b[snoopaddr.idx].valid = '0;
									next_frame_b[snoopaddr.idx].dirty = '0;
							end
							else begin //no invalidate // not a requester write!
									next_frame_b[snoopaddr.idx].dirty = '0;
							end
					end
			end


			else if (!dmif.ccwait) begin
				  if (frame_a[flush_count_a].valid && frame_a[flush_count_a].dirty) begin
				      next_a = 1;
				      dmif.dWEN = 1;
				      dmif.daddr = {frame_a[flush_count_a].tag, flush_count_a,1'b0,2'b0};
				      dmif.dstore = frame_a[flush_count_a].data[0];
				  end
			 end
	 end
	 NEXT_FLUSH_A: begin
		      dmif.dWEN = 1;
		      dmif.daddr = {frame_a[flush_count_a].tag, flush_count_a,1'b1,2'b0};
		      dmif.dstore = frame_a[flush_count_a].data[1];
	 end
   /*FLUSH_COUNT_A: begin
        next_flush_count_a = flush_count_a + 1;
   end*/

   FLUSH_B: begin
      dmif.dWEN = 0;
      dmif.daddr = 0;
      dmif.dstore = 0;
      next_b = 0;


		if(dmif.ccwait) begin
					dmif.cctrans = 1;
					dmif.ccwrite = dirty_snoop;

          if ((dmif.ccsnoopaddr == linkreg) && ddif.datomic) begin
              n_rmw_valid = 0;
          end

					if (frame_a[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame a
							if (dmif.ccinv) begin
									next_frame_a[snoopaddr.idx].valid = '0;
									next_frame_a[snoopaddr.idx].dirty = '0;
							end
							else begin //no invalidate // not a requester write!
									next_frame_a[snoopaddr.idx].dirty = '0;
							end
					end
					else if (frame_b[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame b
							if (dmif.ccinv) begin
									next_frame_b[snoopaddr.idx].valid = '0;
									next_frame_b[snoopaddr.idx].dirty = '0;
							end
							else begin //no invalidate // not a requester write!
									next_frame_b[snoopaddr.idx].dirty = '0;
							end
					end
			end


			else if (!dmif.ccwait) begin
      if (frame_b[flush_count_b].valid && frame_b[flush_count_b].dirty) begin
          next_b = 1;
          dmif.dWEN = 1;
          dmif.daddr = {frame_b[flush_count_b].tag, flush_count_b,1'b0,2'b0};
          dmif.dstore = frame_b[flush_count_b].data[0];
      end
		 end

   end

   NEXT_FLUSH_B: begin
          dmif.dWEN = 1;
          dmif.daddr = {frame_b[flush_count_b].tag, flush_count_b,1'b1, 2'b0};
          dmif.dstore = frame_b[flush_count_b].data[1];
   end

   /*FLUSH_COUNT_B: begin
        next_flush_count_b = flush_count_b + 1;
   end*/

   STOP: begin
     ddif.flushed = 1;

		if (dmif.ccwait) begin
			dmif.cctrans = 1;
			dmif.ccwrite = 0;
		end
     //dmif.dWEN = 1;
     //dmif.dstore = hit_count;
     //dmif.daddr = 'h3100;
   end

   MISS: begin

		if(dmif.ccwait) begin
					dmif.cctrans = 1;
					dmif.ccwrite = dirty_snoop;


          if ((dmif.ccsnoopaddr == linkreg) && ddif.datomic) begin
              n_rmw_valid = 0;
          end

					if (frame_a[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame a
							if (dmif.ccinv) begin
									next_frame_a[snoopaddr.idx].valid = '0;
									next_frame_a[snoopaddr.idx].dirty = '0;
							end
							else begin //no invalidate // not a requester write!
									next_frame_a[snoopaddr.idx].dirty = '0;
							end
					end
					else if (frame_b[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame b
							if (dmif.ccinv) begin
									next_frame_b[snoopaddr.idx].valid = '0;
									next_frame_b[snoopaddr.idx].dirty = '0;
							end
							else begin //no invalidate // not a requester write!
									next_frame_b[snoopaddr.idx].dirty = '0;
							end
					end
			end


		else if (!dmif.ccwait) begin
     dmif.dREN = 1;
     dmif.daddr = {ddif.dmemaddr[31:3],3'b000}; //first block

     if (!dmif.dwait) begin //is this right?
        if (used_a[addr.idx]) begin //frame a is chosen
           next_frame_a[addr.idx].data[0] = dmif.dload;
        end
        else if (used_b[addr.idx]) begin //frame b is chosen
           next_frame_b[addr.idx].data[0] = dmif.dload;
        end
     end
		end
		end

   MISS2: begin
      dmif.dREN = 1;
      dmif.daddr =  {ddif.dmemaddr[31:3],3'b100}; //second block


     if (!dmif.dwait) begin //is this right?
        if (used_a[addr.idx]) begin //frame a is chosen
           next_frame_a[addr.idx].data[1] = dmif.dload;
        end
        else if (used_b[addr.idx]) begin //frame b is chosen
           next_frame_b[addr.idx].data[1] = dmif.dload;
        end
     end


      //updating cache - tag and valid
      if (used_a[addr.idx]) begin //frame a is chosen
        next_frame_a[addr.idx].tag = addr.tag;
        next_frame_a[addr.idx].valid = 1;
				if (ddif.dmemWEN) begin
						next_frame_a[addr.idx].dirty = 1;
				end
      end
      else if (used_b[addr.idx]) begin //frame b is chosen
        next_frame_b[addr.idx].tag = addr.tag;
        next_frame_b[addr.idx].valid = 1;
				if (ddif.dmemWEN) begin
						next_frame_b[addr.idx].dirty = 1;
				end
      end



   end
   WBACK: begin

		 if(dmif.ccwait) begin
					dmif.cctrans = 1;
					dmif.ccwrite = dirty_snoop;


          if ((dmif.ccsnoopaddr == linkreg) && ddif.datomic) begin
              n_rmw_valid = 0;
          end

					if (frame_a[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame a
							if (dmif.ccinv) begin
									next_frame_a[snoopaddr.idx].valid = '0;
									next_frame_a[snoopaddr.idx].dirty = '0;
							end
							else begin //no invalidate // not a requester write!
									next_frame_a[snoopaddr.idx].dirty = '0;
							end
					end
					else if (frame_b[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame b
							if (dmif.ccinv) begin
									next_frame_b[snoopaddr.idx].valid = '0;
									next_frame_b[snoopaddr.idx].dirty = '0;
							end
							else begin //no invalidate // not a requester write!
									next_frame_b[snoopaddr.idx].dirty = '0;
							end
					end
			end


			else if (!dmif.ccwait) begin
      dmif.dWEN = 1;
      if (used_a[addr.idx]) begin //frame a is chosen
        dmif.dstore = frame_a[addr.idx].data[0];
        dmif.daddr = {frame_a[addr.idx].tag,addr.idx,3'b000}; //first block
      end
      else if (used_b[addr.idx]) begin //frame b is chosen
        dmif.dstore = frame_b[addr.idx].data[0];
        dmif.daddr = {frame_b[addr.idx].tag,addr.idx,3'b000}; //first block
      end
		 end
   end
   WBACK2: begin
      dmif.dWEN = 1;
      if (used_a[addr.idx]) begin //frame a is chosen
        dmif.dstore = frame_a[addr.idx].data[1];
        dmif.daddr = {frame_a[addr.idx].tag,addr.idx,3'b100}; //second block
      end
      else if (used_b[addr.idx]) begin //frame b is chosen
        dmif.dstore = frame_b[addr.idx].data[1];
        dmif.daddr = {frame_b[addr.idx].tag,addr.idx,3'b100}; //second block
      end

      if (used_a[addr.idx]) begin //frame a is chosen
        next_frame_a[addr.idx].dirty = 0;
      end
      else if (used_b[addr.idx]) begin //frame b is chosen
        next_frame_b[addr.idx].dirty = 0;
			end

   end


	 SNOOP_WB1: begin //writing back first block //cache to cache transfer?
      dmif.dWEN = 1;
	    if (frame_a[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame a
					dmif.daddr = {frame_a[snoopaddr.idx].tag,snoopaddr.idx,3'b000};
					dmif.dstore = frame_a[snoopaddr.idx].data[0];
			end
			else if (frame_b[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame b
					dmif.daddr = {frame_b[snoopaddr.idx].tag,snoopaddr.idx,3'b000};
					dmif.dstore = frame_b[snoopaddr.idx].data[0];
			end
	 end

	 SNOOP_WB2: begin
      dmif.dWEN = 1;
	    if (frame_a[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame a
					dmif.daddr = {frame_a[snoopaddr.idx].tag,snoopaddr.idx,3'b100};
					dmif.dstore = frame_a[snoopaddr.idx].data[1];
					next_frame_a[prev_snoopaddr.idx].valid = '1;
					next_frame_a[prev_snoopaddr.idx].data[0] = dmif.dload;

			end
			else if (frame_b[snoopaddr.idx].tag == snoopaddr.tag) begin //the address exists in frame b
					dmif.daddr = {frame_b[snoopaddr.idx].tag,snoopaddr.idx,3'b100};
					dmif.dstore = frame_b[snoopaddr.idx].data[1];
					next_frame_b[prev_snoopaddr.idx].valid = '1;
					next_frame_b[prev_snoopaddr.idx].data[0] = dmif.dload;
			end
	 end

	 WAIT: begin
	    if (frame_a[prev_snoopaddr.idx].tag == prev_snoopaddr.tag) begin //the address exists in frame a
					next_frame_a[prev_snoopaddr.idx].valid = '1;
					next_frame_a[prev_snoopaddr.idx].data[0] = dmif.dload;

			end
			else if (frame_b[prev_snoopaddr.idx].tag == prev_snoopaddr.tag) begin //the address exists in frame b
					next_frame_b[prev_snoopaddr.idx].valid = '1;
					next_frame_b[prev_snoopaddr.idx].data[0] = dmif.dload;
			end
	 end



   endcase

end


endmodule
