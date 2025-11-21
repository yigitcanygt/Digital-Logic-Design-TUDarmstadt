`timescale 1ns/1ns

module multi_combination_lock_tb;

  //**************** ADDITIONAL TESTING VALUES ****************//
  logic         ERROR;              // Will be 1 if any test failed
  //***********************************************************//

  //********************* MODULE INPUTS ***********************//
  logic [2:0]   CODE_USERPART;
  logic [6:0]   CODE_SECRETPART;
  //***********************************************************//

  //********************* MODULE OUTPUTS **********************//
  logic         VALID;
  //***********************************************************//

  //******************* UUT INSTANTIATION *********************//
  multi_combination_lock uut(
                          .A(CODE_USERPART[2]),
                          .B(CODE_USERPART[1]),
                          .C(CODE_USERPART[0]),
                          .D(CODE_SECRETPART[6]),
                          .E(CODE_SECRETPART[5]),
                          .F(CODE_SECRETPART[4]),
                          .G(CODE_SECRETPART[3]),
                          .H(CODE_SECRETPART[2]),
                          .I(CODE_SECRETPART[1]),
                          .J(CODE_SECRETPART[0]),
                          .VALID(VALID));
  //***********************************************************//

  //********************* TEST INITIATION *********************//
  initial begin
    $dumpfile("multi_combination_lock_tb.vcd");
    $timeformat(-9, 0, " ns", 8);
    $dumpvars;

    // Initialize Additional Testing Values
    ERROR       = 1'b0;

    $display("************* STARTING SIMULATION *************");

    // codes always consist of 3 bits "user part" and 7 bits "secret part"
    // 110 | 101 1110
    check_correct_code(1, 3'b110, 7'b101_1110);
    // 010 | 000 0010
    check_correct_code(2, 3'b010, 7'b000_0010);
    // 000 | 010 0100
    check_correct_code(3, 3'b000, 7'b010_0100);
    // 111 | 001 1111
    check_correct_code(4, 3'b111, 7'b001_1111);
    // 100 | 111 1101
    check_correct_code(5, 3'b100, 7'b111_1101);
    // 111 | 110 1011
    check_correct_code(6, 3'b111, 7'b110_1011);
    // incorrect examples:
    // 000 | 000 0000
    check_incorrect_code(7, 0, 0);
    // 111 | 111 1111
    check_incorrect_code(8, 3'b111, 7'b111_1111);
    // 111 | 010 1100
    check_incorrect_code(9, 3'b111, 7'b010_1100);
    // 010 | 100 1111
    check_incorrect_code(10, 3'b010, 7'b100_1111);

    $display("************* SIMULATION COMPLETE *************");

    if (ERROR == 0) begin
      $display("All tests succeeded");
    end else begin
      $display("THERE WERE ERRORS");
    end

    $finish;
  end
  //***********************************************************//

  //********************* SIMULATION TASKS ********************//
  task check_correct_code(input logic [3:0] TEST_INDEX, input logic [2:0] USERPART, input logic [6:0] SECRETPART);
    $display("### Starting test %d: Valid code %b %b ###", TEST_INDEX, USERPART, SECRETPART);
    #1;
    CODE_USERPART   = USERPART;
    CODE_SECRETPART = SECRETPART;
    #1;
    if (VALID === 1'b1) begin
      $display("success");
    end else if (VALID === 1'b0) begin
      $display("error, valid code did not work");
      ERROR       = 1'b1;
    end else begin
      $display("error, output is undefined");
      ERROR       = 1'b1;
    end
  endtask

  task check_incorrect_code (input logic [3:0] TEST_INDEX, input logic [2:0] USERPART, input logic [6:0] SECRETPART);
    $display("### Starting test %d: Invalid code %b %b ###", TEST_INDEX, USERPART, SECRETPART);
    #1;
    CODE_USERPART   = USERPART;
    CODE_SECRETPART = SECRETPART;
    #1;
    if (VALID === 1'b0) begin
      $display("success");
    end else if (VALID === 1'b1) begin
      $display("error, invalid code worked");
      ERROR       = 1'b1;
    end else begin
      $display("error, output is undefined");
      ERROR       = 1'b1;
    end
  endtask
  //***********************************************************//

endmodule
