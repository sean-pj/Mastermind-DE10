module Mastermind(
	input [9:0] SW,
	input [1:0] KEY,
	input MAX10_CLK1_50,
	output [9:0] LEDR,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3
	);

	reg[2:0] d0, d1, d2, d3 = 3'd0;
	reg[2:0] s0, s1, s2, s3;
	
	reg [2:0] prev_sw;
	reg win_LED = 0;
	
	integer i = 0;
	
	initial begin
		s0 = 3'd1;
		s1 = 3'd2;
		s2 = 3'd3;
		s3 = 3'd4;
	end
	
	always @(negedge KEY[1]) begin
		if ({d0, d1, d2, d3} == {s0, s1, s2, s3}) 
			win_LED = 1;
			
	end	
	
	always @(negedge KEY[0]) begin
		if (i == 3)
			i = 0;
		else
			i = i + 1;
	end
	
	always @(posedge MAX10_CLK1_50) begin
		if (SW[2:0] != prev_sw) begin
        prev_sw <= SW[2:0];
        case(i)
            0: d0 <= SW[2:0];
            1: d1 <= SW[2:0];
            2: d2 <= SW[2:0];
            3: d3 <= SW[2:0];
        endcase
		end
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
	
	assign LEDR[0] = win_LED;

endmodule