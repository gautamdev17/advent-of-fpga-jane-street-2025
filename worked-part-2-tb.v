`timescale 1ns/1ps

module tb;

    parameter WIDTH = 10;
    parameter DEPTH = 10;

    reg clk = 0;
    reg rst = 1;
    reg start = 0;

    reg grid [0:DEPTH-1][0:WIDTH-1];
    reg [8*WIDTH-1:0] ascii [0:DEPTH-1];

    wire [31:0] total_removed;
    wire done;

    exhaustive_access #(WIDTH,DEPTH) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .grid_in(grid),
        .total_removed(total_removed),
        .done(done)
    );

    always #5 clk = ~clk;

    integer r,c;

    initial begin
        ascii[0] = "..@@.@@@@.";
        ascii[1] = "@@@.@.@.@@";
        ascii[2] = "@@@@@.@.@@";
        ascii[3] = "@.@@@@..@.";
        ascii[4] = "@@.@@@@.@@";
        ascii[5] = ".@@@@@@@.@";
        ascii[6] = ".@.@.@.@@@";
        ascii[7] = "@.@@@.@@@@";
        ascii[8] = ".@@@@@@@@.";
        ascii[9] = "@.@.@@@.@.";

        for (r=0;r<DEPTH;r=r+1)
            for (c=0;c<WIDTH;c=c+1)
                grid[r][c] = (ascii[r][8*(WIDTH-c)-1 -: 8] == "@");

        #20 rst = 0;
        #10 start = 1;
        #10 start = 0;

        wait(done);
        $display("TOTAL REMOVED = %0d", total_removed);
        $finish;
    end
endmodule