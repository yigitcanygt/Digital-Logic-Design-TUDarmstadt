`timescale 1ns / 1ns

module s_box_1_tb; // Same as normal

  //**************** ADDITIONAL TESTING VALUES ****************//
  logic ERROR;  // Will be 1 if any test failed
  logic [3:0] expected_out;
  //***********************************************************//

  //********************* MODULE INPUTS ***********************//
  logic [3:0] in;
  //***********************************************************//

  //********************* MODULE OUTPUTS **********************//
  logic [3:0] out;
  //***********************************************************//

  //******************* UUT INSTANTIATION *********************//
  s_box_1 uut(.I(in),
    		      .O(out));
  //***********************************************************//

  //********************* TEST INITIATION *********************//
  initial begin
    $dumpfile("s_box_1_tb.vcd");
    $dumpvars;

    // Initialize Additional Testing Values
    ERROR = 1'b0;

    $display("************* STARTING SIMULATION *************");

    // exhaustive test
    for (int i = 0; i < 16; i++) begin
	    in = i;
      sub(i, expected_out); 
      #1;
		  if (out !== expected_out) begin
		    $display("Test for I=%d (%b): Expected O=%d (%b), but got O=%d (%b)", in, in, expected_out, expected_out, out, out);
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

  //********************* SIMULATION TASKS ********************//
  task sub(input logic[3:0] bits, output logic[3:0] sub_bits);
    begin
    case (bits)
          0: sub_bits = 4'd8;
          1: sub_bits = 4'd6;
          2: sub_bits = 4'd5;
          3: sub_bits = 4'd15;
          4: sub_bits = 4'd1;
          5: sub_bits = 4'd12;
          6: sub_bits = 4'd10;
          7: sub_bits = 4'd9;
          8: sub_bits = 4'd14;
          9: sub_bits = 4'd11;
         10: sub_bits = 4'd2;
         11: sub_bits = 4'd4;
         12: sub_bits = 4'd7;
         13: sub_bits = 4'd0;
         14: sub_bits = 4'd13;
         15: sub_bits = 4'd3;
          default: sub_bits = 4'd0;
    endcase
    end
  endtask
  //***********************************************************//
endmodule
