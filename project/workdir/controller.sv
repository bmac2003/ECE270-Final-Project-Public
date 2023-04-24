// Tested
module controller(
  input logic clk, rst, set_edit, set_play, set_raw,
  output [1:0] mode);
  
  
  always_ff @ (posedge clk, posedge rst) begin
    if (rst == 1'b1)
      mode = 2'd0;
    else begin
      if (set_edit == 1'b1)
        mode = 2'd0;
      else if (set_play == 1'b1) 
        mode = 2'd1;
      else if (set_raw == 1'b1)
        mode = 2'd2;
      else 
        mode = mode;
    end
  end
  

  
endmodule
