`timescale 1ns/1ps

module wptr_full (wfull, waddr, wptr, wq2_rptr, winc, wclk, wrst_n
    );

    parameter ADDR_SIZE = 6;

    output reg wfull;
    output [ADDR_SIZE-1:0] waddr;
    output reg [ADDR_SIZE :0] wptr;
    input [ADDR_SIZE :0] wq2_rptr;
    input winc, wclk, wrst_n;


    reg [ADDR_SIZE:0] wbin;                     // Binary write pointer
    wire [ADDR_SIZE:0] wgray_next, wbin_next;   // Next write pointer in gray and binary code
    wire wfull_val;                             // Full flag value

    // Synchronous FIFO write pointer (gray code)
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)            // Reset the FIFO
            {wbin, wptr} <= 0;
        else
            {wbin, wptr} <= {wbin_next, wgray_next}; // Shift the write pointer
    end

    assign waddr = wbin[ADDR_SIZE-1:0];             // Write address calculation from the write pointer
    assign wbin_next = wbin + (winc & ~wfull);       // Increment the write pointer if not full
    assign wgray_next = (wbin_next>>1) ^ wbin_next;    // Convert binary to gray code

    // Check if the FIFO is full
    //------------------------------------------------------------------
    // Simplified version of the three necessary full-tests:
    // assign wfull_val=((wg_next[ADDR_SIZE] !=wq2_rptr[ADDR_SIZE] ) &&
    // (wg_next[ADDR_SIZE-1] !=wq2_rptr[ADDR_SIZE-1]) &&
    // (wg_next[ADDR_SIZE-2:0]==wq2_rptr[ADDR_SIZE-2:0]));
    //------------------------------------------------------------------
    assign wfull_val = (wgray_next=={~wq2_rptr[ADDR_SIZE:ADDR_SIZE-1], wq2_rptr[ADDR_SIZE-2:0]});

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)            // Reset the full flag
            wfull <= 1'b0;
        else
            wfull <= wfull_val; // Update the full flag
    end
endmodule
