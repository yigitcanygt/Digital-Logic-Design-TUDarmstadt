`timescale 1ns / 1ns

module sp_network_tb; // Same as normal

  //**************** ADDITIONAL TESTING VALUES ****************//
  logic ERROR;              // Will be 1 if any test failed
  logic [7:0] expected_c;
  //***********************************************************//

  //********************* MODULE INPUTS ***********************//
  logic [7:0] m;
  logic [31:0] k;
  //***********************************************************//

  //********************* MODULE OUTPUTS **********************//
  logic [7:0] c;
  //***********************************************************//

  //******************* UUT INSTANTIATION *********************//
  sp_network uut(.M(m),
                 .K(k),
                 .C(c));
  //***********************************************************//

  //********************* TEST INITIATION *********************//
  initial begin
    $dumpfile("sp_network_tb.vcd");
    $dumpvars;

    // Initialize Additional Testing Values
    ERROR = 1'b0;

    $display("************* STARTING SIMULATION *************");
    // Test 1 
    k = 32'h032bef67;
    m = 8'h4a;
    expected_c = 8'hd4;
    #1;
	if (c !== expected_c) begin
	    $display("Test for K=%b and M=%b: Expected C=%b, but got C=%b", k, m, expected_c, c);
        ERROR = 1'b1;
	end
    
    // Test 2
    k = 32'hcafecafe;
    m = 8'h15;
    expected_c = 8'h98;
    #1;
	if (c !== expected_c) begin
	    $display("Test for K=%b and M=%b: Expected C=%b, but got C=%b", k, m, expected_c, c);
        ERROR = 1'b1;
	end

    // Test 3
    k = 32'habba1972;
    m = 8'h2e;
    expected_c = 8'hae;
    #1;
	if (c !== expected_c) begin
	    $display("Test for K=%b and M=%b: Expected C=%b, but got C=%b", k, m, expected_c, c);
        ERROR = 1'b1;
	end

    // Test 4
    k = 32'hdeadbeef;
    m = 8'hf0;
    expected_c = 8'h8a;
    #1;
	if (c !== expected_c) begin
	    $display("Test for K=%b and K=%b: Expected C=%b, but got C=%b", k, m, expected_c, c);
        ERROR = 1'b1;
	end


    $display("************* SIMULATION COMPLETE *************");  
    if (ERROR == 0) begin
        $display("All tests succeeded");
    end else begin
        $display("THERE WERE ERRORS");
    end
    $finish;
  end

  //***********************************************************//

endmodule
