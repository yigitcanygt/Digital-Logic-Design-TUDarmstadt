`timescale 1ns / 1ns

module divider_tb;

  // Prepare module inputs and outputs, more values if needed, instantiate UUT

  // Module inputs
  logic [7:0] X;
  logic       CLK, SET;

  // Module outputs
  logic [7:0] Y;

  // UUT instantiation
  divider uut(  .X(X),
                .CLK(CLK),
                .SET(SET),
                .Y(Y));

  // Run the tests:
  initial begin
    $dumpfile("divider_tb.vcd");
    $dumpvars;

    $display("************* STARTING SIMULATION *************");

/* ====================================== INSERT CODE HERE ====================================== */



/* ============================================================================================== */

    $display("************* SIMULATION COMPLETE *************");
    $finish;
  end

  // Ignore this, this will only terminate your testbench if it takes too long
  // Make sure you do not use too large delays and that there is no endless loop somewhere!
  initial begin
    #(100000);
    $display("**** SIMULATION TOOK TOO LONG, STOPPING NOW ***");
    $finish;
  end
	
endmodule
