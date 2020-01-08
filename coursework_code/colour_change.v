`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Alex Bucknall
// 
// Create Date: 19.02.2019 15:33:35
// Design Name: pcam-5c-zybo
// Module Name: colour_change
// Project Name: pcam-5c-zybo
// Target Devices: Zybo Z7 20
// Tool Versions: Vivado 2017.4
// Description: RBG Colour Changing Module (vid_io)
// 
// Dependencies: N/A
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: N/A
// 
//////////////////////////////////////////////////////////////////////////////////


module colour_change #
(
    parameter DATA_WIDTH = 24 // 8 bits for R, G & B
)
(
    input  wire                   clk,
    input  wire                   n_rst,

    /*
     * Pixel inputs
     */
    input  wire [DATA_WIDTH-1:0] i_vid_data,
    input  wire                  i_vid_hsync,
    input  wire                  i_vid_vsync,
    input  wire                  i_vid_VDE,

    /*
     * Pixel output
     */
    output reg [DATA_WIDTH-1:0] o_vid_data,
    output reg                  o_vid_hsync,
    output reg                  o_vid_vsync,
    output reg                  o_vid_VDE,
    
    /*
     * Control
     */
    input wire [3:0] btn,
    input wire [3:0] sw,
    output reg [3:0] led 
);


 wire [23:0] out1, out2,out3;
   wire hsync, vsync, vde, hsync2, vsync2, vde2, hsync3, vsync3, vde3;
   always@* begin
       case(sw)
           4'd1:begin o_vid_data<=out1;
           o_vid_hsync <= hsync;
           o_vid_vsync <= vsync;
           o_vid_VDE <= vde;
           end
           4'd2: begin 
            o_vid_data<=out2;
            o_vid_hsync <= hsync2;
            o_vid_vsync <= vsync2;
            o_vid_VDE <= vde2;
           end
           4'd3: begin 
           o_vid_data<=out3;
           o_vid_hsync <= hsync3;
           o_vid_vsync <= vsync3;
           o_vid_VDE <= vde3;
          end
          default: begin
           o_vid_data<=i_vid_data;
           o_vid_hsync <= i_vid_hsync;
           o_vid_vsync <= i_vid_vsync;
           o_vid_VDE <= i_vid_VDE;
           end
       endcase
   end
   
   skin_detection skin(.clk(clk), .n_rst(n_rst), .i_vid_data(i_vid_data), .i_vid_hsync(i_vid_hsync), .i_vid_vsync(i_vid_vsync), .i_vid_VDE(i_vid_VDE), .o_vid_data(out1), .o_vid_hsync(hsync), .o_vid_vsync(vsync), .o_vid_VDE(vde), .sw(sw));
   inversion inverse(.clk(clk), .n_rst(n_rst), .i_vid_data(i_vid_data), .i_vid_hsync(i_vid_hsync), .i_vid_vsync(i_vid_vsync), .i_vid_VDE(i_vid_VDE), .o_vid_data(out2), .o_vid_hsync(hsync2), .o_vid_vsync(vsync2), .o_vid_VDE(vde2), .sw(sw));
   position pos(.clk(clk), .n_rst(n_rst), .i_vid_data(i_vid_data), .i_vid_hsync(i_vid_hsync), .i_vid_vsync(i_vid_vsync), .i_vid_VDE(i_vid_VDE), .o_vid_data(out3), .o_vid_hsync(hsync3), .o_vid_vsync(vsync3), .o_vid_VDE(vde3), .sw(sw));
    

endmodule