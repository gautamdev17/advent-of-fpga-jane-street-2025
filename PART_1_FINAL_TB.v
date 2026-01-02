`timescale 1ns/1ps
module tb_access;
    parameter WIDTH = 10;
    parameter DEPTH = 10;
    reg [WIDTH-1:0] mat [0:DEPTH-1];
    wire [$clog2(WIDTH*DEPTH+1)-1:0] count;
    access #(WIDTH,DEPTH) dut (.mat(mat),.count(count));
    initial begin
        //covnerting the input matrix given in AoC day 4 to binary
        //@=1,.=0;
        /*
        ..@@.@@@@.
        @@@.@.@.@@
        @@@@@.@.@@
        @.@@@@..@.
        @@.@@@@.@@
        .@@@@@@@.@
        .@.@.@.@@@
        @.@@@.@@@@
        .@@@@@@@@.
        @.@.@@@.@.*/
        // ..@@.@@@@.
        mat[0] = 10'b0011011110;
        // @@@.@.@.@@
        mat[1] = 10'b1110101011;
        // @@@@@.@.@@
        mat[2] = 10'b1111101011;
        // @.@@@@..@.
        mat[3] = 10'b1011110010;
        // @@.@@@@.@@
        mat[4] = 10'b1101111011;
        // .@@@@@@@.@
        mat[5] = 10'b0111111110;
        // .@.@.@.@@@
        mat[6] = 10'b0101010111;
        // @.@@@.@@@@
        mat[7] = 10'b1011101111;
        // .@@@@@@@@.
        mat[8] = 10'b0111111111;
        // @.@.@@@.@.
        mat[9] = 10'b1010111010;
        #1;
        $display("ACCESSIBLE COUNT = %0d", count);
        $finish;
    end
endmodule