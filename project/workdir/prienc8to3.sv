// Tested
module prienc8to3(
  input logic [7:0] in,  // 7 - 0: highest - lowest priority
  output logic [2:0] out // Encoded output
);      

assign out = in[7] == 1 ? 3'b111 /* input 7 is high */ :
               in[6] == 1 ? 3'b110 /* input 6 is high */ :
               in[5] == 1 ? 3'b101 /* input 5 is high */ :
               in[4] == 1 ? 3'b100 /* input 4 is high */ :
               in[3] == 1 ? 3'b011 /* input 3 is high */ :
               in[2] == 1 ? 3'b010 /* input 2 is high */ :
               in[1] == 1 ? 3'b001 /* input 1 is high */ :
               in[0] == 1 ? 3'b000 /* input 0 is high */ :
                           3'b000; // Nothing pressed.
endmodule
