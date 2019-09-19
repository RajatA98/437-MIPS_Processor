
module request_unit
(
	input logic CLK, nRST,
	//input from control unit
	input logic memtoReg, memWr,
	//input from cache
	input logic ihit, dhit,
	//output to cache
	output logic dREN, dWEN
);

	always_ff @(posedge CLK, negedge nRST)
	begin
		if(!nRST)
		begin
			dREN <= 1'b0;
			dWEN <= 1'b0;
		end
		else if(dhit)
		begin
			dREN <= 1'b0;
			dWEN <= 1'b0;
		end
		else if(ihit)
		begin
			dREN <= memtoReg;
			dWEN <= memWr;
		end
		else
		begin
			dREN <= dREN;
			dWEN <= dWEN;
		end
	end

endmodule

