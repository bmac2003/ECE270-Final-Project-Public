// Tested
module clkdiv #(
    parameter BITLEN = 8
) (
    input logic clk, rst, 
    input logic [BITLEN-1:0] lim,
    output logic hzX
);

  logic [BITLEN-1:0] ctr;

  always_ff @ (posedge clk, posedge rst) begin
    if (rst == 1'b1) begin
      ctr = 0;
      hzX = 0;
    end
    else begin
      if (ctr >= lim) begin
        hzX = ~hzX;
        ctr = 0;
      end
      else begin
        hzX = hzX;
        ctr = ctr + 1'b1;
      end
    end
  end

endmodule

