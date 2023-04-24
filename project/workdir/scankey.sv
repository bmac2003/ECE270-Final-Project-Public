// Tested
module scankey(input logic clk,
               input logic rst, 
               input logic [19:0] in,
               output logic [4:0] out,
               output logic strobe);
               
  

      
    assign out[0] = in[1] | in[3] | in[5] | in[7] | in[9] | in[11] | in[13] | in[15] | in[17] | in[19];
    assign out[1] = in[2] | in[3] | in[6] | in[7] | in[10] | in[14] | in[15] | in[11] | in[18] | in[19];
    assign out[2] = in[4] | in[5] | in[6] | in[7] | in[12] | in[13] | in[14] | in[15];
    assign out[3] = in[8] | in[9] | in[10] | in[11] | in[12] | in[13] | in[14] | in[15];
    assign out[4] = in[16] | in[17] | in[18] | in[19];

    logic Q;
    
    always_ff @ (posedge clk, posedge rst) begin
        if (rst == 1'b1) 
            strobe <= 0;
        else begin
            Q <= |{in[19:0]};
            strobe <= Q;
        end
    end
    
endmodule