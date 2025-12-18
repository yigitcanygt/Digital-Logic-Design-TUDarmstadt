`timescale 1ns / 1ns

module key_schedule

    ( input   logic [31:0] K,               // 32-bit key
      output  logic [7:0] K0, K1, K2, K3);  // round keys

/* ====================================== INSERT CODE HERE ====================================== */
 always_comb begin
    if (^K) begin
        // odd number of ones
        K0 = K[7:0];
        K1 = K[15:8];
        K2 = K[23:16];
        K3 = K[31:24];
    end else begin
        // even number of ones
        K0 = K[11:4];
        K1 = K[19:12];
        K2 = K[27:20];
        K3 = {K[31:28], K[3:0]};
    end
end
/* ============================================================================================== */

endmodule
