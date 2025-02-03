`timescale 1ns/1ps

module ALU( opcode, opA, opB, Result, carry_out,ALU_en);
	input [15:0] opA;
	input ALU_en;
	input [15:0] opB;
	input [3:0] opcode;
	output [15:0] Result;
	output carry_out;

	
	wire [16:0] tmp;
	reg [7:0] result;
	assign Result = result;
	assign tmp={1'b0,opA}+{1'b0,opB};
	assign carry_out=tmp[16];

	always @(*)
	begin
		case(opcode)
			4'b0000://addition
			result=opA+opB;
			4'b0001://subtraction
			result=opA-opB;
			4'b0010://Multiplication
			result=(opA*opB);
			4'b0011://Division
			result=(opA)/opB;
			4'b0100://Logical shift LEFT
			result=opA<<1;
			4'b0101://Logical shift RIGHT
			result=opA>>1;
			4'b0110://Rotate left
			result={opA[14:0],opA[15]};
			4'b0111://Rotate right
			result= {opA[0],opA[15:1]};
			4'b1000://Logical AND
			result=opA&opB;
			4'b1001://Logical OR
			result=opA |opB;
			4'b1010://Logical XOR
			result=opA ^opB;
			4'b1011://Logical NOR
			result= ~(opA |opB);
			4'b1100://Logical NAND
			result= ~(opA & opB);
			4'b1101://Logical XNOR
			result=~(opA^opB);
			4'b1110://Greater comparison
			result=(opA>opB)? 16'd1:16'd0;
			4'b1111://Equal comparison
			result=(opA==opB)? 16'd1:16'd0;

			default:result=opA+opB;
		endcase
		

	end
	

	endmodule


