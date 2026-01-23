`timescale 1ns / 1ns

/*
    S0 = Init
    S1 = Fetch Mode
    S2 = Simple FSM
    S3 = Advanced FSM
    S4 = Output
*/

module handler

  ( input logic   CLK,
    input logic   RESET,
    input logic   START,   // FSM inputs
    input logic   MODE,
    input logic   CLEAR,
    input logic   A,
    input logic   B,
    input logic   C,
    output logic  DONE);   // FSM output

  // states encoded as 3-bit vector: S0=000, S1=001,...
  logic [2:0] state, nextstate;
  logic simple_start, simple_out, advanced_start, advanced_out;

/* ====================================== INSERT CODE HERE ====================================== */
// state encoding
  localparam logic [2:0]
    S0 = 3'b000,   // Init
    S1 = 3'b001,   // Fetch Mode
    S2 = 3'b010,   // Simple FSM
    S3 = 3'b011,   // Advanced FSM
    S4 = 3'b100;   // Output

  logic [2:0] prev_state;

  // sub-FSM instantiations
  // simple_fsm has 6 ports and NO 'A' input
  simple_fsm sim_fsm (
    .CLK   (CLK),
    .RESET (RESET),
    .START (simple_start),
    .B     (B),
    .C     (C),
    .OUT   (simple_out)
  );

  // advanced_fsm has 7 ports and uses A,B,C
  advanced_fsm adv_fsm (
    .CLK   (CLK),
    .RESET (RESET),
    .START (advanced_start),
    .A     (A),
    .B     (B),
    .C     (C),
    .OUT   (advanced_out)
  );

  // state register + prev_state
  always_ff @(posedge CLK or posedge RESET) begin
    if (RESET) begin
      state      <= S0;
      prev_state <= S0;
    end else begin
      prev_state <= state;
      state      <= nextstate;
    end
  end

  // next-state + outputs + sub-start pulses
  always_comb begin
    // defaults
    nextstate      = state;
    DONE           = 1'b0;

    // START pulses only on entry into S2/S3
    simple_start   = 1'b0;
    advanced_start = 1'b0;

    case (state)
      S0: begin
        if (START) nextstate = S1;
      end

      S1: begin
        if (MODE) nextstate = S3;
        else      nextstate = S2;
      end

      S2: begin
        // pulse START when entering S2
        if (prev_state != S2) simple_start = 1'b1;
        if (simple_out) nextstate = S4;
      end

      S3: begin
        // pulse START when entering S3
        if (prev_state != S3) advanced_start = 1'b1;
        if (advanced_out) nextstate = S4;
      end

      S4: begin
        DONE = 1'b1;
        if (CLEAR) nextstate = S0;
      end

      default: begin
        nextstate = S0;
      end
    endcase
  end
/* ============================================================================================== */

endmodule
