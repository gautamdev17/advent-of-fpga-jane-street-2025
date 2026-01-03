`timescale 1ns/1ps

module tb;

    parameter WIDTH = 10;
    parameter DEPTH = 10;

    reg grid [0:DEPTH-1][0:WIDTH-1];

    reg [8*WIDTH-1:0] grid_ascii [0:DEPTH-1];

    exhaustive_access #(WIDTH, DEPTH) dut (.grid_in(grid));

    integer r, c;

    initial begin
        // ---------- INPUT IN @ . FORM ----------
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

        // ---------- CONVERT TO 1 / 0 ----------
        for (r = 0; r < DEPTH; r = r + 1) begin
            for (c = 0; c < WIDTH; c = c + 1) begin
                if (grid_ascii[r][8*(WIDTH-c)-1 -: 8] == "@")
                    grid[r][c] = 1'b1;
                else
                    grid[r][c] = 1'b0;
            end
        end
    end

endmodule