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
    output o_vid_hsync,
    output o_vid_vsync,
    output o_vid_VDE
    );
    
    reg [7:0] skin_y = 8'd80;
    reg [7:0] skin_cb_min = 8'd85;
    reg [7:0] skin_cb_max = 8'd135;
    reg [7:0] skin_cr_min = 8'd135;
    reg [7:0] skin_cr_max = 8'd180;
    
    reg [7:0] y;
    reg [7:0] cb;
    reg [7:0] cr;
    
    reg [7:0] r  = 8'd0;
    reg [7:0] g = 8'd255;
    reg [7:0] b = 8'd0;
    
    always @(posedge clk) begin
        y <= (i_vid_data[23:16] + 2* i_vid_data[15:8] +i_vid_data[7:0])/4;  
        cb <= i_vid_data[23:16] - i_vid_data[15:8];
        cr <= i_vid_data[7:0] - i_vid_data[15:8];
        
        if(y > skin_y && skin_cb_min < cb && skin_cb_max > cb && skin_cr_min < cr && skin_cr_max > cr) begin
            o_vid_data[23:16] <= r;
            o_vid_data[15:8] <= g;
            o_vid_data[7:0] <= b;
        end else begin
            o_vid_data[23:16] <= 8'd255; // i_vid_data[23:16];
            o_vid_data[15:8] <= i_vid_data[15:8];
            o_vid_data[7:0] <= i_vid_data[7:0];
        end
    end
    
    
    assign o_vid_hsync = i_vid_hsync;
    assign o_vid_vsysc = i_vid_vsync;
    assign o_vid_VDE = i_vid_VDE;
    
endmodule
