`timescale 1ns /1ps

module CMEMwrap(clk, Q,CEN, WEN, A, D);

output wire [15:0] Q;
input wire [5:0] A;
input wire [15:0] D;
input wire clk;
input wire CEN;
input wire WEN;

CMEM dut(.CLK(clk),
	.A(A),
	.D(D),
	.CEN(CEN),
	.WEN(WEN),
	.Q(Q));

endmodule
