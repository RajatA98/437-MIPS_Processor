`include "cpu_types_pkg.vh"
`include "caches_if.vh"
`include "cpu_ram_if.vh"
`include "cache_control_if.vh"
`timescale 1 ns / 1 ns

module memory_control_tb;

	import cpu_types_pkg::*;
	parameter PERIOD = 10;

	logic CLK = 0, nRST;
	always #(PERIOD/2) CLK++;
	// coherence interface
  caches_if                 cif0();
  // cif1 will not be used, but ccif expects it as an input
  caches_if                 cif1();
  cache_control_if    #(.CPUS(1))       ccif (cif0, cif1);
	
	//caches_if cif();
	cpu_ram_if rif();

	assign ccif.ramstate = rif.ramstate;
	assign ccif.ramload = rif.ramload;
	assign rif.ramaddr = ccif.ramaddr;
	assign rif.ramstore = ccif.ramstore;
	assign rif.ramREN = ccif.ramREN;
	assign rif.ramWEN = ccif.ramWEN;
	test PROG (CLK, nRST, ccif,rif);
	ram RAM(CLK, nRST, rif);

  memory_control DUT(CLK, nRST, ccif);

endmodule
program test(
	input logic CLK,
	output logic nRST,
	cache_control_if ccif,
	cpu_ram_if.ram rif
);
	task reset_dut;
	begin
		
		nRST = 1'b0;
		
		@(posedge CLK);
		@(posedge CLK);
		
		@(negedge CLK);
		
		nRST = 1;
		
		@(posedge CLK);
		@(posedge CLK);
	end
	endtask
	
	task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    
    cif0.daddr = 0;
    cif0.dWEN = 0;
    cif0.dREN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      cif0.daddr = i << 2;
      cif0.dREN = 1;
      repeat (4) @(posedge CLK);
      if (cif0.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif0.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif0.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      //cif0.tbCTRL = 0;
      cif0.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask
		

	int tb_test_num;
		string tb_test_case;
		parameter PERIOD = 10;
		initial 
	  begin

		nRST = 1'b1;
		tb_test_num = 0;
		tb_test_case ="Test bench initialization";
		#(0.1);
		cif0.dREN = 1'b0;
		cif0.dWEN = 1'b0;
		cif0.daddr = 1'b0;
		cif0.dstore = '0;
		cif0.iREN = 1'b0;
		cif0.iaddr = '0;
		
		//******************************************************************
		// Test Case 1: Write data to RAM
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Write data to RAM";

		reset_dut();
		#(PERIOD/2);
		cif0.dWEN = 1'b1;
		cif0.daddr = 32'hffffffc;
		cif0.dstore = 32'hffffffff;

		#(PERIOD*2); 
		if(cif0.dwait == 1'b0 && rif.ramstore == 32'hffffffff)
			$display("Correct Output");
		else
			$display("Error");
		

		//cif0.dREN = 1'b0;
		cif0.dWEN = 1'b0;
		//cif0.daddr = 1'b0;
		//cif0.dstore = '0;
		//cif0.iREN = 1'b0;
		//cif0.iaddr = '0;

	//******************************************************************
		// Test Case 2: Read data from RAM
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Read data from RAM";

		#(PERIOD/2);
		cif0.dREN = 1'b1;
		cif0.daddr = 32'hffffffc;
		#(PERIOD*2); 
		if(cif0.dwait == 1'b0 && cif0.dload == 32'hffffffff)
			$display("Correct Output");
		else
			$display("Error");
		

		cif0.dREN = 1'b0;
		/*cif0.dWEN = 1'b0;
		cif0.daddr = 1'b0;
		cif0.dstore = '0;
		cif0.iREN = 1'b0;
		cif0.iaddr = '0;*/
		
		//******************************************************************
		// Test Case 3: Write data to RAM 
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Write data to RAM";

		reset_dut();
		#(PERIOD/2);
		cif0.dWEN = 1'b1;
		cif0.daddr = 32'hfffffffc;
		cif0.dstore = 32'hffffffff;

		#(PERIOD*2); 
		if(cif0.dwait == 1'b0 && rif.ramstore == 32'hffffffff)
			$display("Correct Output");
		else
			$display("Error");
		
		//cif0.dREN = 1'b0;
		cif0.dWEN = 1'b0;
		//cif0.daddr = 1'b0;
		//cif0.dstore = '0;
		//cif0.iREN = 1'b0;
		//cif0.iaddr = '0;
		
	//******************************************************************
		// Test Case 4: Read instruction from RAM
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Read instruction from RAM";

		#(PERIOD/2);
		cif0.iREN = 1'b1;
		cif0.iaddr = 32'hfffffffc;
		#(PERIOD*2); 
		if(cif0.iwait == 1'b0 && cif0.iload == 32'hffffffff)
			$display("Correct Output");
		else
			$display("Error");
		/*cif0.dREN = 1'b0;
		cif0.dWEN = 1'b0;
		cif0.daddr = 1'b0;
		cif0.dstore = '0;*/
		cif0.iREN = 1'b0;
		//cif0.iaddr = '0;
	//******************************************************************
		// Test Case 5: Write data to RAM 
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Write data to RAM";

		#(PERIOD/2);
		cif0.dWEN = 1'b1;
		cif0.daddr = 32'h3;
		cif0.dstore = 32'hffffffff;

		#(PERIOD*2);
		if(cif0.dwait == 1'b0 && rif.ramstore == 32'hffffffff)
			$display("Correct Output");
		else
			$display("Error");

		//cif0.dREN = 1'b0;
		cif0.dWEN = 1'b0;
		//cif0.daddr = 1'b0;
		//cif0.dstore = '0;
		//cif0.iREN = 1'b0;
		//cif0.iaddr = '0;
		
	//******************************************************************
		// Test Case 6: Read data from RAM checking priority
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Read data from RAM";

		#(PERIOD/2);
		cif0.dREN = 1'b1;
		cif0.iREN = 1'b1;
		cif0.daddr = 32'h3;
		#(PERIOD*2);
		if(cif0.dwait == 1'b0 && cif0.dload == 32'hffffffff)
			$display("Correct Output");
		else
			$display("Error");
		cif0.dREN = 1'b0;
		cif0.dWEN = 1'b0;
		//cif0.daddr = 1'b0;
		//cif0.dstore = '0;
		//cif0.iREN = 1'b0;
		//cif0.iaddr = '0;

		//******************************************************************
		// Test Case 7: Write data to RAM
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Write data to RAM";

		#(PERIOD/2);
		cif0.dWEN = 1'b1;
		cif0.daddr = 32'h3;
		cif0.dstore = 32'h0;

		#(PERIOD*2); 
		if(cif0.dwait == 1'b0 && rif.ramstore == 32'h0)
			$display("Correct Output");
		else
			$display("Error");
		

		//cif0.dREN = 1'b0;
		cif0.dWEN = 1'b0;
		//cif0.daddr = 1'b0;
		//cif0.dstore = '0;
		//cif0.iREN = 1'b0;
		//cif0.iaddr = '0;

	//******************************************************************
		// Test Case 8: Read data from RAM
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Read data from RAM";

		#(PERIOD/2);
		cif0.iREN = 1'b1;
		cif0.iaddr = 32'h3;
		#(PERIOD*2); 
		if(cif0.iwait == 1'b0 && cif0.iload == 32'h0)
			$display("Correct Output");
		else
			$display("Error");
		

		cif0.dREN = 1'b0;
		/*cif0.dWEN = 1'b0;
		cif0.daddr = 1'b0;
		cif0.dstore = '0;
		cif0.iREN = 1'b0;
		cif0.iaddr = '0;*/
		//******************************************************************
		// Test Case 9: Write data to RAM
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Write data to RAM";

		#(PERIOD/2);
		cif0.dWEN = 1'b1;
		cif0.daddr = 32'h0;
		cif0.dstore = 32'h0;

		#(PERIOD*2); 
		if(cif0.dwait == 1'b0 && rif.ramstore == 32'h0)
			$display("Correct Output");
		else
			$display("Error");
		

		//cif0.dREN = 1'b0;
		cif0.dWEN = 1'b0;
		//cif0.daddr = 1'b0;
		//cif0.dstore = '0;
		//cif0.iREN = 1'b0;
		//cif0.iaddr = '0;

	//******************************************************************
		// Test Case 10: Read data from RAM
		//******************************************************************
		tb_test_num = tb_test_num + 1;
		tb_test_case = "Read data from RAM";

		#(PERIOD/2);
		cif0.iREN = 1'b1;
		cif0.iaddr = 32'h0;
		#(PERIOD*2); 
		if(cif0.iwait == 1'b0 && cif0.iload == 32'h0)
			$display("Correct Output");
		else
			$display("Error");
		

		cif0.dREN = 1'b0;
		/*cif0.dWEN = 1'b0;
		cif0.daddr = 1'b0;
		cif0.dstore = '0;
		cif0.iREN = 1'b0;
		cif0.iaddr = '0;*/
		
		
		reset_dut();
		dump_memory();
		$finish;
	end
endprogram
		
		
	
		
		
		
	
		
		

		

