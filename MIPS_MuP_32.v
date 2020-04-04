`include "ALU_control.v"
`include "ALU.v"
`include "32bitadder.v"


module MIPS_MuP_32(
	input clk,
	input rst
	);

////  rename all wires and variable placeholders for the wire input

wire [x:0] IF_stage;
wire [y:0] ID_stage;
wire [z:0] EX_stage;
wire [v:0] MEM_stage;
wire [w:0] WB_stage;
wire [u:0] control_signals;


reg zero = 1'b0;
reg one = 1'b1;


///////////////////////////////////////

reg [31:0] PC = 32'b0;
reg [31:0] increment = 32'h4;


mux32_2to1 mux1_IF (
	.A(IF_stage[x:x-31]), // comes from PC+4
	.B(IF_stage[31:0]), // comes from mem stage (branch target)
	.sel(PCSrc), // comes from mem stage, control signal
	.C(IF_stage[63:32]) // goes to PC
	);

wire clk2;
assign clk2= PC & PCWrite;

always @(posedge clk2) begin : PC_update
	begin
		PC <= IF_stage[63:32] ;
	end
end

my32BitAdder adder1_IF (
	.a(PC), // PC 
	.b(increment), // +4
	.carry_in(zero), // no carry
	.sum(IF_stage[x:x-31]), // output goes to mux, carry out ignored
	);

///////
///////  INSTRUCTION MEMORY 32 bit to be added from lab 7
/////// wires x-32: x-63 such that x-64 = 63
/////// x = 63+64 = 127


reg [63:0] IF_ID;

wire clk3;
assign clk3 = clk & IFIDWrite;

always @(posedge clk2) begin : update_IFID
	begin
		IFID <= IF_stage[x:x-63];
	end
end




//////////////////////////////////////////
////////////////////////////////////////// END OF IF> START OF ID AND CONTROL
//////////////////////////////////////////


module regRW (	
	.clk(clk),	
	.rst(rst),
	.write(RegWrite),
	.writeRegNumber(IFID[15:11]),
	.writeData(WB_stage[x:x-31]),
	.readRegNumber1(IFID[25:21]), .readRegNumber2(IFID[20:16]),
	.readRegData1(ID_stage[x-74:x-105]), .readRegData2(ID_stage[x-42:x-73])
	);


reg [size:0] IDEX;

always @(posedge clk) begin : update_IDEX
	begin
		IDEX <= ID_stage[x:0];
	end
end


///////////////////missing control and hazard detection

//////////////////////////////////////////
////////////////////////////////////////// END OF ID> START OF EX
//////////////////////////////////////////


module ALU(
	input [31:0] word1,
	input [31:0] word2,
	input [1:0] ALUOp,
	input bitinvert,
	//input c_in,
	output [31:0] out);



ALU_control aluc1(
	.ALUOP(EX_stage[a:b]),
	.func(EX_stage[a:b]),
	.operation(EX_stage[a:b])
	);

mux32_2to1 m1 (
	)























/////////////////////////////////EX stage



ALU alu1(
	.word1(EX_stage[a:b]),
	.word2(EX_stage[a:b]),
	.bitinvert(EX_stage[a:b]),
	.ALUOp(EX_stage[a:b]),
	.out(EX_stage[a:b])
	);





