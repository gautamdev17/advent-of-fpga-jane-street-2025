//PART 1

module access #(parameter width,parameter depth)(input [width-1:0][depth-1:0]mat,output reg [$clog2(width*depth):0]count); 
// width is size of each row, depth is no. of rows
// i hv synthesized fifo's, b4 so naming is similar to them
// got a software perspective to the problem
    integer i,j;
    always @(*) begin
        count=0;
        for(i=0;i<depth;i=i+1) begin
            for(j=0;j<width;j=j+1)begin
                if(mat[i][j] == '@') begin
                    if(j==0) begin
                        if(i==0) begin // corner case

                        end
                        else if(i==depth-1) begin // corner case

                        end
                        else begin // edge case

                        end
                    end
                    else if(i==0) begin
                        if(j==0) begin // corner case

                        end
                        else if(j==depth-1) begin // corner case

                        end
                        else begin // edge cases

                        end
                    end
                    else begin //normal case

                    end
                end
            end
        end
    end
endmodule