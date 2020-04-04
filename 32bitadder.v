module fullAdderData(
	input a,
	input b,
	input c_in,
	output sum,
	output c_out);

	assign sum = ((a^b)^c_in);
	assign c_out = ((a^b)&c_in)|(a&b);
endmodule
///////////////////////////////////////////////////////////////
module my4BitRCA(
	input [3:0] A,
	input [3:0] B,
	input c_in,
	output [3:0]  sum,
	output c_out);

	wire [2:0] c;

	fullAdderData fd0  (A[0], B[0], c_in, sum[0], c[0]);
	fullAdderData fd1  (A[1], B[2], c[0], sum[1], c[1]);
	fullAdderData fd2  (A[2], B[2], c[1], sum[2], c[2]);
	fullAdderData fd3  (A[3], B[3], c[2], sum[3], c_out);
endmodule
// A top level design that contains N instances of half adder
module my32BitAdder
	#(parameter N=8) 
	(input [(4*N)-1:0] a, b,
	input carry_in,
	output [(4*N)-1:0] sum, 
	output carry_out);

	wire [8:0] c_in;
	assign c_in[0] = carry_in;
	assign carry_out = c_in[8]; 
	// We declare a temporary loop variable to be used during generation
	genvar i;

	// Generate for loop to instantiate N times
	generate 
		for (i = 0; i < N; i = i + 1)
		begin
			my4BitRCA u0 (a[(4*(i+1))-1:(4*(i+1))-4], b[(4*(i+1))-1:(4*(i+1))-4], c_in[i], sum[(4*(i+1))-1:(4*(i+1))-4], c_in[i+1]);
		end
	endgenerate
endmodule



/////////////////////////////////////////


module my32BitAdder_tb();
	reg [31:0] A;
	reg [31:0] B;
	reg carry_in;
	wire carry_out;
	wire [31:0] sum;


	my32BitAdder uut (A,B, carry_in, sum, carry_out);

	initial
	begin
		
		carry_in= 1'b0;
		A=32'hFF110000;
		B=32'hF0110000;

		#10
		A=32'h0001001;
		B=32'h0001111;

		#10
		A=32'hFFFFFFFF;
		B=32'hFFFFFFFF;

		#10
		A=32'hABCD1234;
		B=32'h1234ABCD;

		#10 
		carry_in=1'b1;
		A=32'hFF110000;
		B=32'hF0110000;

		#10
		A=32'h0001001;
		B=32'h0001111;

		#10
		A=32'hFFFFFFFF;
		B=32'hFFFFFFFF;

		#10
		A=32'hABCD1234;
		B=32'h1234ABCD;
	
		#10 $finish;

	end
endmodule