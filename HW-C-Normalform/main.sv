`timescale 1ns / 1ns

module main

    ( input logic  A,
      input logic  B,
      input logic  C,
      input logic  D,
      input logic  E,

      output logic  Y);

/* ====================================== INSERT CODE HERE ====================================== */
logic lut_out;
logic gate1_out;
logic gate2_out;
always_comb begin
  case({A, B, C, D, E})
      5'b00111: lut_out = 1'b1;
      5'b01101: lut_out = 1'b1;
      5'b01111: lut_out = 1'b1;
      5'b10000: lut_out = 1'b1;
      5'b10110: lut_out = 1'b1;
      5'b11011: lut_out = 1'b1;
      5'b11101: lut_out = 1'b1;
      default:  lut_out = 1'b0;
    endcase
  end
  gadget g1 (
    .A(B),
    .B(lut_out),
    .C(D),
    .Y(gate1_out)
   );
  gadget g2(
    .A(gate1_out),
    .B(A),
    .C(E),
    .Y(gate2_out)
   );
   assign Y = lut_out & gate2_out;    
/* ============================================================================================== */

endmodule
