// Tested
module sequence_editor(
	input logic clk, rst,
	input logic [1:0] mode, 
	input logic [2:0] set_time_idx,
	input logic [3:0] tgl_play_smpl,
	output logic [3:0] seq_smpl_1, seq_smpl_2, 
	seq_smpl_3, seq_smpl_4, 
	seq_smpl_5, seq_smpl_6, 
	seq_smpl_7, seq_smpl_8);

	always_ff @ (posedge clk, posedge rst) begin
		if (rst == 1'b1) begin
			seq_smpl_1 = 4'b0;
			seq_smpl_2 = 4'b0;
			seq_smpl_3 = 4'b0;
			seq_smpl_4 = 4'b0;
			seq_smpl_5 = 4'b0;
			seq_smpl_6 = 4'b0;
			seq_smpl_7 = 4'b0;
			seq_smpl_8 = 4'b0;
		end
		else if (mode == 2'd0)
			case (set_time_idx) 
				3'd0: seq_smpl_1 = seq_smpl_1 ^ tgl_play_smpl;
				3'd1: seq_smpl_2 = seq_smpl_2 ^ tgl_play_smpl;
				3'd2: seq_smpl_3 = seq_smpl_3 ^ tgl_play_smpl;
				3'd3: seq_smpl_4 = seq_smpl_4 ^ tgl_play_smpl;
				3'd4: seq_smpl_5 = seq_smpl_5 ^ tgl_play_smpl;
				3'd5: seq_smpl_6 = seq_smpl_6 ^ tgl_play_smpl;
				3'd6: seq_smpl_7 = seq_smpl_7 ^ tgl_play_smpl;
				3'd7: seq_smpl_8 = seq_smpl_8 ^ tgl_play_smpl;
			endcase
	end

endmodule
