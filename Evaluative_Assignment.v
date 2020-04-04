`timescale 1ns/1ns

/////////////////
//	Top Module //
/////////////////

module convolver(
	input clk,
	input rst);
	
	wire wEn1, wEn2, rEn1, rEn2, initializeMemory, printOutput, endOfAccumulation, accumulatorClear;
	wire[6:0] address1, address2;
	wire [7:0] pixelVal, sum;
	wire [3:0] multiplier;
	wire [10:0] prod;
	wire [7:0] notNeeded;

	memory imageMemory (pixelVal, address1, 8'd0, clk, rEn1, wEn1, initializeMemory, 1'b0);

	shift_multiplication mult (prod, pixelVal, clk, multiplier);

	sum_and_div summ (sum, prod, clk, accumulatorClear, endOfAccumulation);

	memory storeMemory (notNeeded, address2, sum, clk, rEn2, wEn2, 1'b0, printOutput);

	controlUnit CU(wEn1, rEn1, address1, wEn2, rEn2, address2, multiplier, initializeMemory, 
	printOutput, endOfAccumulation, accumulatorClear, clk, rst);

endmodule

/////////////////
//	Control Unit
/////////////////

module controlUnit(
	output reg wEn1,
	output reg rEn1,
	output reg [6:0] address1,
	output reg wEn2,
	output reg rEn2,
	output reg [6:0] address2,
	output reg [3:0] multiplier,
	output reg initializeMemory,
	output reg printOutput,
	output reg endOfAccumulation,
	output reg accumulatorClear,
	input clk, 
	input rst
	); 
	
/////////////////////////
// Write your code here
/////////////////////////	
	
	reg [3:0] curr, next;
	reg [2:0] colcnt, rowcnt;
	reg eoc, col_msb, row_msb, waste;
	
	always @ (posedge clk or posedge rst)
	begin
		if (rst)
			curr <= init;
		else
			curr <= next;
	end 
	
	localparam init =4'd0, 
			   convstart = 4'd1, 
			   conv1 = 4'd2, 
			   conv2 = 4'd3, 
			   conv3 = 4'd4,
			   conv4 = 4'd5, 
			   conv5 = 4'd6, 
			   conv6 = 4'd7,
			   conv7 = 4'd8, 
			   conv8 = 4'd9, 
			   conv9 = 4'd10,
			   buffer = 4'd11,
			   convend = 4'd12,
			   storeout = 4'd13;
			   
	
	always @ (*) begin
		case (curr)
			init : 
			begin	
				initializeMemory = 1'b1;
				printOutput = 1'b0;
				endOfAccumulation = 1'b0;
				accumulatorClear = 1'b1;
				wEn1 = 1'b0;
				rEn1 = 1'b0;
				rEn2 = 1'b0;
				wEn2 = 1'b0;
				colcnt = 3'd0;
				rowcnt = 3'd0;
				col_msb = 1'b0;
				row_msb = 1'b0;
				eoc = 1'b0;
				next = convstart;
			end
			
			convstart :
			begin	
				//accumulatorClear = 1'b1;
				endOfAccumulation = 1'b0;
				wEn2 = 1'b0;
				rEn1 = 1'b1;
				{waste,address1} = 4'd10*({row_msb,rowcnt}+4'd0) + {4'd0,({col_msb,colcnt}+4'd0)};
				next = conv1;
			end	
			
			conv1 :
			begin
				accumulatorClear = 1'b1;
				multiplier = 4'd4;
				rEn1 = 1'b1;
				{waste,address1} = 4'd10*({row_msb,rowcnt}+4'd0) + {4'd0,({col_msb,colcnt}+4'd1)};
				next = conv2;
			end
			
			conv2 :
			begin
				accumulatorClear = 1'b0;
				multiplier = 4'd2;
				rEn1 = 1'b1;
				{waste,address1} = 4'd10*({row_msb,rowcnt}+4'd0) + {4'd0,({col_msb,colcnt}+4'd2)};
				next = conv3;
			end
			
			conv3 :
			begin
				multiplier = 4'd2;
				rEn1 = 1'b1;
				{waste,address1} = 4'd10*({row_msb,rowcnt}+4'd1) + {4'd0,({col_msb,colcnt}+4'd0)};
				next = conv4;
			end
			
			conv4 :
			begin
				multiplier = 4'd4;
				rEn1 = 1'b1;
				{waste,address1} = 4'd10*({row_msb,rowcnt}+4'd1) + {4'd0,({col_msb,colcnt}+4'd1)};
				next = conv5;
			end
			
			conv5 :
			begin
				multiplier = 4'd8;
				rEn1 = 1'b1;
				{waste,address1} = 4'd10*({row_msb,rowcnt}+4'd1) + {4'd0,({col_msb,colcnt}+4'd2)};
				next = conv6;
			end
			
			conv6 :
			begin
				multiplier = 4'd4;
				rEn1 = 1'b1;
				{waste,address1} = 4'd10*({row_msb,rowcnt}+4'd2) + {4'd0,({col_msb,colcnt}+4'd0)};
				next = conv7;
			end
			
			conv7 :
			begin
				multiplier = 4'd2;
				rEn1 = 1'b1;
				address1 = 4'd10*({row_msb,rowcnt}+4'd2) + {4'd0,({col_msb,colcnt}+4'd1)};
				next = conv8;
			end
			
			conv8 :
			begin
				multiplier = 4'd2;
				rEn1 = 1'b1;
				{waste,address1} = 4'd10*({row_msb,rowcnt}+4'd2) + {4'd0,({col_msb,colcnt}+4'd2)};
				next = conv9;
			end
			
			conv9 :
			begin
				multiplier = 4'd4;
				rEn1 = 1'b0;
				//address1 = 4'd10*(rowcnt+3'd2) + {4'd0,(colcnt+3'd2)};
				next = buffer;
			end
			
			buffer :
				next = convend;
			
			convend :
			begin
				endOfAccumulation = 1'b1;
				if ({eoc,rowcnt,colcnt}<7'd64)
				begin
					address2 = 4'd8*(rowcnt) + {4'd0,(colcnt)};
					{eoc,rowcnt,colcnt} = {rowcnt,colcnt} + 6'd1;
					rEn1 = 1'b0;
					wEn2 = 1'b1;
					next = convstart;
				end		
				
				else
				begin
					next = storeout;
				end
			end
			
			storeout :
			begin
				accumulatorClear = 1'b1;
				printOutput = 1'b1;
				wEn1 = 1'b0;
				rEn1 = 1'b0;
				rEn2 = 1'b0;
				wEn2 = 1'b0;
				colcnt = 4'd0;
				rowcnt = 4'd0;
				eoc = 1'b0;
				next = init;
			end		
			
			default :
			begin
				initializeMemory = 1'b1;
				printOutput = 1'b0;
				accumulatorClear = 1'b1;
				wEn1 = 1'b0;
				rEn1 = 1'b0;
				rEn2 = 1'b0;
				wEn2 = 1'b0;
				colcnt = 4'd0;
				rowcnt = 4'd0;
				eoc = 1'b0;
				next = init;
			end
		endcase
	end
	
endmodule

//////////////////////
//	Memory Module
//////////////////////

module memory(
	output reg [7:0] memOut,
	input [6:0] address,
	input [7:0] dataIn,
	input clk,
	input readEnable,
	input writeEnable,
	input initializeMemory,
	input printOutput
	);
	
	reg [7:0] memory [0:99];

	integer i, f;

	always @ (posedge initializeMemory)
		$readmemh("Image_Memory.txt", memory);

	always @ (posedge printOutput)
	begin
		f = $fopen("Result.txt", "w");
			if (f)  $display("File was opened successfully : %0d", f);
			else    $display("File was NOT opened successfully : %0d", f);		
			for(i = 0; i < 64; i = i+1)
				$fwrite(f, "%h\n", memory[i]);
			$fclose(f);
	end

	always @ (posedge clk)
	begin
		if(readEnable)
			memOut <= memory[address];
		else if (writeEnable)
			memory [address] <= dataIn;
		else memOut <= 8'd0;
	end

endmodule

////////////////
//	Accumulator 
////////////////

module sum_and_div(
	output reg [7:0] sum,
	input [10:0] prod,
	input clk,
	input accumulatorClear,
	input endOfAccumulation
	) ;
	
	reg[12:0] accumulator;
		
	always@(posedge clk)
	begin
		if(accumulatorClear)
		begin
			sum <= 8'd0;
			accumulator <= 13'd0;
		end
		else
			accumulator <= accumulator + {2'b00, prod};
	end

	always @ (posedge endOfAccumulation)
		sum = accumulator[12:5]; // for normalisation of the accumulated value

endmodule

///////////////////////
//	Shift Multiplier
///////////////////////
module shift_multiplication(
	output reg [10:0] prod,
	input [7:0] pixelVal,
	input clk,
	input [3:0] multiplier);
	
	always @ (posedge clk)
		begin
		
			case(multiplier)
			4'd2: prod <= {2'b00,pixelVal,1'b0};
			4'd4: prod <= {1'b0, pixelVal, 2'b00};
			4'd8: prod <= {pixelVal, 3'b000};
			default: prod <= 11'b0;
			endcase
		end

endmodule