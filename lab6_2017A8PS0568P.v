module d_ff(
	input d,
	input clk,
	input rst,
	output reg q);
	
	always @ (posedge clk or posedge rst)
	begin
	if (rst)
		q<=1'b0;
	else 
		q<=d;
	end
endmodule

module d_ff_32 (
	input [31:0] d,
	input clk,
	input rst,
	output [31:0] q);
	
	genvar i;
	generate
		for (i=0; i<32; i=i+1)
			d_ff da(d[i],clk,rst,q[i]);
	endgenerate
endmodule

module mux32_1 (q0, sel, regDat);

	input [31:0] q0[31:0];
	input [4:0] sel;
	output reg [31:0] regData;

	always @(*) begin 
		regData = q0[sel];
	
	end
	
	/*always @ (*)
	case(sel)
	0: regData = q[0];
	1: regData = q[1];
	2: regData = q[2];
	3: regData = q[3];
	4: regData = q[4];
	5: regData = q[5];
	6: regData = q[6];
	7: regData = q[7];
	8: regData = q[8];
	9: regData = q[9];
	10: regData = q[10];
	11: regData = q[11];
	12: regData = q[12];
	13: regData = q[13];
	14: regData = q[14];
	15: regData = q[15];
	16: regData = q[16];
	17: regData = q[17];
	18: regData = q[18];
	19: regData = q[19];
	20: regData = q[20];
	21: regData = q[21];
	22: regData = q[22];
	23: regData = q[23];
	24: regData = q[24];
	25: regData = q[25];
	26: regData = q[26];
	27: regData = q[27];
	28: regData = q[28];
	29: regData = q[29];
	30: regData = q[30];
	31: regData = q[31];
	endcase*/
endmodule


////////////////////////////////////////////////////////////

module decoder5_32(
	input [4:0] sel,
	output reg [31:0] enable);

	always @(*) begin
		enable = 1'b1<<sel;	
	end
	
	/*assign enable[0] = (~sel[4]) & (~sel[3]) & (~sel[2]) & (~sel[1]) & (~sel[0]);
	assign enable[1] = (~sel[4]) & (~sel[3]) & (~sel[2]) & (~sel[1]) & (sel[0]);
	assign enable[2] = (~sel[4]) & (~sel[3]) & (~sel[2]) & (sel[1]) & (~sel[0]);
	assign enable[3] = (~sel[4]) & (~sel[3]) & (~sel[2]) & (sel[1]) & (sel[0]);
	
	assign enable[4] = (~sel[4]) & (~sel[3]) & (sel[2]) & (~sel[1]) & (~sel[0]);
	assign enable[5] = (~sel[4]) & (~sel[3]) & (sel[2]) & (~sel[1]) & (sel[0]);
	assign enable[6] = (~sel[4]) & (~sel[3]) & (sel[2]) & (sel[1]) & (~sel[0]);
	assign enable[7] = (~sel[4]) & (~sel[3]) & (sel[2]) & (sel[1]) & (sel[0]);
	
		assign enable[8] = (~sel[4]) & (sel[3]) & (~sel[2]) & (~sel[1]) & (~sel[0]);
	assign enable[9] = (~sel[4]) & (sel[3]) & (~sel[2]) & (~sel[1]) & (sel[0]);
	assign enable[10] = (~sel[4]) & (sel[3]) & (~sel[2]) & (sel[1]) & (~sel[0]);
	assign enable[11] = (~sel[4]) & (sel[3]) & (~sel[2]) & (sel[1]) & (sel[0]);
	
	assign enable[12] = (~sel[4]) & (sel[3]) & (sel[2]) & (~sel[1]) & (~sel[0]);
	assign enable[13] = (~sel[4]) & (sel[3]) & (sel[2]) & (~sel[1]) & (sel[0]);
	assign enable[14] = (~sel[4]) & (sel[3]) & (sel[2]) & (sel[1]) & (~sel[0]);
	assign enable[15] = (~sel[4]) & (sel[3]) & (sel[2]) & (sel[1]) & (sel[0]);
	
	
		assign enable[16] = (sel[4]) & (~sel[3]) & (~sel[2]) & (~sel[1]) & (~sel[0]);
	assign enable[17] = (sel[4]) & (~sel[3]) & (~sel[2]) & (~sel[1]) & (sel[0]);
	assign enable[18] = (sel[4]) & (~sel[3]) & (~sel[2]) & (sel[1]) & (~sel[0]);
	assign enable[19] = (sel[4]) & (~sel[3]) & (~sel[2]) & (sel[1]) & (sel[0]);
	
	assign enable[20] = (sel[4]) & (~sel[3]) & (sel[2]) & (~sel[1]) & (~sel[0]);
	assign enable[21] = (sel[4]) & (~sel[3]) & (sel[2]) & (~sel[1]) & (sel[0]);
	assign enable[22] = (sel[4]) & (~sel[3]) & (sel[2]) & (sel[1]) & (~sel[0]);
	assign enable[23] = (sel[4]) & (~sel[3]) & (sel[2]) & (sel[1]) & (sel[0]);
	
	assign enable[24] = (sel[4]) & (sel[3]) & (~sel[2]) & (~sel[1]) & (~sel[0]);
	assign enable[25] = (sel[4]) & (sel[3]) & (~sel[2]) & (~sel[1]) & (sel[0]);
	assign enable[26] = (sel[4]) & (sel[3]) & (~sel[2]) & (sel[1]) & (~sel[0]);
	assign enable[27] = (sel[4]) & (sel[3]) & (~sel[2]) & (sel[1]) & (sel[0]);
	
	assign enable[28] = (sel[4]) & (sel[3]) & (sel[2]) & (~sel[1]) & (~sel[0]);
	assign enable[29] = (sel[4]) & (sel[3]) & (sel[2]) & (~sel[1]) & (sel[0]);
	assign enable[30] = (sel[4]) & (sel[3]) & (sel[2]) & (sel[1]) & (~sel[0]);
	assign enable[31] = (sel[4]) & (sel[3]) & (sel[2]) & (sel[1]) & (sel[0]);
	*/

	
endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////


module regRW (	
	input clk,	
	input rst,
	input write,
	input [4:0] writeRegNumber,
	input [31:0] writeData,
	input [4:0] readRegNumber1, readRegNumber2,
	output [31:0] readRegData1, readRegData2);
	
	wire [31:0] [31:0]regOut ;
	wire [31:0] writeEnable;
	wire [31:0] clk_in;
	
	genvar i;
	generate
		for (i = 0; i < 32; i++)
		begin
			d_ff_32 d0 (writeData, clk_in[i], rst, regOut[i]);
			assign clk_in[i] = clk & write & writeEnable[i] ;
		end
	endgenerate
	
	
	mux32_1 m1 (regOut, readRegNumber1, readRegData1);
	mux32_1 m2 (regOut, readRegNumber2, readRegData2);
	
	decoder5_32 de1 (writeRegNumber, writeEnable);
		
endmodule
