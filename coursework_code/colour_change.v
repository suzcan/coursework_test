`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2019 13:29:11
// Design Name: 
// Module Name: colour_change
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


module colour_change(
    input clk,
    input n_rst,
    input [23:0] i_vid_data,
    input i_vid_hsync,
    input i_vid_vsync,
    input i_vid_VDE,
    
    input [3:0] btn,
    
    output reg [23:0] o_vid_data,
    output reg o_vid_hsync,
    output reg o_vid_vsync,
    output reg o_vid_VDE
    );
    
    reg [7:0] skin_y = 8'd80;
    reg [7:0] skin_cb_min = 8'd77; // 85
    reg [7:0] skin_cb_max = 8'd135; //135
    reg [7:0] skin_cr_min = 8'd120; // 135
    reg [7:0] skin_cr_max = 8'd173;  // 180
    
    reg [7:0] y;
    reg [7:0] cb;
    reg [7:0] cr;
    
    reg [7:0] r  = 8'd255;
    reg [7:0] g = 8'd0;
    reg [7:0] b = 8'd255;
    
    wire [7:0] red = i_vid_data[23:16];
    wire [7:0] green = i_vid_data[15:8];
    wire [7:0] blue = i_vid_data[7:0];
    
    reg [7:0] ans;
    reg [7:0] abs_answ;
    
    wire hsync = i_vid_hsync;
    wire vsync = i_vid_vsync;
    wire VDE = i_vid_VDE;
    
    always @(posedge clk) begin
        y <= 16 + (65.738 * red)/256 + (129.057 * green)/256 + (25.064 * blue)/256;
        cb <= 128 - (37.945 * red)/256 - (74.494 * green)/256 + (112.439 * blue)/256;
        cr <= 128 + (112.439 * red)/256 - (94.154 * green)/256 - (18.285 * blue)/256;
        
        /*
        o_vid_data[23:16] <= y;
        o_vid_data[15:8] <= cb;
        o_vid_data[7:0] <= cr;
        */
  
        if(y > skin_y && skin_cb_min < cb && skin_cb_max > cb && skin_cr_min < cr && skin_cr_max > cr) begin
            o_vid_data[23:16] <= i_vid_data[23:16];
            o_vid_data[15:8] <= i_vid_data[15:8];
            o_vid_data[7:0] <= i_vid_data[7:0];
        end else begin
            o_vid_data[23:16] <= r;
            o_vid_data[15:8] <= g;
            o_vid_data[7:0] <= b;
        end
        
        o_vid_hsync <= hsync;
        o_vid_vsync <= vsync;
        o_vid_VDE <= VDE;
        
    end
    
endmodule
