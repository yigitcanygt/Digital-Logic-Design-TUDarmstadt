`timescale 1ns / 1ns

module funktion

    ( input  logic  A, B, C,

      output logic  Z);

  logic X, Y;

  assign X = (A | B | ~C) & (A ^ B);
  assign Y = (A | B | C) & (~A | B | ~C);
  assign Z = (~A | ~B | C) & Y;

endmodule
