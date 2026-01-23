`timescale 1ns / 1ns

module advanced_fsm

  ( input logic   CLK,
    input logic   RESET,
    input logic   START, // FSM input
    input logic   A, B, C, // FSM input
    output logic  OUT); // FSM output

  // states encoded as 3-bit vector: S0=000, S1=001,...
  logic [2:0] state, nextstate;

/* ====================================== INSERT CODE HERE ====================================== */
  // State encoding
  localparam [2:0] S0 = 3'b000;
  localparam [2:0] S1 = 3'b001;
  localparam [2:0] S2 = 3'b010;
  localparam [2:0] S3 = 3'b011;
  localparam [2:0] S4 = 3'b100;
  localparam [2:0] S5 = 3'b101;
  localparam [2:0] S6 = 3'b110;
  localparam [2:0] S7 = 3'b111;

  // next output (registered output)
  logic nextout;

  // State + Output register (IMPORTANT: OUT is registered!)

  always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
      state <= S0;
      OUT   <= 1'b0;
    end else begin
      state <= nextstate;
      OUT   <= nextout;
    end
  end

  // Next-state and next-output logic (combinational)
  // Derived 1:1 from advanced_fsm_tb.sv
  always @(*) begin
    // defaults
    nextstate = state;
    nextout   = 1'b0;

    case (state)
      // S0
      S0: begin
        if (START) nextstate = S1;
        else       nextstate = S0;
        nextout = 1'b0; // always 0 in S0
      end

      // S1
      // if C=0: OUT=1 and go S5
      // else if A=0,B=0,C=1: go S2 (OUT=0)
      // else if A=1,B=1,C=1: go S3 (OUT=0)
      S1: begin
        if (C == 1'b0) begin
          nextstate = S5;
          nextout   = 1'b1;
        end else if ((A == 1'b0) && (B == 1'b0)) begin
          nextstate = S2;
          nextout   = 1'b0;
        end else if ((A == 1'b1) && (B == 1'b1)) begin
          nextstate = S3;
          nextout   = 1'b0;
        end else begin
          // not checked by TB -> keep safe, no output
          nextstate = S1;
          nextout   = 1'b0;
        end
      end

      // S2
      // if B=1 -> S3
      // else if C=1 -> S4
      // else stay S2
      // OUT always 0
      S2: begin
        if (B == 1'b1)      nextstate = S3;
        else if (C == 1'b1) nextstate = S4;
        else                nextstate = S2;
        nextout = 1'b0;
      end

      // S3
      // if C=1 -> S4 else -> S6
      // OUT always 0
      S3: begin
        if (C == 1'b1) nextstate = S4;
        else           nextstate = S6;
        nextout = 1'b0;
      end

      // S4
      // if (A=1) OR (B=0 AND C=1) -> S6
      // else stay S4
      // OUT always 0
      S4: begin
        if ((A == 1'b1) || ((B == 1'b0) && (C == 1'b1)))
          nextstate = S6;
        else
          nextstate = S4;
        nextout = 1'b0;
      end

      // S5
      // always go to S0, OUT=0
      S5: begin
        nextstate = S0;
        nextout   = 1'b0;
      end

      // S6
      // if (A=1 & B=1) OR (B=0 & C=0) -> go S5 and OUT=1
      // else stay S6 and OUT=0
      S6: begin
        if (((A == 1'b1) && (B == 1'b1)) || ((B == 1'b0) && (C == 1'b0))) begin
          nextstate = S5;
          nextout   = 1'b1;
        end else begin
          nextstate = S6;
          nextout   = 1'b0;
        end
      end

      // S7 / default
      default: begin
        nextstate = S0;
        nextout   = 1'b0;
      end
    endcase
  end
/* ============================================================================================== */

endmodule
