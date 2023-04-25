`default_nettype none

module Mux2to1_test;
  logic [3:0] inA, inB;
  logic       sel;
  logic [3:0] out;

  logic [9:0] vector;
  assign {sel, inB, inA} = vector[8:0];

  mux2to1 #(4) dut(.*);

  initial begin
    for (vector = 10'b0; vector <= 10'b1111111111; vector++)
      #1 if (sel == 1'd0) begin
        if (out != inA) $display("Output %h doesn't match Input %h for select 0", out, inA);
       end else
         if (out != inB) $display("Output %h doesn't match Input %h for select 0", out, inB);
    $finish;
  end
endmodule : Mux2to1_test
