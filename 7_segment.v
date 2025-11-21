module seven_segment (
	input [2:0] d0,
	input [2:0] d1,
	input [2:0] d2,
	input [2:0] d3,
	output [6:0]HEX0,
	output [6:0]HEX1,
	output [6:0]HEX2,
	output [6:0]HEX3
);

	// This code is inspired by Kiet Le on youtube: https://www.youtube.com/watch?v=pH9WQXhZEbw

	reg[6:0] hex0_segments;
	reg[6:0] hex1_segments;
	reg[6:0] hex2_segments;
	reg[6:0] hex3_segments;
	
	function [6:0] hex_segments;
		input [2:0] d;
		case (d)
			5'd1:  begin hex_segments = 7'b1111001; end // 1
			5'd2:  begin hex_segments = 7'b0100100; end // 2
			5'd3:  begin hex_segments = 7'b0110000; end // 3
			5'd4:  begin hex_segments = 7'b0011001; end // 4
			5'd5:  begin hex_segments = 7'b0010010;  end // 5
			5'd6:  begin hex_segments = 7'b0000010;  end // 6
			default: begin
				 hex_segments = 7'b1000000;
			end
		endcase
		
		
	endfunction
	

	always @(d0, d1, d2, d3) begin
		hex0_segments = hex_segments(d0);
		hex1_segments = hex_segments(d1);
		hex2_segments = hex_segments(d2);
		hex3_segments = hex_segments(d3);
	end
	
	assign HEX0 = hex0_segments;
	assign HEX1 = hex1_segments;
	assign HEX2 = hex2_segments;
	assign HEX3 = hex3_segments;

endmodule
