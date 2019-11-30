`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module colchng_tb();

parameter DURATION = 100000;
reg clk, n_rst, i_vid_hsync, i_vid_vsync, i_vid_VDE;
reg [23:0] i_vid_data;

reg [3:0] btn;

wire [23:0] o_vid_data;
wire o_vid_hsync, o_vid_vsync, o_vid_VDE;

colour_change DUT (.clk(clk), .n_rst(n_rst), .i_vid_data(i_vid_data), .i_vid_hsync(i_vid_hsync), .i_vid_vsync(i_vid_vsync), .i_vid_VDE(i_vid_VDE), .o_vid_data(o_vid_data), .o_vid_hsync(o_vid_hsync), .o_vid_vsync(o_vid_vsync), .o_vid_VDE(o_vid_VDE), .btn(btn));

reg [11:0] hpix_cnt = 0;
reg [10:0] vpix_cnt = 0;

integer infile, outfile, r, endof;

initial
begin
    clk = 1'b0;
    n_rst = 1'b1;
    btn = 4'b0001;
    #10 n_rst = 1'b0;
    #10 n_rst = 1'b1;

end

always #10 begin
    if(!n_rst) begin
        hpix_cnt = 12'd0;
        vpix_cnt = 11'd0;
    end 
    else begin
        if (hpix_cnt == 12'd2199) begin
            hpix_cnt = 12'd0;
            if(vpix_cnt == 11'd1124) vpix_cnt = 11'd0;
            else vpix_cnt = vpix_cnt + 1'b1;
        end 
        else begin 
            hpix_cnt = hpix_cnt + 1'b1;
        end
    end
end

always @ * begin
    i_vid_hsync = ((hpix_cnt >= 88) && (hpix_cnt <= 131));
    i_vid_vsync = ((vpix_cnt >= 4) && (vpix_cnt <= 8));
    i_vid_VDE = ~(((hpix_cnt >= 0) && (hpix_cnt <= 279)) || ((vpix_cnt >= 0) && (vpix_cnt <= 44)));
end

always #5 clk = !clk;
integer finishedReading = 0;
integer readCount = 0, writeCount = 0;
initial begin
    infile = $fopen("pixelsin.txt","r");
    @(posedge n_rst)
    while (!$feof(infile)) begin
        @(posedge clk)
        if(i_vid_VDE) begin
            r = $fscanf(infile,"%d %d %d\n", i_vid_data[23:16], i_vid_data[15:8], i_vid_data[7:0]);
            readCount= readCount+1;
        end
    end
    $fclose(infile);
    finishedReading = 1;
end

//If there are X's at the start, the last lines are discarded. To fix delay vde, vsync, hsync in 
//readCount==readCount at the start, so another check is needed inside the loop, otherwise the last line is printed twice
initial begin
    outfile = $fopen("pixelsout.txt","w");
    //this was while(!$feof(outfile) but as the file is being written to, it doesn't have an end, so the loop never exits.
    while (writeCount<=readCount) begin
    @(posedge clk)
        if(o_vid_VDE)begin        
        if(writeCount<readCount) $fwrite(outfile,"%d %d %d\n", o_vid_data[23:16], o_vid_data[15:8], o_vid_data[7:0]);
        writeCount = writeCount+1;
        end
    end
    $fclose(outfile);
    //only finish when all the lines are written
    $finish;
end

endmodule

// 2073600 pixels
// 302400 horizontal blanking
// 86400 vertical blanking