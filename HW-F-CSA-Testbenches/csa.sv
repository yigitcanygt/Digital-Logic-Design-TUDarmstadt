`timescale 1ns / 1ns

module csa

    #(parameter N = 16) // assume here that N is a power of 2, i.e., 1, 2, 4, 8, 16, 32, ...

    ( input   logic [N-1:0] A,      // Operand A
      input   logic [N-1:0] B,      // Operand B
      input   logic         C_i,   // Carry-In
      output  logic [N-1:0] S,    // Sum
      output  logic         C_o); // Carry-Out

/* ====================================== INSERT CODE HERE ====================================== */
generate
    if (N == 1) begin : base_case
        // Base case: single bit full adder
        fa fa_inst (
            .A   (A[0]),
            .B   (B[0]),
            .C_i (C_i),
            .S   (S[0]),
            .C_o (C_o)
        );
    end else begin : recursive_case
        localparam HALF = N/2;

        // Split inputs
        logic [HALF-1:0] S_low;
        logic [HALF-1:0] S_high0, S_high1;
        logic C_low;
        logic C_high0, C_high1;

        // Lower half with real carry in
        csa #(.N(HALF)) csa_low (
            .A   (A[HALF-1:0]),
            .B   (B[HALF-1:0]),
            .C_i (C_i),
            .S   (S_low),
            .C_o (C_low)
        );

        // Upper half assuming carry = 0
        csa #(.N(HALF)) csa_high0 (
            .A   (A[N-1:HALF]),
            .B   (B[N-1:HALF]),
            .C_i (1'b0),
            .S   (S_high0),
            .C_o (C_high0)
        );

        // Upper half assuming carry = 1
        csa #(.N(HALF)) csa_high1 (
            .A   (A[N-1:HALF]),
            .B   (B[N-1:HALF]),
            .C_i (1'b1),
            .S   (S_high1),
            .C_o (C_high1)
        );

        // Combine results
        assign S[HALF-1:0] = S_low;
        assign S[N-1:HALF] = C_low ? S_high1 : S_high0;
        assign C_o         = C_low ? C_high1 : C_high0;
    end
endgenerate
/* ============================================================================================== */

endmodule

module fa
    ( input  logic A,      // Operand A
      input  logic B,      // Operand B
      input  logic C_i,   // Carry-In
      output logic S,    // Sum
      output logic C_o); // Carry-Out

  assign S = A ^ B ^ C_i;
  assign C_o = A & B | (A | B) & C_i;

endmodule
