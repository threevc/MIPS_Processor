// Code your design here
module fullAdder(
	input a,
	input b,
	input c_in,
	output sum,
	output c_out);

	assign sum = ((a^b)^c_in);
	assign c_out = ((a^b)&c_in)|(a&b);
endmodule


module mux32_2to1 (
	input [31:0] A,
	input [31:0] B,
	input sel,
	output reg [31:0] C);

	always @(*)
    begin
	case (sel)
		1'b0 : C <= A;
		1'b1 : C <= B;
	endcase
    end

endmodule


module ALU(
	input [31:0] word1,
	input [31:0] word2,
	input [1:0] ALUOp,
	input bitinvert,
	//input c_in,
	output [31:0] out);

	reg [31:0] out1;
	wire [31:0] out2;
	wire [31:0] word3;
	wire [31:0] carry;
	wire carryin;

	always @(*)
	begin 
		case (ALUOp[0])
			1'b0 : out1 = word1 & word3;
			1'b1 : out1 = word1 | word3;
		endcase	
	end

	assign carryin = bitinvert;//^c_in'

	genvar i;
	generate 
		for (i = 0; i<32; i=i+1)
		begin 
			assign word3[i] = word2[i]^bitinvert;
			
			if (i==0) 
			begin
				fullAdder fa1 (word1[i], word3[i],carryin,out2[i], carry[i]);
			end
			else 
			begin 
				fullAdder fa2 (word1[i], word3[i],carry[i-1],out2[i], carry[i]);
			end
		end
	endgenerate


	mux32_2to1 m1(out1, out2, ALUOp[1], out);

endmodule