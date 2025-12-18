`timescale 1ns / 1ns

module sp_network

    ( input   logic [7:0] M,  // 8-bit message
      input   logic [31:0] K, // 32-bit key
      output  logic [7:0] C); // encrypted message

/* ====================================== INSERT CODE HERE ====================================== */
  // intermediate wires
    logic [7:0] K0, K1, K2, K3;

  logic [7:0] r1_xor, r1_sb, r1_p;
  logic [7:0] r2_xor, r2_sb, r2_p;
  logic [7:0] r3_xor, r3_sb;

  logic [3:0] r1_s1_out, r1_s2_out;
  logic [3:0] r2_s1_out, r2_s2_out;
  logic [3:0] r3_s1_out, r3_s2_out;
  // initialize key_schedule to determine round keys
  key_schedule ks (
      .K(K),
      .K0(K0),
      .K1(K1),
      .K2(K2),
      .K3(K3)
  );
  // first round
  assign r1_xor = M ^ K0;

  s_box_1 s1_r1 (.I(r1_xor[7:4]), .O(r1_s1_out));
  s_box_2 s2_r1 (.I(r1_xor[3:0]), .O(r1_s2_out));
  assign r1_sb = {r1_s1_out, r1_s2_out};

  p_box p1 (.I(r1_sb), .O(r1_p));
  // second round
  assign r2_xor = r1_p ^ K1;

  s_box_1 s1_r2 (.I(r2_xor[7:4]), .O(r2_s1_out));
  s_box_2 s2_r2 (.I(r2_xor[3:0]), .O(r2_s2_out));
  assign r2_sb = {r2_s1_out, r2_s2_out};

  p_box p2 (.I(r2_sb), .O(r2_p));
  // third round (XOR with fourth round key instead of P-Box)
  assign r3_xor = r2_p ^ K2;

  s_box_1 s1_r3 (.I(r3_xor[7:4]), .O(r3_s1_out));
  s_box_2 s2_r3 (.I(r3_xor[3:0]), .O(r3_s2_out));
  assign r3_sb = {r3_s1_out, r3_s2_out};

  assign C = r3_sb ^ K3;
/* ============================================================================================== */

endmodule