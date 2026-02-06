`timescale 1ns / 1ns

module multiplier_tb;

  // Prepare module inputs and outputs, more values if needed, instantiate UUT

/* ====================================== INSERT CODE HERE ====================================== */
 logic [31:0] X, Y, Z; logic O;
 multiplier UUT(.X(X), .Y(Y), .Z(Z), .O(O));
/* ============================================================================================== */

  // Run the tests:
  initial begin
    $dumpfile("multiplier_tb.vcd");
    $dumpvars;

    $display("************* STARTING SIMULATION *************");

/* ====================================== INSERT CODE HERE ====================================== */
  X = 13;
  Y = 37;

  #10;
  if (Z === 481) begin
    $display("Success for Z = %d . %d", X, Z);
  end else begin
    $display("Error for Z = %d . %d", X, Z);
  end
 
  for (logic[31:0] i = 0; i < 32; i ++) begin
    for(logic[31:0] k = 0; k < 32; k ++) begin
      X = i;
      Y = k;
      #10;
      if(i * k === Z) begin
        $display("Success for Z = %d * %d", X, Z);
  end else begin
    $display("Error for Z = %d * %d", X, Z);
  end
      end
  end      

  X = 60000;
  Y = 1000000;

  #10;

  if (O === 1) begin
        $display("Success: Overflow detected! (Z=%d, O=%b)", Z, O);
    end else begin
        $display("Fehler bei %t: Für X=%d, Y=%d wurde O=1 erwartet, aber O=%b erhalten!", $time, X, Y, O);    
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
