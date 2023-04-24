// Tested
module pwm #(
    parameter int CTRVAL = 256,
    parameter int CTRLEN = $clog2(CTRVAL)
)
(
    input logic clk, rst, enable,
    input logic [CTRLEN-1:0] duty_cycle,
    output logic [CTRLEN-1:0] counter,
    output logic pwm_out
);

always_ff @ (posedge clk, posedge rst) begin
    if (rst == 1'b1) begin
		counter = 0;
		pwm_out = 1'b1;
	end
	else if (enable == 1'b1) begin
		if (~&counter) begin
			counter = counter + 1'b1;
			if (duty_cycle == 0)
				pwm_out = 1'b0;
			else if (counter <= duty_cycle)
				pwm_out = 1'b1;
			else 
				pwm_out = 1'b0;
		end
		else begin
			counter = 0;
			pwm_out = 1'b1;
		end
	end
	else begin
		counter = 0;
		pwm_out = 1'b1;
	end
end

endmodule
