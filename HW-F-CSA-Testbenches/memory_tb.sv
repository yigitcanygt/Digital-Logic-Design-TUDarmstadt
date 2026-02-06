`timescale 1ns / 1ns

module memory_tb;

  // Prepare module inputs and outputs, more values if needed, instantiate UUT

  // Module inputs
  logic D, CLK;

  // Module outputs
  logic Q;

  // UUT instantiation
  memory uut( .D(D),
              .CLK(CLK),
              .Q(Q));

  // Run the tests:
  initial begin
    $dumpfile("memory_tb.vcd");
    $dumpvars;

    $display("************* STARTING SIMULATION *************");

/* ====================================== INSERT CODE HERE ====================================== */
    CLK = 0;
    D = 0;
    #10;

    CLK = 1;
    #5;
    
   
    D = 1;
    #5;

    // 4. Analysis and output
    if (Q === 1'b1) begin
        $display("RESULT: When CLK=1, the change at the input was reflected at the output. This is a D-LATCH.");
    end else if (Q === 1'b0) begin
        $display("RESULT: Although CLK=1, the input change did not affect the output. This is a D-FLIP-FLOP.");
    end else begin
        $display("RESULT: Uncertainty (X or Z).");
    end


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
