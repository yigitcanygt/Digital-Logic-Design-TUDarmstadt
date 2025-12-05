`timescale 1ns / 1ns

module main_tb;

  //**************** ADDITIONAL TESTING VALUES ****************//
  logic         ERROR;            // Will be 1 if any test failed
  //***********************************************************//

  //********************* MODULE INPUTS ***********************//
  logic  A;
  logic  B;
  logic  C;
  logic  D;
  logic  E;

  //***********************************************************//


  //********************* MODULE OUTPUTS **********************//
  logic  Y;
  //***********************************************************//

  //******************* UUT INSTANTIATION *********************//
  main uut (.A(A),
            .B(B),
            .C(C),
            .D(D),
            .E(E),
            .Y(Y)
  );
  //***********************************************************//

  //********************* TEST INITIATION *********************//
  initial begin
    $dumpfile("main_tb.vcd");
    $timeformat(-9, 0, " ns", 8);
    $dumpvars;

    // Initialize Additional Testing Values
    ERROR = 1'b0;

    // Initialize Inputs
    A  = 0;
    B  = 0;
    C  = 0;
    D  = 0;
    E  = 0;

    $display("************* STARTING SIMULATION *************");

    #1;

    // alle möglichen Kombinationen testen
    check_main(0,0,0,0,0,    0);
    check_main(0,0,0,0,1,    0);
    check_main(0,0,0,1,0,    0);
    check_main(0,0,0,1,1,    0);

    check_main(0,0,1,0,0,    0);
    check_main(0,0,1,0,1,    0);
    check_main(0,0,1,1,0,    0);
    check_main(0,0,1,1,1,    1);

    check_main(0,1,0,0,0,    0);
    check_main(0,1,0,0,1,    0);
    check_main(0,1,0,1,0,    0);
    check_main(0,1,0,1,1,    0);

    check_main(0,1,1,0,0,    0);
    check_main(0,1,1,0,1,    1);
    check_main(0,1,1,1,0,    0);
    check_main(0,1,1,1,1,    0);

    check_main(1,0,0,0,0,    0);
    check_main(1,0,0,0,1,    0);
    check_main(1,0,0,1,0,    0);
    check_main(1,0,0,1,1,    0);

    check_main(1,0,1,0,0,    0);
    check_main(1,0,1,0,1,    0);
    check_main(1,0,1,1,0,    1);
    check_main(1,0,1,1,1,    0);

    check_main(1,1,0,0,0,    0);
    check_main(1,1,0,0,1,    0);
    check_main(1,1,0,1,0,    0);
    check_main(1,1,0,1,1,    1);

    check_main(1,1,1,0,0,    0);
    check_main(1,1,1,0,1,    0);
    check_main(1,1,1,1,0,    0);
    check_main(1,1,1,1,1,    0);


    #1;

    $display("************* SIMULATION COMPLETE *************");

    if (ERROR == 0) begin
      $display("SUCCESS! All tests succeeded :)");
    end else begin
      $display("THERE WERE ERRORS");
    end

    $finish;
  end

  //***********************************************************//

  //********************* SIMULATION TASKS ********************//
  task check_main (input a, input b, input c, input d, input e, input expected_y);
    A = a;
    B = b;
    C = c;
    D = d;
    E = e;
    #1
    if (Y == expected_y) begin
        // $display("Test for A %b, B %b, C %b, D %b, E %b:           success", a, b, c, d, e);
    end else begin
        $display("Test for A %b, B %b, C %b, D %b, E %b:           ERROR, expected Y %b, got %b", a, b, c, d, e, expected_y, Y);
        ERROR = 1'b1;
    end
  endtask

  //***********************************************************//

endmodule
