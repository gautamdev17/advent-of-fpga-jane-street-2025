`timescale 1ns/1ps

module exhaustive_access #(
    parameter WIDTH = 10,
    parameter DEPTH = 10
)
(
    input  reg start,
    input  reg grid_in [0:DEPTH-1][0:WIDTH-1],
    output reg [31:0] total_removed,
    output reg done
);

    integer r, c;
    integer removed_this_round;
    integer stable;

    reg grid [0:DEPTH-1][0:WIDTH-1];

    // ---- neighbor wires (hardware style) ----
    reg n00,n01,n02,n10,n12,n20,n21,n22;
    reg has_up, has_down, has_left, has_right;
    reg [3:0] n_count;

    initial begin
        done = 0;
        total_removed = 0;

        // wait for TB
        wait(start);

        // copy grid
        for (r=0; r<DEPTH; r=r+1)
            for (c=0; c<WIDTH; c=c+1)
                grid[r][c] = grid_in[r][c];

        stable = 0;

        while (!stable) begin
            removed_this_round = 0;

            for (r=0; r<DEPTH; r=r+1) begin
                for (c=0; c<WIDTH; c=c+1) begin
                    if (grid[r][c]) begin
                        // bounds
                        has_up    = (r > 0);
                        has_down  = (r < DEPTH-1);
                        has_left  = (c > 0);
                        has_right = (c < WIDTH-1);

                        // neighbors
                        n00 = (has_up   && has_left ) ? grid[r-1][c-1] : 0;
                        n01 = (has_up              ) ? grid[r-1][c]   : 0;
                        n02 = (has_up   && has_right) ? grid[r-1][c+1] : 0;
                        n10 = (has_left            ) ? grid[r][c-1]   : 0;
                        n12 = (has_right           ) ? grid[r][c+1]   : 0;
                        n20 = (has_down && has_left ) ? grid[r+1][c-1] : 0;
                        n21 = (has_down            ) ? grid[r+1][c]   : 0;
                        n22 = (has_down && has_right) ? grid[r+1][c+1] : 0;

                        n_count = n00+n01+n02+n10+n12+n20+n21+n22;

                        if (n_count < 4) begin
                            grid[r][c] = 0;
                            removed_this_round = removed_this_round + 1;
                        end
                    end
                end
            end

            if (removed_this_round == 0)
                stable = 1;
            else
                total_removed = total_removed + removed_this_round;
        end

        done = 1;
    end
endmodule