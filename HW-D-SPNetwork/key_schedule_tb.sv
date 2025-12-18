`timescale 1ns / 1ns

module key_schedule_tb; // Same as normal

  //**************** ADDITIONAL TESTING VALUES ****************//
  logic ERROR;              // Will be 1 if any test failed
  logic [7:0] expected_k0, expected_k1, expected_k2, expected_k3;
  //***********************************************************//

  //********************* MODULE INPUTS ***********************//
  logic [31:0] k;
  //***********************************************************//

  //********************* MODULE OUTPUTS **********************//
  logic [7:0] k0, k1, k2, k3;
  //***********************************************************//

  //******************* UUT INSTANTIATION *********************//
  key_schedule uut(.K(k),
    		           .K0(k0),
				           .K1(k1),
                   .K2(k2),
                   .K3(k3));
  //***********************************************************//

  //********************* TEST INITIATION *********************//
  initial begin
    $dumpfile("key_schedule_tb.vcd");
    $dumpvars;

    // Initialize Additional Testing Values
    ERROR = 1'b0;

    $display("************* STARTING SIMULATION *************");
    //all zeros
    k = 32'd0;
    expected_k0 = 8'd0;
    expected_k1 = 8'd0;
    expected_k2 = 8'd0;
    expected_k3 = 8'd0;
    #1;
		check();

    //all ones
    k = 32'hffffffff;
    expected_k0 = 8'hff;
    expected_k1 = 8'hff;
    expected_k2 = 8'hff;
    expected_k3 = 8'hff;
    #1;
		check();

    //input with ^k === 0
    k = 32'h57a336bc;
    expected_k0 = 8'h6b;
    expected_k1 = 8'h33;
    expected_k2 = 8'h7a;
    expected_k3 = 8'h5c;
    #1;
		check();

    //input with ^k === 1
    k = 32'h35ab674f;
    expected_k0 = 8'h4f;
    expected_k1 = 8'h67;
    expected_k2 = 8'hab;
    expected_k3 = 8'h35;
    #1;
		check();	
    

    $display("************* SIMULATION COMPLETE *************");  
    if (ERROR == 0) begin
        $display("All tests succeeded");
    end else begin
        $display("THERE WERE ERRORS");
    end
    $finish;
  end

  //***********************************************************//

  //********************* SIMULATION TASKS ********************//
  task check();
   if (k0 !== expected_k0 || k1 !== expected_k1 || k2 !== expected_k2 || k3 !== expected_k3) begin
      ERROR = 1'b1;
      if(^k) $display("ERROR in test for K %b (uneven number of 1's):", k); else $display("ERROR in test for K %b (even number of 1's):", k);
      if (k0 !== expected_k0) $display("K0: expected %b but got %b", expected_k0, k0); else $display("K0 ok.");
      if (k1 !== expected_k1) $display("K1: expected %b but got %b", expected_k1, k1); else $display("K1 ok.");
      if (k2 !== expected_k2) $display("K2: expected %b but got %b", expected_k2, k2); else $display("K2 ok.");
      if (k3 !== expected_k3) $display("K3: expected %b but got %b", expected_k3, k3); else $display("K3 ok.");
    end 
  endtask
  //***********************************************************//
endmodule
