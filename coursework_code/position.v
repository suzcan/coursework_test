`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.01.2020 04:57:00
// Design Name: 
// Module Name: position
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


module position(
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
    reg [16:0] vcount = 0, hcount = 0;
    assign {red, blue, green} = i_vid_data;
    always @(negedge clk) begin
            if(i_vid_VDE) begin
        if(hcount>=16'd1919) begin
            hcount <= 0;
            if(vcount>=16'd1079)
                vcount <=0;
         else vcount <= vcount +1;
    end else hcount <= hcount +1;
    end
    end
    
    wire [7:0] grey = (3*red)/100 + (59*green)/100 + (11*blue)/100;
    
     always @(posedge clk) begin
     
    
   
           if(sw == 4'd3) begin
             if (hcount > 200 && hcount < 800) begin
//                 o_vid_data[23:16] <= 16'd255;
//                 o_vid_data[15:8] <= 0;
//                 o_vid_data[7:0] <= 0;  
                o_vid_data[23:16] <= grey;
                 o_vid_data[15:8] <= grey; 
                 o_vid_data[7:0] <= grey;         
//               o_vid_data[23:16] <= 0;
//               o_vid_data[15:8] <= 0;
//               o_vid_data[7:0] <= green;
           end
           else
             o_vid_data <= i_vid_data;
           end
           
           o_vid_hsync <= i_vid_hsync;
           o_vid_vsync <=  i_vid_vsync;
           o_vid_VDE <=  i_vid_VDE;
//           o_vid_hsync <= o_vid_hsync1;
//           o_vid_vsync <=  o_vid_vsync1;
//           o_vid_VDE <=  o_vid_VDE1;
           end
           
endmodule
