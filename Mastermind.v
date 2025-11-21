module Mastermind(
	input [9:0] SW,
	input [1:0] KEY,
	output [9:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3
	);

	reg[2:0] d0, d1, d2, d3 = 3'd0;
	
	integer i = 0;
	
	always @(negedge KEY) begin
		if (i == 3)
			i = 0;
		else
			i = i + 1;
	end
	
	always @(SW) begin
		case(i)
			0: begin d0 = SW[2:0]; end
			1: begin d1 = SW[2:0]; end
			2: begin d2 = SW[2:0]; end
			3: begin d3 = SW[2:0]; end
//			default: begin
//				d0 = SW[2:0];
//			end
		endcase
	end
	
//	always @(i, SW) begin
//		case(i)
//			0: begin d0 = SW[2:0]; d3 = 3'd0;  end
//			1: begin d1 = SW[2:0]; d0 = 3'd0; end
//			2: begin d2 = SW[2:0]; d1 = 3'd0; end
//			3: begin d3 = SW[2:0]; d2 = 3'd0; end
//			default: begin
//				d0 = SW[2:0];
//			end
//		endcase
//	end
	
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