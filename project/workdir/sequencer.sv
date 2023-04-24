// Tested
module sequencer(
  input logic clk,
  input logic rst,
  input logic srst,
  input logic go_left,
  input logic go_right,
  output logic [7:0] seq_out);
  
  always_ff @ (posedge clk, posedge rst) begin
    if (rst == 1'b1) 
      seq_out = 8'h80;
    else if (srst == 1'b1) 
      seq_out = 8'h80;
    else if (go_right == 1'b1) 
      seq_out = {seq_out[0], seq_out[7:1]};
    else if (go_left == 1'b1)
      seq_out = {seq_out[6:0], seq_out[7]};
    else 
      seq_out = seq_out;
  end
  
endmodule

