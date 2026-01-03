`timescale 1ns/1ps

module tb;

    parameter WIDTH = 10;
    parameter DEPTH = 10;

    reg start;
    reg grid [0:DEPTH-1][0:WIDTH-1];
    reg [8*WIDTH-1:0] grid_ascii [0:DEPTH-1];

    wire [31:0] total_removed;
    wire done;

    exhaustive_access #(WIDTH, DEPTH) dut (
        .start(start),
        .grid_in(grid),
        .total_removed(total_removed),
        .done(done)
    );

    integer r, c;

    initial begin
        start = 0;

        grid_ascii[0] = "..@@.@@@@.";
        grid_ascii[1] = "@@@.@.@.@@";
        grid_ascii[2] = "@@@@@.@.@@";
        grid_ascii[3] = "@.@@@@..@.";
        grid_ascii[4] = "@@.@@@@.@@";
        grid_ascii[5] = ".@@@@@@@.@";
        grid_ascii[6] = ".@.@.@.@@@";
        grid_ascii[7] = "@.@@@.@@@@";
        grid_ascii[8] = ".@@@@@@@@.";
        grid_ascii[9] = "@.@.@@@.@.";

        // convert @ → 1, . → 0
        for (r=0; r<DEPTH; r=r+1)
            for (c=0; c<WIDTH; c=c+1)
                grid[r][c] =
                    (grid_ascii[r][8*(WIDTH-c)-1 -: 8] == "@");

        #1;
        start = 1;   // ✅ inputs now valid

        wait(done);
        $display("TOTAL REMOVED = %0d", total_removed);
        $finish;
    end
endmodule