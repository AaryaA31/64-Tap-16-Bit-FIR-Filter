`timescale 1ns/1ps


module test_tb();
    parameter numTaps = 64;        // Number of filter taps
    parameter numSamples = 64;    // Number of input samples

    // Testbench signals
    reg rclk;
    reg wclk;
    reg resetn;
    reg [5:0] A;
    reg [15:0] D;
    reg CEN;
    reg WEN;
    reg [3:0] OPCODE1;
    reg ALU_en1;
    reg [15:0] wdata;
    reg winc, rinc, wrst_n, rrst_n;
    reg load_en, read_en;
    wire [15:0] result;
    wire carry_out1;
    wire wfull, rempty;
    wire [5:0] read;
    wire [15:0] aluResult1;

    // Instantiate the design
    test uut (
        .rclk(rclk),
        .A(A),
        .CEN(CEN),
        .WEN(WEN),
        .D(D),
        .OPCODE1(OPCODE1),
        .result(result),
        .carry_out1(carry_out1),
        .ALU_en1(ALU_en1),
        .wdata(wdata),
        .wclk(wclk),
        .wfull(wfull),
        .rempty(rempty),
        .winc(winc),
        .rinc(rinc),
        .wrst_n(wrst_n),
        .rrst_n(rrst_n),
        .resetn(resetn),
        .load_en(load_en),
        .read_en(read_en),
        .read(read),
	.aluResult1(aluResult1)
    );

    integer i;
integer j;

    // Generate clocks
    always #500 rclk = ~rclk;   // Read clock (fast)
    always #50000 wclk = ~wclk;   // Write clock (slow)

    initial begin
        // Initialize signals
        rclk = 0;
        wclk = 0;
        resetn = 0;
        A = 0;
        D = 0;
        CEN = 1;
        WEN = 0;
        OPCODE1 = 4'b0010;   // Multiplication opcode
        ALU_en1 = 0;
        wdata = 0;
        winc = 0;
        rinc = 0;
        wrst_n = 0;
        rrst_n = 0;
        load_en = 0;
        read_en = 0;
        #1000;  // Wait for initialization
        // Reset the design
        resetn = 0;
        wrst_n = 0;
        rrst_n = 0;
        #1000;
        resetn = 1;
        wrst_n = 1;
        rrst_n = 1;

        // Load coefficients into CMEM
#125;
        CEN = 0;  // Enable CMEM
        WEN = 0;  // Write enable

        for (i = 0; i < numTaps; i = i + 1) begin
#125;
            A = i;
            D = 5;  // Coefficients: 1, 2, ..., numTaps
            @(posedge (rclk));
        end
    
        // Load input samples into FIFO
        winc = 1;  // Enable write to FIFO
        for (j = 0; j < numSamples; j = j + 1) begin
	wdata = 5 ;
            #100000;	        
		
		@(posedge wclk);
        end
        winc = 0;
#50000;
        // Transfer data from FIFO to IMEM
	for (i = 0; i < numSamples; i = i + 1) begin
        load_en = 1;
        rinc = 1;  // Enable FIFO read
        #1000;     // Allow time for all data to transfer
        load_en = 0;
        rinc = 0;
	end
        // Perform convolution
for (i = 0; i < numSamples; i = i + 1) begin
A=i;
	WEN=1;
        read_en = 1;   // Enable IMEM read
        ALU_en1 = 1;   // Enable ALU
        #1000; 
	         // Allow time for convolution
	end


        // Display results
	
	#1000;

        $display("Convolution Result: %d", result);
		
	#1000; // Ensure simulation has completed
  

        // Finish simulation
        #1000;
        $finish;
    end

endmodule


    // Write result to file at the end of simulation
    /*initial begin
        #1000; // Ensure simulation has completed
        $writememh("result.txt", result);
        $display("Result has been written to result.txt");
        $finish;
    end*/
