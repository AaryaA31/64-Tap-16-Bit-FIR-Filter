`timescale 1ns/1ps
`include "ALU/ALU.v"
`include "MEM/CMEM.v"
`include "MEM/IMEM.v"
`include "FIFO/FIFO.v"

module test(rclk, A,CEN,WEN, D,OPCODE1,result,carry_out1,ALU_en1,

//FIFO AND IMEM
wdata,wclk,wfull,rempty, winc,rinc,wrst_n,rrst_n,
resetn,load_en,read_en,read, aluResult1
);
 parameter numTaps = 64;        // Number of filter taps
    parameter numSamples = 64;    // Number of input samples
//input Mux;
output reg[15:0] result;
input rclk;
input [5:0] A;
input [15:0] D;
input CEN;
input WEN;
output carry_out1;
input [3:0] OPCODE1;
input ALU_en1;





//fifo and imem
input [15:0] wdata;
input wclk;
output wfull;
output rempty;
input rinc;
input winc;
input wrst_n;
input rrst_n;

input resetn;
input load_en;
input read_en;
output [5:0] read;
output reg [15:0] aluResult1;

//

wire [15:0] sramtoALU;
wire [15:0] ALUtoALU;
wire [15:0] fifotoIMEM;
wire [15:0] IMEMtoalu;
reg[15:0] feedback=0;
//reg [15:0] value;
//reg [15:0] opA2;
wire [15:0] aluResult;
reg [5:0] tapIndex;       // Tap index for the current filter coefficient
reg [15:0] currentSum;    // Temporary sum for accumulation
reg convolutionActive;    // Indicates convolution in progress

integer i;
reg [15:0] sum;

CMEM dut (.CLK(rclk),
	.A(A),
	.D(D),
	.CEN(CEN),
	.WEN(WEN),
	.Q(sramtoALU)
);

ALU tester(
	.ALU_en(ALU_en1),
	.opA(IMEMtoalu),
	.opB(sramtoALU),
	.opcode(OPCODE1),
	.Result(aluResult),
	.carry_out(carry_out1)
);


FIFO fifo (
        .rdata(fifotoIMEM), 
        .wdata(wdata),
        .wfull(wfull),
        .rempty(rempty),
        .winc(winc), 
        .rinc(rinc), 
        .wclk(wclk), 
        .rclk(rclk), 
        .wrst_n(wrst_n), 
        .rrst_n(rrst_n)
    );
IMEM  device(
		.clk(rclk),
		.resetn(resetn),
		.data_in(fifotoIMEM),
		.load_en(load_en),
		.read_en(read_en),
		.data_out(IMEMtoalu),
		.read(read)
	);


always @(posedge rclk or negedge resetn) begin
    if (~resetn) begin
        sum <= 16'd0;             // Reset the final sum
        currentSum <= 16'd0;      // Reset the current sum
	aluResult1 <= 16'd0;
        result <= 16'd0;          // Reset the result
        tapIndex <= 6'd0;         // Reset the tap index
        convolutionActive <= 0;   // Convolution is inactive
//$monitor("Time=%0t | tapIndex=%0d | currentSum=%0d | aluResult=%0d | sum=%0d | result=%0d",
         //$time, tapIndex, currentSum, aluResult, sum, result);
    end else if (read_en) begin
        convolutionActive <= 1;   // Start convolution
        if (tapIndex < numTaps) begin
//$monitor("Time=%0t | tapIndex=%0d | currentSum=%0d | aluResult=%0d | sum=%0d | result=%0d",
         //$time, tapIndex, currentSum, aluResult, sum, result);
	    currentSum <= currentSum + aluResult; // Accumulate ALU results
	    aluResult1 <= aluResult;
	    sum <= currentSum;
	    result <= currentSum;
            tapIndex <= tapIndex + 1;   
         // Move to the next tap
        end
	if (tapIndex == numTaps) begin
    	convolutionActive <= 0; // Convolution complete
    	result <= currentSum;   // Finalize result
	end 
    end
end

endmodule
