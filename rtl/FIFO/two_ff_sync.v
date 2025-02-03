`timescale 1ns/1ps

module two_ff_sync (q2, din, clk, rst_n
    );

    parameter SIZE = 7;
    output reg [SIZE-1:0] q2;
    input [SIZE-1:0] din;
    input clk, rst_n ;
    reg [SIZE-1:0] q1; // Output of the first flip-flop

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            {q2, q1} <= 0;          // Reset the FIFO
        else
            {q2, q1} <= {q1, din};  // Shift the data
    end

endmodule
 

