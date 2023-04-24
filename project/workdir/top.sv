module top (
  // I/O ports
  input  logic hz2m, hz100, reset,
  input  logic [20:0] pb,
  /* verilator lint_off UNOPTFLAT */
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);
  // MODE TYPEDEF
  typedef enum logic [1:0] { EDIT=0, PLAY=1, RAW=2 } mode_t;
  mode_t mode;

  // 2HZ CLOCK
  logic bpm_clk;  
  clkdiv #(.BITLEN(19)) clk2hzdiv (.clk(hz2m),
                                   .rst(reset),
                                   .lim(19'd499999),
                                   .hzX(bpm_clk));

  // 16KHZ CLOCK
  logic sample_clk;  
  clkdiv clk16khzdiv (.clk(hz2m),
                      .rst(reset),
                      .lim(8'd124),
                      .hzX(sample_clk));

  // SCANKEY INSTANTIATION
  logic [4:0] keycode;
  logic strobe;
  scankey sk1 (.clk(hz2m), .rst(reset), .in(pb[19:0]), .strobe(strobe), .out(keycode));

  // CONTROLLER INSTANTIATION
  logic W_PRESSED;
  logic Y_PRESSED;
  logic Z_PRESSED;
  assign W_PRESSED = keycode == 5'd16 ? 1'b1: 1'b0;
  assign Y_PRESSED = keycode == 5'd18 ? 1'b1: 1'b0;
  assign Z_PRESSED = keycode == 5'd19 ? 1'b1: 1'b0;
  controller control(.clk(strobe), 
                     .rst(reset), 
                     .set_edit(Z_PRESSED), 
                     .set_play(Y_PRESSED), 
                     .set_raw(W_PRESSED),
                     .mode(mode));
  assign red = mode == RAW ? 1'b1 : 1'b0;
  assign green = mode == PLAY ? 1'b1 : 1'b0;
  assign blue = mode == EDIT ? 1'b1 : 1'b0;

  // SEQUENCER INSTANTIATION (EDIT MODE)
  logic [7:0] edit_seq_out;
  sequencer edit_seq(.clk(strobe), 
                     .rst(reset), 
                     .srst(mode == EDIT ? 1'b0: 1'b1), 
                     .go_left(pb[11]),
                     .go_right(pb[8]), 
                     .seq_out(edit_seq_out));

  // SEQUENCER INSTANTIATION (PLAY MODE)
  logic [7:0] play_seq_out;
  sequencer play_seq(.clk(bpm_clk), 
                     .rst(reset), 
                     .srst(mode == PLAY ? 1'b0: 1'b1), 
                     .go_left(1'b0), 
                     .go_right(1'b1), 
                     .seq_out(play_seq_out));

  // SEQUENCER FLIP FLOP
  logic [7:0] seq_out;
  always_ff @ (posedge hz2m, posedge reset) begin
    if (reset == 1'b1) 
      seq_out <= 8'b0;
    else if (mode == EDIT)
      seq_out <= edit_seq_out;
    else if (mode == PLAY) 
      seq_out <= play_seq_out;
  end

  // PRIENC8TO3 INSTANTIATION
  // SEQUENCER SELECTION VALUE EDIT MODE
  logic [2:0] seq_sel;
  prienc8to3 prienc_edit(.in(edit_seq_out), 
                         .out(seq_sel));

  // SEQUENCER SELECTION VALUE PLAY MODE
  logic [2:0] play_seq_sel;
  prienc8to3 prienc_play(.in(play_seq_out), 
                         .out(play_seq_sel));

  // SEQUENCE_EDITOR INSTANTIATION
  logic [3:0] edit_play_smpl [7:0];
  sequence_editor editor(.clk(strobe), 
                         .rst(reset), 
                         .mode(mode),
                         .set_time_idx(seq_sel),
                         .tgl_play_smpl(pb[3:0]),
                         .seq_smpl_1(edit_play_smpl[0]),
                         .seq_smpl_2(edit_play_smpl[1]),
                         .seq_smpl_3(edit_play_smpl[2]),
                         .seq_smpl_4(edit_play_smpl[3]),
                         .seq_smpl_5(edit_play_smpl[4]),
                         .seq_smpl_6(edit_play_smpl[5]),
                         .seq_smpl_7(edit_play_smpl[6]),
                         .seq_smpl_8(edit_play_smpl[7]));

  // SSDEC ASSIGNMENTS
  assign ss0 = {2'b0,edit_play_smpl[0][3],edit_play_smpl[0][1],1'b0,edit_play_smpl[0][0],edit_play_smpl[0][2],1'b0};
  assign ss1 = {2'b0,edit_play_smpl[1][3],edit_play_smpl[1][1],1'b0,edit_play_smpl[1][0],edit_play_smpl[1][2],1'b0};
  assign ss2 = {2'b0,edit_play_smpl[2][3],edit_play_smpl[2][1],1'b0,edit_play_smpl[2][0],edit_play_smpl[2][2],1'b0};
  assign ss3 = {2'b0,edit_play_smpl[3][3],edit_play_smpl[3][1],1'b0,edit_play_smpl[3][0],edit_play_smpl[3][2],1'b0};
  assign ss4 = {2'b0,edit_play_smpl[4][3],edit_play_smpl[4][1],1'b0,edit_play_smpl[4][0],edit_play_smpl[4][2],1'b0};
  assign ss5 = {2'b0,edit_play_smpl[5][3],edit_play_smpl[5][1],1'b0,edit_play_smpl[5][0],edit_play_smpl[5][2],1'b0};
  assign ss6 = {2'b0,edit_play_smpl[6][3],edit_play_smpl[6][1],1'b0,edit_play_smpl[6][0],edit_play_smpl[6][2],1'b0};
  assign ss7 = {2'b0,edit_play_smpl[7][3],edit_play_smpl[7][1],1'b0,edit_play_smpl[7][0],edit_play_smpl[7][2],1'b0};

  // TEMP
  assign {left[7],left[5],left[3],left[1],right[7],right[5],right[3],right[1]} = mode == EDIT ? edit_seq_out : mode == PLAY ? play_seq_out : 8'b0;

  // RAW MODE
  logic [3:0] raw_play_smpl;
  assign raw_play_smpl = pb[3:0];

  // SAMPLE TO PLAY SETTING
  logic [3:0] play_smpl;
  always_ff @ (posedge hz2m, posedge reset) begin
    if (reset == 1'b1) 
      play_smpl <= 0;
    else if (mode == EDIT) 
      play_smpl <= 0;
    else if (mode == PLAY) 
      //play_smpl <= edit_play_smpl[seq_sel];
      play_smpl <= ((enable_ctr <= 900000) ? edit_play_smpl[play_seq_sel] : 4'b0) | raw_play_smpl; 
    else if (mode == RAW) 
      play_smpl <= raw_play_smpl;
    //else 
      // *************************************************************************************
      //play_smpl <= ((enable_ctr <= 900000) ? edit_play_smpl[seq_sel] : 4'b0) | raw_play_smpl; 
      // *************************************************************************************
  end

  // SAMPLE INSTANTIATION
  logic [7:0] sample_data [3:0];

  // KICK
  sample #(
    .SAMPLE_FILE("../audio/kick.mem"),
    .SAMPLE_LEN(4000)
  ) sample_kick (
      .clk(sample_clk),
      .rst(reset),
      .enable(play_smpl[3]),
      .out(sample_data[0])
  );
    
  // CLAP
  sample #(
    .SAMPLE_FILE("../audio/clap.mem"),
    .SAMPLE_LEN(4000)
  ) sample_clap (
      .clk(sample_clk),
      .rst(reset),
      .enable(play_smpl[2]),
      .out(sample_data[1])
  );

  // HIHAT
  sample #(
    .SAMPLE_FILE("../audio/hihat.mem"),
    .SAMPLE_LEN(4000)
  ) sample_hihat (
      .clk(sample_clk),
      .rst(reset),
      .enable(play_smpl[1]),
      .out(sample_data[2])
  );

  // SNARE
  sample #(
    .SAMPLE_FILE("../audio/snare.mem"),
    .SAMPLE_LEN(4000)
  ) sample_snare (
      .clk(sample_clk),
      .rst(reset),
      .enable(play_smpl[0]),
      .out(sample_data[3])
  );

  // SAMPLE COMBINATION
  logic [7:0] kick_clap;
  logic [7:0] hihat_snare;
  logic [7:0] sample_sum;
  always_comb begin 
    kick_clap = sample_data[0] + sample_data[1];
    if (sample_data[0][7] == 1'b1 && sample_data[1][7] == 1'b1 && kick_clap[7] == 1'b0)
      kick_clap = 8'b10000001;
    else if (sample_data[0][7] == 1'b0 && sample_data[1][7] == 1'b0 && kick_clap[7] == 1'b1)
      kick_clap = 8'd127;

    hihat_snare = sample_data[2] + sample_data[3];
    if (sample_data[2][7] == 1'b1 && sample_data[3][7] == 1'b1 && hihat_snare[7] == 1'b0)
      hihat_snare = 8'b10000001;
    else if (sample_data[2][7] == 1'b0 && sample_data[3][7] == 1'b0 && hihat_snare[7] == 1'b1)
      hihat_snare = 8'd127;

    sample_sum = kick_clap + hihat_snare;
    if (kick_clap[7] == 1'b1 && hihat_snare[7] == 1'b1 && sample_sum[7] == 1'b0)
      sample_sum = 8'b10000001;
    else if (kick_clap[7] == 1'b0 && hihat_snare[7] == 1'b0 && sample_sum[7] == 1'b1)
      sample_sum = 8'd127;

    sample_sum = sample_sum ^ 8'd128;
  end

  // PWM INSTANTIATION
  pwm #(.CTRVAL(64)) pwm_sample(.clk(hz2m), 
                                .rst(reset),
                                .enable(1'b1),
                                .duty_cycle(sample_sum[7:2]),
                                .counter(),
                                .pwm_out(right[0]));



  // ERRATA
  logic prev_bpm_clk;
  logic [31:0] enable_ctr;
  always_ff @(posedge hz2m, posedge reset)
  if (reset) begin
    prev_bpm_clk <= 0;
    enable_ctr <= 0;
  end
  // otherwise, if we're in PLAY mode
  else if (mode == PLAY) begin
    // if we're on a rising edge of bpm_clk, indicating 
    // the beginning of the beat, reset the counter.
    if (~prev_bpm_clk && bpm_clk) begin
      enable_ctr <= 0;
      prev_bpm_clk <= 1;
    end
    // if we're on a falling edge of bpm_clk, indicating 
    // the middle of the beat, set the counter to half its value
    // to correct for drift.
    else if (prev_bpm_clk && ~bpm_clk) begin
      enable_ctr <= 499999;
      prev_bpm_clk <= 0;
    end
    // otherwise count to 1 million, and reset to 0 when that value is reached.
    else begin
      enable_ctr <= (enable_ctr == 999999) ? 0 : enable_ctr + 1;
    end
  end
  // reset the counter so we start on time again.
  else begin
    prev_bpm_clk <= 0;
    enable_ctr <= 0;
  end

endmodule
