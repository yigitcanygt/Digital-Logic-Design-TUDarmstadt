`timescale 1ns / 1ns

module simple_fsm_tb;

  //****************** SIMULATION PARAMETERS ******************//
localparam    CLK_PERIOD = 10; // [ns]
localparam    CLK_PERIOD_HALF = CLK_PERIOD/2;

  //***********************************************************//

  //**************** ADDITIONAL TESTING VALUES ****************//
  logic         ERROR;          // Will be 1 if any test failed
  logic         ok;             // Flag for single tests
  logic [3:0]  testnum;         // to check where we are in the sim
  //***********************************************************//

  //********************* MODULE INPUTS ***********************//
  logic         CLK;
  logic         RESET;
  logic         START;          // FSM input
  logic         B;              // FSM input
  logic         C;              // FSM input
  //***********************************************************//

  //********************* MODULE OUTPUTS **********************//
  // FSM output
  logic         OUT;
  //***********************************************************//

  //******************* UUT INSTANTIATION *********************//
  simple_fsm uut(
                  .CLK(CLK),
                  .RESET(RESET),
                  .START(START),
                  .B(B),
                  .C(C),
                  .OUT(OUT));
  //***********************************************************//

  //******************* CLOCK SIGNAL *******************//
  always begin
    #(CLK_PERIOD_HALF) CLK = ~CLK;
  end
  //***********************************************************//

  //********************* TEST INITIATION *********************//
  initial begin
    $dumpfile("simple_tb.vcd");
    $timeformat(-1, 0, " ns", 8);
    $dumpvars;

    // Initialize Additional Testing Values
    ERROR = 1'b0;
    ok = 1'b1;
    testnum = 4'b0;

    // Initialize Inputs
    CLK         = 0;
    #(CLK_PERIOD * 0.6);
    RESET       = 1;
    #(CLK_PERIOD);
    RESET       = 0;

    $display("************* STARTING SIMULATION *************");

    #(CLK_PERIOD);

    $display("### Starting test 0: Correct initialization after RESET, no matter the input ###");
    testnum = 4'b0;
    ok = 1'b1;

    for (int i = 0; i < 8; i++) begin
        checkinit(i[0],i[1],i[2]);
    end
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 1: Correct behavior in initial state S0 ###");
    testnum = 1;
    ok = 1'b1;
    // start = 0 -> stay in S0, so no outputs
    for (int i = 0; i < 3; i++) begin
        reset_fsm();
        setinputs(0,i[1],i[0]);
        #(CLK_PERIOD);
        checkfsm(0,0,0);
    end
    // start = 1 -> go to S1, no outputs yet
    for (int i = 0; i < 3; i++) begin
        reset_fsm();
        setinputs(1,i[1],i[0]);
        #(CLK_PERIOD);
        checkfsm(0,0,1);
    end
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 2: Correct behavior in S1 ###");
    testnum = 2;
    ok = 1'b1;

    for (int i = 0; i < 8; i++) begin
        reach_state(1);
        setinputs(i[2],i[1],i[0]);
        #(CLK_PERIOD);
        if (i[1] === 1) begin // B = 1
            checkfsm(1,0,2);
        end else if (i[0] === 1) begin // B = 0 and C = 1
            checkfsm(1,1,3); // since we move to S3, we also expect OUT = 1
        end
    end
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 3: Correct behavior in S2 ###");
    testnum = 3;
    ok = 1'b1;

    for (int i = 0; i < 8; i++) begin
        reach_state(2);
        setinputs(i[2],i[1],i[0]);
        #(CLK_PERIOD);
        if (i[0] === 1) begin // C = 1
            checkfsm(2,1,3);
        end else begin // C = 0
            checkfsm(2,0,2);
        end
    end
    if (ok) begin
      $display("success");
    end


    $display("### Starting test 4: Correct behavior in S3 ###");
    testnum = 4;
    ok = 1'b1;

    for (int i = 0; i < 8; i++) begin
        reach_state(3);
        setinputs(i[2],i[1],i[0]);
        #(CLK_PERIOD);
        checkfsm(3,0,0);
    end
    if (ok) begin
      $display("success");
    end


    #(CLK_PERIOD);
    $display("************* SIMULATION COMPLETE *************");

    if (ERROR == 0) begin
      $display("All tests succeeded");
    end else begin
      $display("THERE WERE ERRORS");
    end

    $finish;
  end

  initial begin
    #(1000000*CLK_PERIOD)
    $display("************* SIMULATION KILLED BECAUSE OF TIMEOUT *************");
    $finish;
  end

  //***********************************************************//

  //********************* SIMULATION TASKS ********************//

task reset_fsm;
    B=0;
    C=0;
    START=0;
    #(CLK_PERIOD);
    RESET = 1;
    #(CLK_PERIOD);
    RESET = 0;
endtask

task setinputs(input start, b, c);
  START = start;
  B = b;
  C = c;
endtask

task checkfsm(input [1:0] starting_state, input expected_out, input [1:0] expected_state);
  if (OUT === expected_out) begin
  end else begin
    $display("Expected FSM output OUT to be %b, but is %b, for B = %b, C = %b, START = %b in state %d",
                expected_out, OUT, B, C, START, starting_state);
    ok=0;
    ERROR=1;
  end
  if (uut.state === expected_state) begin
  end else begin
    $display("Expected FSM to be in state %d, but is %d, for B = %b, C = %b, START = %b from state %d",
                expected_state, uut.state, B, C, START, starting_state);
    ok=0;
    ERROR=1;
  end
endtask

task reach_state(input [1:0] s);
  // reset FSM for S0
  reset_fsm();
  // S0 -> S1: START = 1 + 1 CLK period
  if (s > 0) begin
    START = 1;
    #(CLK_PERIOD);
    START = 0;
    // S1 -> S2: B = 1 + 1 CLK period
    if (s > 1) begin
        B = 1;
        #(CLK_PERIOD);
        // S2 -> S3: C = 1 + 1 CLK period
        if (s > 2) begin
            C = 1;
            #(CLK_PERIOD);
        end
    end
end
endtask

task checkinit(input start, b, c);
  RESET = 1;
  START = start;
  B = b;
  C = c;
  #(CLK_PERIOD);
  RESET = 0;
  #(CLK_PERIOD_HALF);
  checkfsm(0, 0, 0);
  #(CLK_PERIOD_HALF);
endtask

//***********************************************************//

endmodule
