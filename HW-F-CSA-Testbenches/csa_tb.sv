`timescale 1ns / 1ns

module csa_tb;

  //********************* MODULE INPUTS ***********************//

/* ====================================== INSERT CODE HERE ====================================== */
 // N = 4 signals
logic [3:0] A4, B4;
logic Ci4;

// N = 16 signals
logic [15:0] A16, B16;
logic Ci16;
/* ============================================================================================== */

  //***********************************************************//

  //********************* MODULE OUTPUTS **********************//

/* ====================================== INSERT CODE HERE ====================================== */
// Outputs for N = 4
logic [3:0] S4;
logic Co4;

// Outputs for N = 16
logic [15:0] S16;
logic Co16;
/* ============================================================================================== */

  //***********************************************************//

  //******************* UUT INSTANTIATION *********************//

/* ====================================== INSERT CODE HERE ====================================== */
// UUT for N = 4
csa #(.N(4)) uut4 (
    .A(A4),
    .B(B4),
    .C_i(Ci4),
    .S(S4),
    .C_o(Co4)
);

// UUT for N = 16
csa #(.N(16)) uut16 (
    .A(A16),
    .B(B16),
    .C_i(Ci16),
    .S(S16),
    .C_o(Co16)
);
/* ============================================================================================== */

  //***********************************************************//

  //********************* TEST INITIATION *********************//
  initial begin
    $dumpfile("csa_tb.vcd");
    $dumpvars;

    $display("************* STARTING SIMULATION *************");

    $display("### Starting test 1 (N=4): a+b with a,b in [0,15] and C_i=0             ###");

/* ====================================== INSERT CODE HERE ====================================== */
Ci4 = 0;
for (int a = 0; a < 16; a++) begin
    for (int b = 0; b < 16; b++) begin
        A4 = a;
        B4 = b;
        #1;

        if ({Co4, S4} !== (a + b)) begin
            $display("ERROR N=4 Ci=0: %0d + %0d => got %b%b expected %b",
                     a, b, Co4, S4, (a+b));
        end
    end
end
/* ============================================================================================== */

$display("### Starting test 2 (N=4): a+b with a,b in [0,15] and C_i=1             ###");

/* ====================================== INSERT CODE HERE ====================================== */
Ci4 = 1;
for (int a = 0; a < 16; a++) begin
    for (int b = 0; b < 16; b++) begin
        A4 = a;
        B4 = b;
        #1;

        if ({Co4, S4} !== (a + b + 1)) begin
            $display("ERROR N=4 Ci=1: %0d + %0d + 1 => got %b%b expected %b",
                     a, b, Co4, S4, (a+b+1));
        end
    end
end
/* ============================================================================================== */

    $display("### Starting test 3 (N=16): 0+0 and C_i=0                               ###");

/* ====================================== INSERT CODE HERE ====================================== */
A16 = 0;
B16 = 0;
Ci16 = 0;
#1;

if ({Co16, S16} !== 17'd0) begin
    $display("ERROR N=16: 0+0 failed");
end
/* ============================================================================================== */

    $display("### Starting test 4 (N=16): a+b with a,b set to maximal value and C_i=1 ###");

/* ====================================== INSERT CODE HERE ====================================== */
A16 = 16'hFFFF;
B16 = 16'hFFFF;
Ci16 = 1;
#1;

if ({Co16, S16} !== (16'hFFFF + 16'hFFFF + 1)) begin
    $display("ERROR N=16: max+max+1 failed");
end
/* ============================================================================================== */

    $display("### Starting test 5 (N=16): 3+13 and C_i=0                              ###");

/* ====================================== INSERT CODE HERE ====================================== */
A16 = 3;
B16 = 13;
Ci16 = 0;
#1;

if ({Co16, S16} !== 16'd16) begin
    $display("ERROR N=16: 3+13 failed");
end
/* ============================================================================================== */

    $display("************* SIMULATION COMPLETE *************");
    $finish;
  end

  //***********************************************************//

  // Ignore this, this will only terminate your testbench if it takes too long
  // Make sure you do not use too large delays and that there is no endless loop somewhere!
  initial begin
    #(1000000);
    $display("**** SIMULATION TOOK TOO LONG, STOPPING NOW ***");
    $finish;
  end

endmodule
