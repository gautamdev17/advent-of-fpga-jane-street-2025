//PART 2
// we can invoke hardware unit in previous part,basically we can first create instance of part 1 module and reuse it
// maybe with a bit of modification
// since this is part has a sequence, i think modelling this into a sequential circuit is the best way
module exhaustive_access #(parameter WIDTH = 16,parameter DEPTH = 16)(input [WIDTH-1:0]mat_init[DEPTH-1:0],input clk,input reset//1=paper,0=nothin
output reg [$clog2(WIDTH*DEPTH+1)-1:0]count,output reg done);//added flag regs
    reg [WIDTH-1:0]mat_out[DEPTH-1:0];
    reg [WIDTH-1:0]mat_in[DEPTH-1:0];
    reg [$clog2(WIDTH*DEPTH+1)-1:0] removed_q;
    reg started;
    wire [$clog2(WIDTH*DEPTH+1)-1:0]removed;

    remove_accessible inst1 #(WIDTH,DEPTH)(mat_in,mat_out,removed);//instantiation this will do the math for uss
    // now i haveto build a top level software approach then
     //go into the hardware low level design
    integer i;
    always @(posedge clk) begin
    if(reset) begin
        for(i=0;i<DEPTH;i=i+1)
            mat_in[i] <= mat_init[i];
        count <= 0;
        done  <= 0;
        removed_q <= 0;
        started <= 0;
    end
    else if(!done) begin
    removed_q <= removed;

    if(started && removed_q == 0) begin
        done <= 1'b1;
    end
    else begin
        started <= 1'b1;
        count <= count + removed_q;
        for(i=0;i<DEPTH;i=i+1)
            mat_in[i] <= mat_out[i];
    end
end
end
endmodule

// PART 1 modified to combinational one sweep removal
module remove_accessible #(parameter WIDTH = 16,parameter DEPTH = 16)(input [WIDTH-1:0]mat_in[DEPTH-1:0],//1=paper,0=nothin
    output reg [WIDTH-1:0]mat_out[DEPTH-1:0],output reg [$clog2(WIDTH*DEPTH+1)-1:0]removed);
    integer i,j;
    reg n00,n01,n02,n10,n12,n20,n21,n22;//n11 is not there, its the elemnet itself
    reg [3:0]n_count;
    reg has_up,has_down,has_left,has_right;

    always @(*) begin
        removed=0;
        //compute removal
        for(i=0;i<DEPTH;i=i+1) begin
            for(j=0;j<WIDTH;j=j+1) begin
                mat_out[i][j]=mat_in[i][j];
                n_count = 4'b0;
                if(mat_in[i][j]) begin
                    has_up=(i>0);
                    has_down=(i<DEPTH-1);
                    has_left =(j>0);
                    has_right=(j<WIDTH-1);
                    n00=(has_up&&has_left)?mat_in[i-1][j-1]:1'b0;
                    n01=(has_up)?mat_in[i-1][j]:1'b0;
                    n02=(has_up&&has_right)?mat_in[i-1][j+1]:1'b0;
                    n10=(has_left)?mat_in[i][j-1]:1'b0;
                    n12=(has_right)?mat_in[i][j+1]:1'b0;
                    n20=(has_down&&has_left)?mat_in[i+1][j-1]:1'b0;
                    n21=(has_down)?mat_in[i+1][j]:1'b0;
                    n22=(has_down&& has_right)?mat_in[i+1][j+1]:1'b0;
                    n_count = 0;
                    n_count=n00+n01+n02+n10+n12+n20+n21+n22;
                    // remove accessible paper
                    if(n_count < 4) begin
                        mat_out[i][j]=1'b0;
                        removed=removed+1'b1;
                    end
                end
            end
        end
    end
endmodule