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
        begin
            case (d)
                3'd0: hex_segments = 7'b1000000; // 0
                3'd1: hex_segments = 7'b1111001; // 1
                3'd2: hex_segments = 7'b0100100; // 2
                3'd3: hex_segments = 7'b0110000; // 3
                3'd4: hex_segments = 7'b0011001; // 4
                3'd5: hex_segments = 7'b0010010; // 5
                default: hex_segments = 7'b0111111; // "-" for invalid (guess > 5)
            endcase
        end
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
