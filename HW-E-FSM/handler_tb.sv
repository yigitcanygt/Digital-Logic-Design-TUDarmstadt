`timescale 1ns / 1ns

module handler_tb;

  //****************** SIMULATION PARAMETERS ******************//
localparam    CLK_PERIOD       =    10;  // [ns]
localparam    CLK_PERIOD_HALF = CLK_PERIOD/2;

  //***********************************************************//

  //**************** ADDITIONAL TESTING VALUES ****************//
  logic         ERROR;              // Will be 1 if any test failed
  logic         ok;                     // Flag for single tests
  logic [3:0]  testnum;          // to check where we are in the sim
  //***********************************************************//

  //********************* MODULE INPUTS ***********************//
  logic         CLK;
  logic         RESET;
  logic         START;  // FSM inputs
  logic         MODE;
  logic         CLEAR;
  logic         A;
  logic         B;
  logic         C;


  //***********************************************************//

  //********************* MODULE OUTPUTS **********************//
  logic         DONE;            // FSM output
  //***********************************************************//

  //******************* UUT INSTANTIATION *********************//
  handler uut(
                  .CLK(CLK),
                  .RESET(RESET),
                  .START(START),
                  .MODE(MODE),
                  .CLEAR(CLEAR),
                  .A(A),
                  .B(B),
                  .C(C),
                  .DONE(DONE)
                );
  //***********************************************************//

  //******************* CLOCK SIGNAL *******************//
  always begin
    #(CLK_PERIOD_HALF) CLK = ~CLK;
  end
  //***********************************************************//

  //********************* TEST INITIATION *********************//
  initial begin
    $dumpfile("handler_tb.vcd");
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
    for (int i=0; i<64; ++i) begin
        checkinit(i);
    end
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 1: Sanity check that all states are indeed reachable for handler ###");
    testnum = 4'b1;
    ok = 1'b1;
    reach_state(1);
    checkfsm(0,0,1);
    reach_state(2);
    checkfsm(0,0,2);
    reach_state(3);
    checkfsm(0,0,3);
    reach_state(4);
    checkfsm(0,1,4);
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 2: Correct behavior in initial state ###");
    testnum = 2;
    ok = 1'b1;
    // {START, MODE, CLEAR, A, B, C}
    for (int i=0; i<64; ++i) begin
      reset_fsm();
      setinputs(i);
      #(CLK_PERIOD);
      if (i[5] === 0) begin
        // start = 0 -> stay in S0, no outputs
        checkfsm(0,0,0);
      end else begin
        // start = 1 -> go to S1, still no outputs yet
        checkfsm(0,0,1);
      end
    end
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 3: Correct behavior in S1 (Fetch Mode) ###");
    testnum = 3;
    ok = 1'b1;
    // {START, MODE, CLEAR, A, B, C}
    for (int i=0; i<64; ++i) begin
        reach_state(1);
        setinputs(i);
        #(CLK_PERIOD);
        if (i[4] === 1) begin
            // mode = 1 -> go to S3
            checkfsm(1,0,3);
        end else begin
            // mode = 0 -> go to S2
            checkfsm(1,0,2);
        end
    end
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 4: From S2 (Simple FSM), Simple FSM Subroutine works ###");
    testnum = 4;
    ok = 1'b1;
    // {START, MODE, CLEAR, A, B, C}
    reach_state(2);
    #(CLK_PERIOD);
    B = 1;
    #(CLK_PERIOD);
    C = 1;
    #(CLK_PERIOD);
    #(CLK_PERIOD);
    checkfsm(2,1,4);
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 5: From S3 (Advanced FSM), Advanced FSM Subroutine works ###");
    testnum = 5;
    ok = 1'b1;
    // {START, MODE, CLEAR, A, B, C}
    reach_state(3);
    #(CLK_PERIOD);
    A = 0;
    B = 0;
    C = 1;
    #(CLK_PERIOD);
    #(CLK_PERIOD);
    A = 1;
    #(CLK_PERIOD);
    B = 1;
    #(CLK_PERIOD);
    #(CLK_PERIOD);
    checkfsm(3,1,4);
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 8: From S4 (Output), return to initial state with CLEAR ###");
    testnum = 6;
    ok = 1'b1;
    // {START, MODE, CLEAR, A, B, C}
    for (int i=0; i<64; ++i) begin
      reach_state(4);
      setinputs(i);
      #(CLK_PERIOD);
      if (i[3] === 1) begin
        checkfsm(4,0,0);
      end else begin
        checkfsm(4,1,4);
      end
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
  START = 0;
  MODE = 0;
  CLEAR = 0;
  A = 0;
  B = 0;
  C = 0;
  #(CLK_PERIOD);
  RESET = 1;
  #(CLK_PERIOD);
  RESET = 0;
endtask // reset_fsm

// {START, MODE, CLEAR, A, B, C}
// {vals[5], vals[4], vals[3], vals[2], vals[1], vals[0]}
task setinputs(input [5:0] vals);
    START = vals[5];
    MODE = vals[4];
    CLEAR = vals[3];
    A = vals[2];
    B = vals[1];
    C = vals[0];
endtask

task checkfsm(input [2:0] starting_state, input expected_out, input [2:0] expected_state);
  if (DONE === expected_out) begin
  end else begin
    $display("Expected FSM output DONE to be %b, but is %b, for {START, MODE, CLEAR, A, B, C} = {%b, %b, %b, %b, %b, %b} in state %d", expected_out, DONE, START, MODE, CLEAR, A, B, C, starting_state);
    ok=0;
    ERROR=1;
  end
  if (uut.state === expected_state) begin
  end else begin
    $display("Expected FSM to be in state %d, but is %d, for {START, MODE, CLEAR, A, B, C} = {%b, %b, %b, %b, %b, %b} from state %d", expected_state, uut.state, START, MODE, CLEAR, A, B, C, starting_state);
    ok=0;
    ERROR=1;
  end
endtask

task reach_state(input [2:0] s);
  // reset FSM for S0
  reset_fsm();
  // S0 -> S1 Transition via START + 1 CLK period
  if (s > 0) begin
    START = 1;
    #(CLK_PERIOD);
    START = 0;
    // S1->S3 (advanced)
    if (s === 3) begin
      MODE = 1;
      #(CLK_PERIOD);
    end
    // S1->S2 (simple)
    else if (s === 2 | s === 4) begin
      MODE = 0;
      #(CLK_PERIOD);
      // S2->S4 (output)
      if (s === 4) begin
        B = 0;
        C = 1;
        #(CLK_PERIOD);
        #(CLK_PERIOD);
        #(CLK_PERIOD);
      end
    end

  end
  if (s > 4) begin
    // This should never happen
    $display("TESTBENCH ERROR -- invalid state: %d!", s);
    ok=0;
    ERROR=1;
  end
endtask

task checkinit(input [5:0] vals);
  setinputs(vals);
  RESET=1;
  #(CLK_PERIOD);
  RESET = 0;
  #(CLK_PERIOD_HALF);
  checkfsm(0, 0, 0);
  #(CLK_PERIOD_HALF);
endtask

//***********************************************************//

endmodule
