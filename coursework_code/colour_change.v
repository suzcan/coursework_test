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
    
    wire [23:0] out1, out2;
    wire hsync, vsync, vde;
    always@* begin
        case(btn)
            1:begin o_vid_data<=out1;
            o_vid_hsync <= hsync;
            o_vid_vsync <= vsync;
            o_vid_VDE <= vde;
            end
            2: o_vid_data<=out2;
            default: o_vid_data<=i_vid_data;
        endcase
    end
    
    skin_detection skin(.clk(clk), .n_rst(n_rst), .i_vid_data(i_vid_data), .i_vid_hsync(i_vid_hsync), .i_vid_vsync(i_vid_vsync), .i_vid_VDE(i_vid_VDE), .o_vid_data(out1), .o_vid_hsync(hsync), .o_vid_vsync(vsync), .o_vid_VDE(vde), .btn(btn));
//    inversion inverse(.clk(clk), .n_rst(n_rst), .i_vid_data(i_vid_data), .i_vid_hsync(i_vid_hsync), .i_vid_vsync(i_vid_vsync), .i_vid_VDE(i_vid_VDE), .o_vid_data(out2), .o_vid_hsync(o_vid_hsync), .o_vid_vsync(o_vid_vsync), .o_vid_VDE(o_vid_VDE), .btn(btn));
    
endmodule
