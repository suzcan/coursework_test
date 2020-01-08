`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2020 11:38:00
// Design Name: 
// Module Name: bram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Single-Port BRAM with Byte-wide Write Enable
//	Read-First mode
//	Single-process description
//	Compact description of the write with a generate-for 
//   statement
//	Column width and number of columns easily configurable
//
// bytewrite_ram_1b.v
//

/*
// bram returning mask values
module bram (clk, we, addr, di, do, re,
    is_edge, do_tl, do_tc, do_tr, do_l, do_r, do_bl, do_bc, do_br);

// WIDTH*HEIGHT OF IMAGE
parameter WIDTH = 205;
parameter SIZE = 63140; // 251535 
// 2^(ADDR_WIDTH) > SIZE to have all addresses 
parameter ADDR_WIDTH = 16; //18; 

// 3 RGB of COL_WIDTH
parameter COL_WIDTH = 8; 
parameter NB_COL = 3; 

input	clk;
input	[NB_COL-1:0]	we;
input   re;
input	[ADDR_WIDTH-1:0]	addr;
input	[NB_COL*COL_WIDTH-1:0] di;
input   is_edge;
output  reg [NB_COL*COL_WIDTH-1:0] do;
output  reg [NB_COL*COL_WIDTH-1:0] do_tl, do_tc, do_tr, do_l, do_r, do_bl, do_bc, do_br;

// array of SIZE (NB_COL*COL_WIDTH)-bit vectors 
reg	[NB_COL*COL_WIDTH-1:0] RAM [SIZE-1:0];

always @(posedge clk)
begin
    // sequential read
    if(re) begin
        do <= RAM[addr]; // center pixel
        
        if(~is_edge) begin
            do_tl <= RAM[addr - 1 - WIDTH]; // top left
            do_tc <= RAM[addr - WIDTH];     // top center
            do_tr <= RAM[addr + 1 - WIDTH]; // top right
            do_l <= RAM[addr - 1];          // left
            do_r <= RAM[addr + 1];          // right
            do_bl <= RAM[addr - 1 + WIDTH]; // bottom left
            do_bc <= RAM[addr + WIDTH];     // bottom centre
            do_br <= RAM[addr + 1 + WIDTH]; // bottom right
        end else begin
            do_tl <= 23'd0;
            do_tc <= 23'd0;
            do_tr <= 23'd0;
            do_l <=  23'd0;
            do_r <=  23'd0;
            do_bl <= 23'd0;
            do_bc <= 23'd0;
            do_bl <= 23'd0;
        end 
        
    end
end

generate genvar i;
for (i = 0; i < NB_COL; i = i+1)
begin
    always @(posedge clk)
    begin
        if (we[i])
            RAM[addr][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= di[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
    end 
end
endgenerate

endmodule
/**/

///* working block ram module
module bram (clk, we, addr, di, do, re);

// WIDTH*HEIGHT OF IMAGE
parameter SIZE = 63140; // 251535 
// 2^(ADDR_WIDTH) > SIZE to have all addresses 
parameter ADDR_WIDTH = 16; //18; 

// 3 RGB of COL_WIDTH
parameter COL_WIDTH = 8; 
parameter NB_COL = 3; 

input	clk;
input	[NB_COL-1:0]	we;
input   re;
input	[ADDR_WIDTH-1:0]	addr;
input	[NB_COL*COL_WIDTH-1:0] di;
output reg [NB_COL*COL_WIDTH-1:0] do;

// array of SIZE (NB_COL*COL_WIDTH)-bit vectors 
reg	[NB_COL*COL_WIDTH-1:0] RAM [SIZE-1:0];

always @(posedge clk)
begin
    // sequential read
    if(re)
        do <= RAM[addr];
    
end

generate genvar i;
for (i = 0; i < NB_COL; i = i+1)
begin
    always @(posedge clk)
    begin
        if (we[i])
            RAM[addr][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= di[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
    end 
end
endgenerate

endmodule

/**/