`timescale 1ns / 1ns

module divider
    ( input   logic [7:0] X,
      input   logic       CLK,
      input   logic       SET,
      output  logic [7:0] Y);

  logic [7:0] next_Y;

  always_ff @(posedge CLK) begin
    if (SET) begin
      Y <= X;
    end else begin
      Y <= next_Y;
    end
  end

  assign next_Y = Y >> 1;

endmodule
