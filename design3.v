//PART 1
// i still dont think part 1 is fpga freindly

module access #(parameter width,parameter depth)(input [depth-1:0][width-1:0]mat,output reg [$clog2(width*depth):0]count);
// width is size of each row, depth is no. of rows
// i hv synthesized fifo's, b4 so naming is similar to them
// got a software perspective to the problem
/*i think its a really easy problem

im thinking of convolutional neural networks, i find the similar to that
maybe a filtering layer is what i need

what do i need to filter?
everytime i hit a '@'
check-->valid neighbours-->'@'

thats all

bro all i need is an offset algorithm and check each neighbour

if the offset + the index === valdi?
    then go for it and check if @*/

    integer i,j;
    integer oi, oj; // lets have two variables for offsets on the x and y axisrr
    integer n_count; // neighbiour count if <4 add
    always @(*) begin
        count=0;
        for(i=0;i<depth;i=i+1) begin
            for(j=0;j<width;j=j+1)begin
                if (mat[i][j] == '@') begin // i dont think '@' is synthesizable, the data must first be preprocessed and convert
                                                    //@ to 1 and . to 0
                    n_count = 0; // set to 0 at first
                    for (oi=-1;oi <= 1;oi =oi+1) begin //offsets range from -1 to 1, except of 0, think of it like a filter layer on the selected elemnet
                        for (oj=-1;oj<=1;oj=oj+1) begin
                            if (!(oi==0&&oj==0)) begin//skip thesame elemtent
                                if ((i+oi)>=0&&(i+oi)<depth &&
                                    (j+oj)>=0&&(j+oj)<width) begin /// the boundary valid conditions
                                    if (mat[i+oi][j+oj] == '@') // cjheck if equal to @
                                        n_count = n_count + 1;
                                end
                            end
                        end
                    end
                    if (n_count < 4) // final accessability check
                        count=count+1;
                end
            end
        end
    end
endmodule

// i also think this is a good combinational logic, no latches have been inferred. we dont wanna end up doing timing analysis for latches.

//testbench coming soon