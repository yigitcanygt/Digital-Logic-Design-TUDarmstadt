`timescale 1ns / 1ns

module multi_combination_lock

    ( input   logic A, B, C, D, E, F, G, H, I, J, // Input wires
      output  logic VALID);                       // Set to 1 if current combination is correct

/* ====================================== INSERT CODE HERE ====================================== */
      
    logic comb1, comb2, comb3, comb4, comb5, comb6;

    // Code 1: 110 | 1011110
    assign comb1 =  A &  B & ~C &
                    D & ~E &  F &  G &  H &  I & ~J;

    // Code 2: 010 | 0000010
    assign comb2 = ~A &  B & ~C &
                   ~D & ~E & ~F & ~G & ~H &  I & ~J;

    // Code 3: 000 | 0100100
    assign comb3 = ~A & ~B & ~C &
                   ~D &  E & ~F & ~G &  H & ~I & ~J;

    // Code 4: 111 | 0011111
    assign comb4 =  A &  B &  C &
                   ~D & ~E &  F &  G &  H &  I &  J;

    // Code 5: 100 | 1111101
    assign comb5 =  A & ~B & ~C &
                    D &  E &  F &  G &  H & ~I &  J;

    // Code 6: 111 | 1101011
    assign comb6 =  A &  B &  C &
                    D &  E & ~F &  G & ~H &  I &  J;

    // VALID if at least one combination is correct
    assign VALID = comb1 | comb2 | comb3 | comb4 | comb5 | comb6;

/* ============================================================================================== */

endmodule
