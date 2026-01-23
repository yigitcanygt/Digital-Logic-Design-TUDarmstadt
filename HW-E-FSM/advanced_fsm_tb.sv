`timescale 1ns / 1ns

module advanced_fsm_tb;

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
  logic         START;      // FSM input
  logic         A;          // FSM input
  logic         B;          // FSM input
  logic         C;          // FSM input
  //***********************************************************//

  //********************* MODULE OUTPUTS **********************//
  // FSM output
  logic         OUT;
  //***********************************************************//

  //******************* UUT INSTANTIATION *********************//
  advanced_fsm uut(
                  .CLK(CLK),
                  .RESET(RESET),
                  .START(START),
                  .A(A),
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
    $dumpfile("advanced_fsm_tb.vcd");
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
    for (int i=0; i<32; ++i) begin
        checkinit(i);
    end
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 1: Correct behavior in initial state ###");
    testnum = 1;
    ok = 1'b1;
    // setinputs:
    // setinputs: {START, A, B, C} -- {vals[3], vals[2], vals[1], vals[0]}
    for (int i=0; i<16; ++i) begin
        // start = 0 -> stay in S0, so no outputs
        reset_fsm();
        setinputs(i);
        #(CLK_PERIOD);
        if (i[3] === 1) begin // START = 1
            // checkfsm(input [2:0] starting_state, input expected_out, input [2:0] expected_state)
            checkfsm(0,0,1);
        end else begin // START = 0
            checkfsm(0,0,0);
        end
    end

    if (ok) begin
      $display("success");
    end

    $display("### Starting test 2: Correct behavior in S1 ###");
    testnum = 2;
    ok = 1'b1;
    for (int i=0; i<16; ++i) begin
        reach_state(1);
        setinputs(i);
        #(CLK_PERIOD);
        if (i[0] === 0) begin // C = 0
            checkfsm(1,1,5);
        end else if (i[2] === 0 && i[1] === 0) begin // A = B = 0 and C = 1 implicit
            checkfsm(1,0,2);
        end else if (i[2] === 1 && i[1] === 1) begin // A = B = 1 and C = 1 implicit
            checkfsm(1,0,3);
        end
    end
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 3: Correct behavior in S2 ###");
    testnum = 3;
    ok = 1'b1;
    for (int i=0; i<16; ++i) begin
        reach_state(2);
        setinputs(i);
        #(CLK_PERIOD);
        if (i[1] === 1) begin // B = 1
            checkfsm(2,0,3);
        end else if (i[0] === 1) begin // C = 1, B = 0 implicit
            checkfsm(2,0,4);
        end else begin // stay in S2
            checkfsm(2,0,2);
        end
    end
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 4: Correct behavior in S3 ###");
    testnum = 4;
    ok = 1'b1;
    for (int i=0; i<16; ++i) begin
        reach_state(3);
        setinputs(i);
        #(CLK_PERIOD);
        if (i[0] === 1) begin // C = 1
            checkfsm(3,0,4);
        end else begin // C = 0
            checkfsm(3,0,6);
        end
    end
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 5: Correct behavior in S4 ###");
    testnum = 5;
    ok = 1'b1;
    for (int i=0; i<16; ++i) begin
        reach_state(4);
        setinputs(i);
        #(CLK_PERIOD);
        if ((i[2] === 1) || ((i[1] === 0) && (i[0] === 1))) begin
            checkfsm(4,0,6);
        end else begin
            checkfsm(4,0,4);
        end
    end
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 6: Correct behavior in S5 ###");
    testnum = 6;
    ok = 1'b1;
    for (int i=0; i<16; ++i) begin
        reach_state(5);
        setinputs(i);
        #(CLK_PERIOD);
        checkfsm(5,0,0); // always go to S0
    end
    if (ok) begin
      $display("success");
    end

    $display("### Starting test 7: Correct behavior in S6 ###");
    testnum = 7;
    ok = 1'b1;
    for (int i=0; i<16; ++i) begin
        reach_state(6);
        setinputs(i);
        #(CLK_PERIOD);
        if (i[2] === 1 & i[1] === 1 | i[1] === 0 & i[0] === 0) begin
            checkfsm(6,1,5);
        end else begin
            checkfsm(6,0,6);
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
    A=0;
    B=0;
    C=0;
    START=0;
    #(CLK_PERIOD);
    RESET = 1;
    #(CLK_PERIOD);
    RESET = 0;
endtask

// {START, A, B, C}
// {vals[3], vals[2], vals[1], vals[0]}
task setinputs(input [3:0] vals);
  START = vals[3];
  A = vals[2];
  B = vals[1];
  C = vals[0];
endtask

task checkfsm(input [2:0] starting_state, input expected_out, input [2:0] expected_state);
  if (OUT === expected_out) begin
  end else begin
    $display("Expected FSM output OUT to be %b, but is %b, for {START, A, B, C} = {%b, %b, %b, %b} in state %d", expected_out, OUT, START, A, B, C, starting_state);
    ok=0;
    ERROR=1;
  end
  if (uut.state === expected_state) begin
  end else begin
    $display("Expected FSM to be in state %d, but is %d, for {START, A, B, C} = {%b, %b, %b, %b} from state %d", expected_state, uut.state, START, A, B, C, starting_state);
    ok=0;
    ERROR=1;
  end
endtask

task reach_state(input [2:0] s);
  // reset FSM for S0
  reset_fsm();
  // S0 -> S1: START = 1
  if (s > 0) begin
    START = 1;
    #(CLK_PERIOD);
    START = 0;
        // S1 -> S5: C=0
        if (s === 5) begin
            C = 0;
            #(CLK_PERIOD);
        end else begin
        // S1 -> S2: A=0, B=0, C=1
        if (s > 1) begin
            setinputs(1);
            #(CLK_PERIOD);
            // S2 -> S3: B=1
            if (s > 2) begin
                B = 1;
                #(CLK_PERIOD);
                // S3 -> S4: C=1
                if (s > 3) begin
                C = 1;
                #(CLK_PERIOD);
                    // S4 -> S6: A=1
                    if (s === 6) begin
                        A = 1;
                        #(CLK_PERIOD);
                    end else if (s > 6) begin
                        // This should never happen!
                        $display("TESTBENCH ERROR: invalid value for s: %d!", s);
                        ok=0;
                        ERROR=1;
                    end
                end
            end
        end
    end
end
endtask

task checkinit(input [3:0] vals);
  RESET = 1;
  START = vals[3];
  A = vals[2];
  B = vals[1];
  C = vals[0];
  #(CLK_PERIOD);
  RESET = 0;
  #(CLK_PERIOD_HALF);
  checkfsm(0, 0, 0);
  #(CLK_PERIOD_HALF);
endtask

//***********************************************************//

endmodule
