`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.12.2019 12:11:50
// Design Name: 
// Module Name: inversion
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


module inversion(
    input clk,
    input n_rst,
    input [23:0] i_vid_data,
    input i_vid_hsync,
    input i_vid_vsync,
    input i_vid_VDE,
    input [3:0] sw,
    
    output reg [23:0] o_vid_data,
    output reg o_vid_hsync,
    output reg o_vid_vsync,
    output reg o_vid_VDE,
    output reg o_vid_hsync1,
    output reg o_vid_vsync1,
    output reg o_vid_VDE1
);
    wire [7:0] red, green, blue;
    assign {red, green, blue} = i_vid_data;

 always @(posedge clk) begin

        if(sw == 4'd2) begin
            o_vid_data[23:16] <= 255-red;
            o_vid_data[15:8] <= 255-green;
            o_vid_data[7:0] <= 255-blue;
        end
        o_vid_hsync <= i_vid_hsync;
        o_vid_vsync <=  i_vid_vsync;
        o_vid_VDE <=  i_vid_VDE;
        end
endmodule
