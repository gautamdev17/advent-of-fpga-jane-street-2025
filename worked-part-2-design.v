`timescale 1ns/1ps

module exhaustive_access #(parameter WIDTH = 10,parameter DEPTH = 10)(input reg grid_in [0:DEPTH-1][0:WIDTH-1]);
    integer r,c;
    integer removed_this_round;
    integer total_removed;
    integer stable;
    reg grid [0:DEPTH-1][0:WIDTH-1];
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
        #1;
        for (r = 0; r < DEPTH; r = r + 1)
            for (c = 0; c < WIDTH; c = c + 1)
                grid[r][c] = grid_in[r][c];

        total_removed = 0;
        stable = 0;

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