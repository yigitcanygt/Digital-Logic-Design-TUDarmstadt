`timescale 1ns / 1ns

module p_box

    ( input   logic [7:0] I,   // 8-bit input
      output  logic [7:0] O); // rearranged output

/* ====================================== INSERT CODE HERE ====================================== */
always_comb begin
    O[7] = I[2];
    O[6] = I[3];
    O[5] = I[6];
    O[4] = I[1];
    O[3] = I[4];
    O[2] = I[7];
    O[1] = I[0];
    O[0] = I[5];
end
/* ============================================================================================== */

endmodule

