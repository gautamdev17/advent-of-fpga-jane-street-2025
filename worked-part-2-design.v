`timescale 1ns/1ps

module exhaustive_access #
(
    parameter WIDTH = 10,
    parameter DEPTH = 10
)
(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire grid_in [0:DEPTH-1][0:WIDTH-1],
    output reg  [31:0] total_removed,
    output reg  done
);

    // FSM states
    localparam IDLE  = 0,
               LOAD  = 1,
               SCAN  = 2,
               REMOVE= 3,
               CHECK = 4,
               DONE  = 5;

    reg [2:0] state, next_state;

    reg grid [0:DEPTH-1][0:WIDTH-1];
    reg mark [0:DEPTH-1][0:WIDTH-1];

    integer r, c;
    integer removed_this_round;

    // ---------- neighbor wires ----------
    reg n00,n01,n02,n10,n12,n20,n21,n22;
    reg [3:0] n_count;
    reg has_up,has_down,has_left,has_right;

    // ---------- FSM sequential ----------
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // ---------- FSM combinational ----------
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:   if (start) next_state = LOAD;
            LOAD:   next_state = SCAN;
            SCAN:   next_state = REMOVE;
            REMOVE: next_state = CHECK;
            CHECK:  next_state = (removed_this_round == 0) ? DONE : SCAN;
            DONE:   next_state = DONE;
        endcase
    end

    // ---------- FSM datapath ----------
    always @(posedge clk) begin
        case (state)

            IDLE: begin
                done <= 0;
                total_removed <= 0;
            end

            LOAD: begin
                for (r=0;r<DEPTH;r=r+1)
                    for (c=0;c<WIDTH;c=c+1)
                        grid[r][c] <= grid_in[r][c];
            end

            SCAN: begin
                removed_this_round = 0;
                for (r=0;r<DEPTH;r=r+1)
                    for (c=0;c<WIDTH;c=c+1) begin
                        mark[r][c] = 0;
                        if (grid[r][c]) begin
                            has_up    = (r>0);
                            has_down  = (r<DEPTH-1);
                            has_left  = (c>0);
                            has_right = (c<WIDTH-1);

                            n00 = (has_up   && has_left ) ? grid[r-1][c-1] : 0;
                            n01 = (has_up               ) ? grid[r-1][c]   : 0;
                            n02 = (has_up   && has_right) ? grid[r-1][c+1] : 0;
                            n10 = (has_left            ) ? grid[r][c-1]   : 0;
                            n12 = (has_right           ) ? grid[r][c+1]   : 0;
                            n20 = (has_down && has_left ) ? grid[r+1][c-1] : 0;
                            n21 = (has_down            ) ? grid[r+1][c]   : 0;
                            n22 = (has_down && has_right) ? grid[r+1][c+1] : 0;

                            n_count = n00+n01+n02+n10+n12+n20+n21+n22;

                            if (n_count < 4) begin
                                mark[r][c] = 1;
                                removed_this_round = removed_this_round + 1;
                            end
                        end
                    end
            end

            REMOVE: begin
                for (r=0;r<DEPTH;r=r+1)
                    for (c=0;c<WIDTH;c=c+1)
                        if (mark[r][c])
                            grid[r][c] <= 0;

                total_removed <= total_removed + removed_this_round;
            end

            CHECK: begin end

            DONE: begin
                done <= 1;
            end

        endcase
    end

endmodule