`timescale 1ns / 1ns

module multi_and

    #(parameter N = 8) // Assume that N>1 always

    ( input  logic [N-1:0] INPUT_BITS,
      output logic         OUTPUT_BIT);

  generate
    if (N == 2) begin // Abbruchbedingung
      and2 a (.A(INPUT_BITS[1]),
              .B(INPUT_BITS[0]),
              .OUTPUT_BIT(OUTPUT_BIT));
    end else begin // Rekursion
      logic upper, lower;
      multi_and #(.N(N / 2)) ma1 (.INPUT_BITS(INPUT_BITS[N-1:N/2]),
                                  .OUTPUT_BIT(upper));
      multi_and #(.N(N / 2)) ma2 (.INPUT_BITS(INPUT_BITS[N/2-1:0]),
                                  .OUTPUT_BIT(lower));
      and2 a (.A(upper),
              .B(lower),
              .OUTPUT_BIT(OUTPUT_BIT));
    end
  endgenerate

endmodule

module and2
    ( input  logic A,
      input  logic B,
      output logic OUTPUT_BIT);
  
  assign OUTPUT_BIT = A & B;

endmodule
