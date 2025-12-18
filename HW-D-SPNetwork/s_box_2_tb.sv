`timescale 1ns / 1ns

module s_box_2_tb; // Same as normal

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
  s_box_2 uut(.I(in),
    		      .O(out));
  //***********************************************************//

  //********************* TEST INITIATION *********************//
  initial begin
    $dumpfile("s_box_2_tb.vcd");
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
  task sub(input logic [3:0] bits, output logic [3:0] sub_bits);
    begin
      case (bits)
          0: sub_bits = 4'd0;
          1: sub_bits = 4'd7;
          2: sub_bits = 4'd14;
          3: sub_bits = 4'd1;
          4: sub_bits = 4'd5;
          5: sub_bits = 4'd11;
          6: sub_bits = 4'd8;
          7: sub_bits = 4'd2;
          8: sub_bits = 4'd3;
          9: sub_bits = 4'd10;
         10: sub_bits = 4'd13;
         11: sub_bits = 4'd6;
         12: sub_bits = 4'd15;
         13: sub_bits = 4'd12;
         14: sub_bits = 4'd4;
         15: sub_bits = 4'd9;
        default: sub_bits = 4'd0;
      endcase
    end
  endtask
  //***********************************************************//
endmodule
