module access #(parameter width,parameter depth)(input [width-1:0][depth-1:0]mat,output reg [$clog2(width*depth):0]count); 
// width is size of each row, depth is no. of rows
// i hv synthesized fifo's, b4 so naming is similar to them
    integer i,j;
    always @(*) begin
        count=0;
        for(i=0;i<depth;i=i+1) begin
            for(j=0;j<width;j=j+1)begin
                if(mat[i][j] == '@') begin
                    if(j==0) begin
                        if(i==0) begin

                        end
                        else if(i==depth-1) begin

                        end
                        else begin

                        end
                    end
                    else if((j==0 | j==width-1) & i==0) begin

                    end
                end
            end
        end
    end
endmodule