`timescale 1ns / 1ns

module gadget

    ( input logic A,
      input logic B,
      input logic C,

      output logic  Y);

/* ======================================== EXAMPLE CODE ======================================== */

  assign Y = A ^ B ^ C;

/* ============================================================================================== */

endmodule
