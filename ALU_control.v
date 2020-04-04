module ALU_control (
	input [1:0] ALUOp,
	input [5:0] func,
	output reg [2:0] operation);
	always @(*)
	begin
		casex ({ALUOp, func})
		8'b00xxxxxx: operation = 3'b010;
		8'b01xxxxxx: operation = 3'b110;
		8'b1xxx0000: operation = 3'b010;
		8'b1xxx0010: operation = 3'b110;
		8'b1xxx0100: operation = 3'b000;
		8'b1xxx0101: operation = 3'b001;
		8'b1xxx1010: operation = 3'b111;
		default : operation = 3'b000;
		endcase
	end

endmodule