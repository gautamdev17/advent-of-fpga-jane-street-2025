`timescale 1ns/1ps

module aoc_day #
(
    parameter WIDTH = 10,
    parameter DEPTH = 10
)
(
    input reg grid_in [0:DEPTH-1][0:WIDTH-1]
);

    integer r, c;
    integer removed_this_round;
    integer total_removed;
    integer stable;

    reg grid [0:DEPTH-1][0:WIDTH-1];

    // -------- neighbor count ----------
    function integer neighbors;
        input integer r, c;
        integer dr, dc;
        begin
            neighbors = 0;
            for (dr = -1; dr <= 1; dr = dr + 1)
                for (dc = -1; dc <= 1; dc = dc + 1)
                    if (!(dr == 0 && dc == 0))
                        if (r+dr >= 0 && r+dr < DEPTH &&
                            c+dc >= 0 && c+dc < WIDTH)
                            neighbors = neighbors + grid[r+dr][c+dc];
        end
    endfunction

    initial begin
        // 🔥 FIX: WAIT FOR TB TO INITIALIZE
        #1;

        // COPY INPUT GRID
        for (r = 0; r < DEPTH; r = r + 1)
            for (c = 0; c < WIDTH; c = c + 1)
                grid[r][c] = grid_in[r][c];

        total_removed = 0;
        stable = 0;

        // ITERATE UNTIL STABLE
        while (stable == 0) begin
            removed_this_round = 0;

            for (r = 0; r < DEPTH; r = r + 1)
                for (c = 0; c < WIDTH; c = c + 1)
                    if (grid[r][c] && neighbors(r,c) < 4) begin
                        grid[r][c] = 0;
                        removed_this_round = removed_this_round + 1;
                    end

            if (removed_this_round == 0)
                stable = 1;
            else
                total_removed = total_removed + removed_this_round;
        end

        $display("TOTAL REMOVED = %0d", total_removed);
        $finish;
    end
endmodule


`timescale 1ns/1ps

module tb;

    parameter WIDTH = 10;
    parameter DEPTH = 10;

    reg grid [0:DEPTH-1][0:WIDTH-1];

    aoc_day #(WIDTH, DEPTH) dut (.grid_in(grid));

    initial begin
        // ..@@.@@@@.
        grid[0][0]=0; grid[0][1]=0; grid[0][2]=1; grid[0][3]=1; grid[0][4]=0;
        grid[0][5]=1; grid[0][6]=1; grid[0][7]=1; grid[0][8]=1; grid[0][9]=0;

        // @@@.@.@.@@
        grid[1][0]=1; grid[1][1]=1; grid[1][2]=1; grid[1][3]=0; grid[1][4]=1;
        grid[1][5]=0; grid[1][6]=1; grid[1][7]=0; grid[1][8]=1; grid[1][9]=1;

        // @@@@@.@.@@
        grid[2][0]=1; grid[2][1]=1; grid[2][2]=1; grid[2][3]=1; grid[2][4]=1;
        grid[2][5]=0; grid[2][6]=1; grid[2][7]=0; grid[2][8]=1; grid[2][9]=1;

        // @.@@@@..@.
        grid[3][0]=1; grid[3][1]=0; grid[3][2]=1; grid[3][3]=1; grid[3][4]=1;
        grid[3][5]=1; grid[3][6]=0; grid[3][7]=0; grid[3][8]=1; grid[3][9]=0;

        // @@.@@@@.@@
        grid[4][0]=1; grid[4][1]=1; grid[4][2]=0; grid[4][3]=1; grid[4][4]=1;
        grid[4][5]=1; grid[4][6]=1; grid[4][7]=0; grid[4][8]=1; grid[4][9]=1;

        // .@@@@@@@.@
        grid[5][0]=0; grid[5][1]=1; grid[5][2]=1; grid[5][3]=1; grid[5][4]=1;
        grid[5][5]=1; grid[5][6]=1; grid[5][7]=1; grid[5][8]=0; grid[5][9]=1;

        // .@.@.@.@@@
        grid[6][0]=0; grid[6][1]=1; grid[6][2]=0; grid[6][3]=1; grid[6][4]=0;
        grid[6][5]=1; grid[6][6]=0; grid[6][7]=1; grid[6][8]=1; grid[6][9]=1;

        // @.@@@.@@@@
        grid[7][0]=1; grid[7][1]=0; grid[7][2]=1; grid[7][3]=1; grid[7][4]=1;
        grid[7][5]=0; grid[7][6]=1; grid[7][7]=1; grid[7][8]=1; grid[7][9]=1;

        // .@@@@@@@@.
        grid[8][0]=0; grid[8][1]=1; grid[8][2]=1; grid[8][3]=1; grid[8][4]=1;
        grid[8][5]=1; grid[8][6]=1; grid[8][7]=1; grid[8][8]=1; grid[8][9]=0;

        // @.@.@@@.@.
        grid[9][0]=1; grid[9][1]=0; grid[9][2]=1; grid[9][3]=0; grid[9][4]=1;
        grid[9][5]=1; grid[9][6]=1; grid[9][7]=0; grid[9][8]=1; grid[9][9]=0;
    end

endmodule