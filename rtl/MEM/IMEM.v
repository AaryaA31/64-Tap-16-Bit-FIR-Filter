`timescale 1ns/1ps
module IMEM( clk, resetn,read, data_in, load_en, data_out, read_en);
	input clk;
	input resetn;
	input [15:0] data_in;
	input load_en;
	input read_en;
	output [15:0] data_out;
	output reg [5:0] read;

	reg [5:0] read_add;
	
	reg [15:0]mem[63:0];
	integer i;

	always @ (posedge clk) begin
		if (~resetn) begin
			for (i=0; i<64; i=i+1) begin
				mem[i] <=16'd0;
			end
		end
		else if (load_en) begin
			mem[0] <=data_in;
			
			for (i=1; i<63; i=i+1) begin
				mem[i] <= mem[i-1];
			end
		end
	end

		assign data_out=mem[read_add];

	always @(posedge clk) begin
		if(~resetn) begin
			read_add =6'd0;
			read <=read_add;
		end
		if (read_en) begin
			read_add = (read_add+1)%64;
			read<=read_add;
		end
	end
endmodule
