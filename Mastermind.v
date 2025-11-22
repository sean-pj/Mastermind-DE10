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

	// Guess
	reg[2:0] d0, d1, d2, d3 = 3'd0;
	// Secret Code
	reg[2:0] s0, s1, s2, s3;
	// Possible white pegs
	reg [2:0] w0, w1, w2, w3;
	
	reg [2:0] prev_sw;
	
	reg [9:0] LEDreg;
	// won flag
	reg won = 1'b0;
	
	// for debugging only, omit in final version
	//==========================================
	wire debug = SW[9];

	wire [2:0] disp0, disp1, disp2, disp3;
	assign disp0 = debug ? s0 : d0;
	assign disp1 = debug ? s1 : d1;
	assign disp2 = debug ? s2 : d2;
	assign disp3 = debug ? s3 : d3;
	//==========================================
	
	//8-bit psuedo random state
	reg [7:0] rnd; // nonzero seed
	wire feedback = rnd[7] ^ rnd[5] ^ rnd[4] ^ rnd[3];
	
	// LSFR runs on 50mhz clock
	always @(posedge MAX10_CLK1_50) begin
		rnd <= {rnd[6:0], feedback};
	end

	wire [2:0] s0_rand = rnd[2:0] % 6;
	wire [2:0] s1_rand = rnd[5:3] % 6;
	wire [2:0] s2_rand = rnd[7:5] % 6;
	wire [2:0] s3_rand = (rnd[2:0] ^ rnd[5:3]) % 6;

	
	integer i = 0;
	integer wp_count = 6;
	
	initial begin
		rnd = 8'hA5;
		s0 = s0_rand;
		s1 = s1_rand;
		s2 = s2_rand;
		s3 = s3_rand;
	end
	
	always @(negedge KEY[1]) begin

    if (won) begin
		won <= 1'b0;
		LEDreg <= 10'b0;
		
		s0 <= s0_rand;
		s1 <= s1_rand;
		s2 <= s2_rand;
		s3 <= s3_rand;
    end else begin
        // Clear LEDs
        LEDreg[9:0] = 10'b0000000000;

        // Win condition
        if ({d0, d1, d2, d3} == {s0, s1, s2, s3}) begin
            LEDreg[0] = 1;
            won = 1'b1;
        end else begin
            // Prepare white-peg temp storage
            w0 = s0;
            w1 = s1;
            w2 = s2;
            w3 = s3;

            wp_count = 6;

            // Black peg logic
            if (d0 == s0) begin
                LEDreg[2] = 1;
                w0 = 3'd7;
            end
            if (d1 == s1) begin
                LEDreg[3] = 1;
                w1 = 3'd7;
            end
            if (d2 == s2) begin
                LEDreg[4] = 1;
                w2 = 3'd7;
            end
            if (d3 == s3) begin
                LEDreg[5] = 1;
                w3 = 3'd7;
            end

            // White pegs
            white_peg(d0);
            white_peg(d1);
            white_peg(d2);
            white_peg(d3);
        end
    end
end

	
	task white_peg;
		input [2:0] num;
	
		case (num)
			w0: begin
				// Turn on LED for white peg, but use wp_count to avoid revealing order
				LEDreg[wp_count] = 1;
				wp_count = wp_count + 1;
				// Any repeats of the number should be removed, only one possible white peg per number
				remove_value(w0);
			end
			w1: begin
				LEDreg[wp_count] = 1;
				wp_count = wp_count + 1;
				remove_value(w1);
			end
			w2: begin
				LEDreg[wp_count] = 1;
				wp_count = wp_count + 1;
				remove_value(w2);
			end
			w3: begin
				LEDreg[wp_count] = 1;
				wp_count = wp_count + 1;
				remove_value(w3);
			end
			default: begin 
				LEDreg[wp_count] = 0;
			end
		endcase
	
	endtask
	
	// Removes a found white peg number from the entire list of possible white pegs
	// Avoids multiple white pegs for repeated numbers
	task remove_value;
		input [2:0] num;
		if (w0 == num)
			w0 = 3'd7;
		if (w1 == num)
			w1 = 3'd7;
		if (w2 == num)
			w2 = 3'd7;
		if (w3 == num)
			w3 = 3'd7;
	endtask
	
	// Increment to select which digit to change
	always @(negedge KEY[0]) begin
		if (i == 3)
			i = 0;
		else
			i = i + 1;
	end
	
	
	// Updates seven segment using switches
	// Clock needed to avoid overriding numbers as you switch selection
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
	
	// CHANGE IN FINAL VERSION to d0-d3
	seven_segment seven_segment(
		.d0(disp0),
		.d1(disp1),
		.d2(disp2),
		.d3(disp3),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3)
	);
	
	assign LEDR[9:0] = LEDreg;

endmodule