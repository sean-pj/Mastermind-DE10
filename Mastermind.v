module Mastermind(
	input [9:0] SW,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3
	);

	reg[2:0] d0, d1, d2, d3;
	
	always @(SW) begin
		d0 = SW[2:0];
	end
	
	seven_segment seven_segment(
		.d0(d0),
		.d1(d1),
		.d2(d2),
		.d3(d3),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3)
	);
	
	

endmodule