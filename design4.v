//PART 1

module access #(parameter WIDTH = 16,parameter DEPTH = 16)(input [WIDTH-1:0]mat[DEPTH-1:0],//1=paper,0=nothin
output reg [$clog2(WIDTH*DEPTH+1)-1:0] count);

    integer i,j;
    //neighbourr wires, if they exist, then they will be assigned high
    reg n00,n01,n02;
    reg n10,n12; //n11 is not there, its the elemnet itself
    reg n20,n21,n22;
    reg [3:0] n_count; //this is the final neighbuor count, use 3:0 cuz count can go upto 8(1000in bin)
    reg has_up, has_down, has_left, has_right; //based on these condictions we will decide if the neighbours exits or not
    always @(*) begin
        count=0;
        for (i=0;i<DEPTH;i=i+1) begin
            for(j=0;j<WIDTH;j=j+1) begin
                if (mat[i][j]) begin// i have converted @ and . to 1 and 0. we will need the input matrix to undergo this conversion
                    //now i will use these regs for conditions to check existence of neighoubts
                    has_up=(i>0);
                    has_down =(i<DEPTH-1);
                    has_left=(j>0);
                    has_right=(j<WIDTH-1);
                    //now store 0/1 based on existence of neighbours using the previos regs
                    /*
                        for a better understandingt this shows:
                            n00 n01 n02
                            n10 n11 n12 //n11 is element itself
                            n20 n21 n22
                            */
                    n00=(has_up&&has_left)?mat[i-1][j-1]:1'b0; 
                    n01=(has_up)?mat[i-1][j]:1'b0;
                    n02=(has_up && has_right)?mat[i-1][j+1]:1'b0;
                    n10=(has_left)?mat[i][j-1]:1'b0;
                    n12=(has_right)?mat[i][j+1]:1'b0;
                    n20=(has_down && has_left)?mat[i+1][j-1]:1'b0;
                    n21=(has_down)?mat[i+1][j]:1'b0;
                    n22=(has_down&&has_right)?mat[i+1][j+1]:1'b0;
                    // no latches inferrred. everu reg is given a defined path in all cases.
                    n_count=n00+n01+n02+n10+n12+n20+n21+n22;

                    if (n_count<4)//check for accessibility
                        count=count+1'b1;
                end
            end
        end
    end
endmodule