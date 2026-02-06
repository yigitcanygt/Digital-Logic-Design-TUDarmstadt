`timescale 1ns / 1ns

module multiplier
    ( input   logic [31:0] X,
      input   logic [31:0] Y,
      output  logic [31:0] Z,
      output  logic        O); // Overflow bit, if O=1, Z can be anything

  // Did you expect this to contain some actual fancy multiplier code and not just the lazy way? :P
  logic [63:0] product;
  assign product = X * Y;
  assign Z = product[31:0];
  assign O = | (product[63:32]);

endmodule
