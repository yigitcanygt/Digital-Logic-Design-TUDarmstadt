`timescale 1ns / 1ns

module simple_fsm

  ( input logic   CLK,
    input logic   RESET,
    input logic   START,
    input logic   B, // FSM input
    input logic   C, // FSM input

    output logic OUT);   // FSM output

  // states encoded as 2-bit vector: S0=00, S1=01, ...
  logic [1:0] state, nextstate;

/* ====================================== INSERT CODE HERE ====================================== */
always_ff @(posedge CLK) begin
  if (RESET)
    state <= 2'b00;
  else
    state <= nextstate;
end

always_comb begin
  nextstate = state;
  OUT = 1'b0;

  case (state)

    2'b00: begin // S0
      if (START)
        nextstate = 2'b01;
    end

    2'b01: begin // S1
      if (B)
        nextstate = 2'b10;
      else if (C)
        nextstate = 2'b11;
    end

    2'b10: begin // S2
      if (C)
        nextstate = 2'b11;
    end

    2'b11: begin // S3
      OUT = 1'b1;
      nextstate = 2'b00;
    end

  endcase
end
/* ============================================================================================== */

endmodule
