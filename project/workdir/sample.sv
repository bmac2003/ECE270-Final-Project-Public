// Tested
module sample #(
      parameter SAMPLE_FILE = "../audio/kick.mem",
      parameter SAMPLE_LEN = 4000
  )
  (
      input clk, rst, enable,
      output logic [7:0] out
  );
  
  logic [7:0] audio_mem [4095:0];
  initial $readmemh(SAMPLE_FILE, audio_mem, 0, SAMPLE_LEN);
  
  logic prev_en;
  logic [11:0] counter;
  logic [11:0] next_counter;

  always_comb begin
    if (enable == 1'b1 && prev_en == 1'b1) begin 
      if (counter == (SAMPLE_LEN)) 
        next_counter = 12'b0;
      else
        next_counter = counter + 1'b1;
    end
    else if (prev_en == 1'b1 && enable == 1'b0) 
      next_counter = 12'b0;
    else
      next_counter = counter;
  end

  always_ff @ (posedge clk, posedge rst) begin
    if (rst == 1'b1) begin
      out <= 8'b0;
      counter <= 12'b0;
      prev_en <= 1'b0;
    end
    else begin
      if (enable == 1'b1)
        prev_en <= 1'b1;
      else
        prev_en <= 1'b0;
      counter <= next_counter;
      out <= audio_mem[counter];
    end
  end
  
    
      
endmodule
