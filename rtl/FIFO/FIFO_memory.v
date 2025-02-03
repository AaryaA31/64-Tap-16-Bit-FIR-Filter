`timescale 1ns/1ps
module FIFO_memory (rdata, wdata, waddr, raddr, wclk_en, wfull, wclk
    );

    parameter DATA_SIZE = 16,
	      ADDR_SIZE = 6;

    output [DATA_SIZE-1:0] rdata;
    input [DATA_SIZE-1:0] wdata;
    input [ADDR_SIZE-1:0] raddr;
    input [ADDR_SIZE-1:0] waddr;
    input wclk_en, wfull, wclk;

    localparam DEPTH = 1<<ADDR_SIZE;     // Depth of the FIFO memory
    reg [DATA_SIZE-1:0] mem [0:DEPTH-1];// Memory array

    assign rdata = mem[raddr];          // Read data

    always @(posedge wclk)
        if (wclk_en && !wfull) mem[waddr] <= wdata; // Write data

endmodule

