`timescale 1ns / 1ns

module s_box_2

    ( input   logic [3:0] I,  // 4-bit input
      output  logic [3:0] O); // substituted output

/* ====================================== INSERT CODE HERE ====================================== */
  always_comb begin
    case (I)
        4'd0:  O = 4'd0;
        4'd1:  O = 4'd7;
        4'd2:  O = 4'd14;
        4'd3:  O = 4'd1;
        4'd4:  O = 4'd5;
        4'd5:  O = 4'd11;
        4'd6:  O = 4'd8;
        4'd7:  O = 4'd2;
        4'd8:  O = 4'd3;
        4'd9:  O = 4'd10;
        4'd10: O = 4'd13;
        4'd11: O = 4'd6;
        4'd12: O = 4'd15;
        4'd13: O = 4'd12;
        4'd14: O = 4'd4;
        4'd15: O = 4'd9;
        default: O = 4'd0;
    endcase
end
/* ============================================================================================== */

endmodule
