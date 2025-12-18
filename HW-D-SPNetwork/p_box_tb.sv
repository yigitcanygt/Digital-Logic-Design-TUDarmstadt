`timescale 1ns / 1ns

module p_box_tb; // Same as normal

  //**************** ADDITIONAL TESTING VALUES ****************//
  logic ERROR;  // Will be 1 if any test failed
  logic [7:0] expected_out;
  //***********************************************************//

  //********************* MODULE INPUTS ***********************//
  logic [7:0] in;
  //***********************************************************//

  //********************* MODULE OUTPUTS **********************//
  logic [7:0] out;
  //***********************************************************//

  //******************* UUT INSTANTIATION *********************//
  p_box uut(.I(in),
    		.O(out));
  //***********************************************************//

  //********************* TEST INITIATION *********************//
  initial begin
    $dumpfile("p_box_tb.vcd");
    $dumpvars;

    // Initialize Additional Testing Values
    ERROR = 1'b0;

    $display("************* STARTING SIMULATION *************");

    // exhaustive test
    for (int i = 0; i < 256; i++) begin
	    in = i;
        expected_out = {in[2],in[3],in[6],in[1],in[4],in[7],in[0],in[5]};
        #1;
		if (out !== expected_out) begin
		    $display("Test for I=%b: Expected O=%b, but got O=%b", in, expected_out, out);
            ERROR = 1'b1;
	    end	
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
