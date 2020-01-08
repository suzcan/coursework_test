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
    reg [7:0] skin_cb_max = 8'd127; //135
    reg [7:0] skin_cr_min = 8'd133; // 135
    reg [7:0] skin_cr_max = 8'd173;  // 180
    
    reg signed [8:0] y = 0, ytemp = 0;
    //reg signed [27:0] ytemp = 0;
    reg signed [8:0] cb = 0;
    reg signed [8:0] cr = 0;

    reg signed [8:0] rtemp = 0,gtemp = 0,btemp = 0, rtemp2 = 0, gtemp2 = 0, btemp2 = 0;
    
    reg [7:0] r  = 8'd0;
    reg [7:0] g = 8'd0;
    reg [7:0] b = 8'd0;
    
    wire [7:0] red, green, blue;
    assign {red, green, blue} = i_vid_data;
    reg [7:0] ans;
    reg [7:0] abs_answ;
    
    wire hsync = i_vid_hsync;
    wire vsync = i_vid_vsync;
    wire VDE = i_vid_VDE;
    
    reg sig_dly;
    
    // parameter NB_COL = 3;
    reg [2:0] write_enable = 3'b111;
    // parameter ADDR_WIDTH = 18;  
    reg [17:0] address = 18'd0;
    
    // parameter COL_WIDTH = 8; 
    // parameter NB_COL = 3;
    // input	[NB_COL*COL_WIDTH-1:0] di;
    // output reg [NB_COL*COL_WIDTH-1:0] do;
    wire [23:0] read_out; 
    reg read_enable = 1'd0;
    
    reg [2:0] dup_counter_w = 3'd0;
    reg [2:0] dup_counter_r = 3'd0;
    reg duplicating = 1'd0;
    reg [23:0] prev_read_out = 24'd0;
    reg [17:0] delay_counter = 1'd0;
    
    parameter BLOCK_SIZE = 63140; // 251535;
    parameter WIDTH = 205;
    parameter HEIGHT = 308;
    parameter IMAGE_SIZE = 251535;
    
    parameter DUPLICATE_MAX = 3;
    
    reg is_edge = 1'd1;
    
    wire [23:0] read_out_tl, read_out_tc, read_out_tr, read_out_l, read_out_r, read_out_bl, read_out_bc, read_out_br;
    
    reg [23:0] grey;
    reg [7:0] calc;
    reg [7:0] edge_counter = 8'd0;
    
    parameter HCOUNTMAX = 409;
    reg [8:0] hcount = 9'd0;
    parameter VCOUNTMAX = 615;
    reg [9:0] vcount = 10'd0;
      
    // call to working block memory module version       
    bram MEM (.clk(clk), .we(write_enable), .addr(address), .di(i_vid_data), .do(read_out), .re(read_enable));
    
    // call to memory block returning surrouding pixels
    /*
    bram MEM2 (.clk(clk), .we(write_enable), .addr(address), .di(grey), .do(read_out), .re(read_enable),
        .is_edge(is_edge), .do_tl(read_out_tl), .do_tc(read_out_tc), .do_tr(read_out_tr), .do_l(read_out_l),
        .do_r(read_out_r), .do_bl(read_out_bl), .do_bc(read_out_bc), .do_br(read_out_bc));
     /**/
     
    reg signed [13:0] const1 = 14'b000000000_01000; // 0.2568 - 0.01
    reg signed [13:0] const2 = 14'b000000000_10100; // 0.645 - 0.101
    reg signed [13:0] const3 = 14'b000000000_11111; // 0.979 - 0.11111
    reg signed [13:0] const4 = 14'b000000000_10000; // 0.5772 -0.1
    reg signed [13:0] const5 = 14'b000000000_11000; // 0.713 - 0.11
    reg signed [13:0] const6 = 14'b000010000_00000; // 16 - [6:0] 010000
    reg signed [13:0] const7 = 14'b010000000_00000;// 128 - [8:0] 010000000
        // red green bluc [7:0] 000000000
    reg signed [13:0] sign_red = 14'b000000000_00000;
    reg signed [13:0] sign_green = 14'b000000000_00000;
    reg signed [13:0] sign_blue = 14'b000000000_00000;
    
    reg signed [27:0] answ;
    reg signed [27:0] answ2;
    
    always @(posedge clk) begin
      
    // skin detection
        /*
        sign_red [12:5] = red;
        sign_green [12:5] = green;
        sign_blue [12:5] = blue;
        
        ytemp <= const6 + (const1 * sign_red) + (sign_green * const2) + (sign_blue * const3);
        answ <= const4*(sign_blue-ytemp)+const7;
        answ2 <= const5*(sign_red-ytemp)+const7;
        cb <= answ[18:10];
        cr <= answ2[18:10];
        y <= ytemp[18:10];
        /*
        ytemp <= 16+ 0.2568*red+green*0.645+blue*0.0979;
        cb <= 0.5772*(btemp-ytemp)+128;
        cr <= 0.713*(rtemp-ytemp)+128;
        y <= ytemp;
        */
        
        /*
        ytemp <= 16+ (2568*red)/10000+(green*645)/1000+(blue*979)/10000;
        cb <= 5772*(btemp-ytemp)/10000+128;
        cr <= 713*(rtemp-ytemp)/1000+128;
        y <= ytemp;
        
        rtemp <= red;
        gtemp <= green;
        btemp <= blue;
        
        rtemp2 <= rtemp;
        gtemp2 <= gtemp;
        btemp2 <= btemp;
        
         if(y > skin_y && skin_cb_min < cb && skin_cb_max > cb && skin_cr_min < cr && skin_cr_max > cr) begin
            o_vid_data[23:16] <= rtemp2;
            o_vid_data[15:8] <= gtemp2;
            o_vid_data[7:0] <= btemp2;
        end else begin
            o_vid_data[23:16] <= r;
            o_vid_data[15:8] <= g;
            o_vid_data[7:0] <= b;
        end
        
        o_vid_hsync <= hsync;
        o_vid_vsync <= vsync;
        o_vid_VDE <= VDE;
       /**/
       
    ///*
    // HORIZONTAL GRAYSCALE
    if (i_vid_VDE) begin
            vcount <= vcount + 1'd1;
            if(vcount >= VCOUNTMAX) begin
                vcount <= 9'd0;
                hcount <= hcount + 1'd1;
                if(hcount >= HCOUNTMAX) begin
                    hcount <= 10'd0;
                end
            end
            if (hcount > 136 && hcount < 272) begin
                r <= i_vid_data[23:16];
                g <= i_vid_data[15:8];
                b <= i_vid_data[7:0];
            end else begin
                r <= ( (0.3 *  i_vid_data[23:16]) + (0.59 * i_vid_data[15:8]) + (0.11 * i_vid_data[7:0]) );;
                g <= ( (0.3 *  i_vid_data[23:16]) + (0.59 * i_vid_data[15:8]) + (0.11 * i_vid_data[7:0]) );;
                b <= ( (0.3 *  i_vid_data[23:16]) + (0.59 * i_vid_data[15:8]) + (0.11 * i_vid_data[7:0]) );;
            end  
        end
        /**/
    /*
    // DIAGONAL GREY SCALE
        if (i_vid_VDE) begin
            hcount <= hcount + 1'd1;
            if(hcount >= HCOUNTMAX) begin
                hcount <= 10'd0;
                vcount <= vcount + 1'd1;
                if(vcount >= VCOUNTMAX) begin
                    vcount <= 9'd0;
                end
            end
            if (hcount > 136 && hcount < 272) begin
                r <= i_vid_data[23:16];
                g <= i_vid_data[15:8];
                b <= i_vid_data[7:0];
            end else begin
                r <= ( (0.3 *  i_vid_data[23:16]) + (0.59 * i_vid_data[15:8]) + (0.11 * i_vid_data[7:0]) );;
                g <= ( (0.3 *  i_vid_data[23:16]) + (0.59 * i_vid_data[15:8]) + (0.11 * i_vid_data[7:0]) );;
                b <= ( (0.3 *  i_vid_data[23:16]) + (0.59 * i_vid_data[15:8]) + (0.11 * i_vid_data[7:0]) );;
            end  
        end
        /**/
        
       
        
        
        // BLOCK RAM WITH DUPLICATION AND SPATIAL FILTERING   
        // UNCOMMENT INSTANTIATE AT THE TOP
        // reading logic
        if(read_enable == 1'd1) begin
            // reading out values
            if(dup_counter_r >= DUPLICATE_MAX) begin
                r <= prev_read_out[23:16];
                g <= prev_read_out[15:8];
                b <= prev_read_out[7:0];
                prev_read_out <= prev_read_out;
                dup_counter_r <= 3'd0;
            end else begin
                
                if(~is_edge) begin
                    calc <= ((read_out_tl[23:16] * -1) + (read_out_tc[23:16] * -1) + (read_out_tr[23:16] * -1) +
                        (read_out_l[23:16] * -1) + (read_out_r[23:16] * -1) +
                        (read_out_bl[23:16] * -1) + (read_out_bc[23:16] * -1) + (read_out_bc[23:16] * -1) +
                        (read_out[23:16] * 16))/8;
                end else begin
                    calc <= read_out[23:16];
                end
                r <= calc;
                g <= calc;
                b <= calc;
                prev_read_out[23:16] <= calc;
                prev_read_out[15:8] <= calc;
                prev_read_out[7:0] <= calc;
                dup_counter_r <= dup_counter_r + 3'd1;
            end
            
            // identifying edges
            
            if(address <= WIDTH || address >= (WIDTH*HEIGHT) - WIDTH || edge_counter == 1'd1 || edge_counter >= WIDTH) begin
                is_edge <= 1'd1;
                edge_counter <= 1'd0;
            end else begin
                is_edge <= 1'd0;
                if (i_vid_VDE)
                    edge_counter <= edge_counter + 1'd1;
            end
            
        end
        
        // address handling
        if (address == BLOCK_SIZE) begin
                address <= 18'd0;
                read_enable = ~read_enable;
                write_enable = ~write_enable;
                dup_counter_w <= 3'd0;
                duplicating <= 1'd0;
        end else begin
            if(i_vid_VDE && ~duplicating) begin
                grey[23:16] <= ( (0.3 *  i_vid_data[23:16]) + (0.59 * i_vid_data[15:8]) + (0.11 * i_vid_data[7:0]) );
                grey[15:8] <= ( (0.3 *  i_vid_data[23:16]) + (0.59 * i_vid_data[15:8]) + (0.11 * i_vid_data[7:0]) );
                grey[7:0] <= ( (0.3 *  i_vid_data[23:16]) + (0.59 * i_vid_data[15:8]) + (0.11 * i_vid_data[7:0]) );
                address <= address + 18'd1; 
            end
        end 
        
        // duplication logic
        if (i_vid_VDE) begin
            duplicating <= 1'd1;
            dup_counter_w <= dup_counter_w + 1'd1;
            if (dup_counter_w >= DUPLICATE_MAX) begin
                dup_counter_w <= 3'd0;
                duplicating <= 1'd0;
            end
        end
        /**/
    
    
        /*
        // BLOCK RAM WITH DUPLICATION
        // UNCOMMENT INSTANTIATE AT THE TOP
        // reading logic
        if(read_enable == 1'd1) begin
            if(dup_counter_r >= DUPLICATE_MAX) begin
                r <= prev_read_out[23:16];
                g <= prev_read_out[15:8];
                b <= prev_read_out[7:0];
                prev_read_out <= prev_read_out;
                dup_counter_r <= 3'd0;
            end else begin
                r <= read_out[23:16];
                g <= read_out[15:8];
                b <= read_out[7:0];
                prev_read_out <= read_out;
                dup_counter_r <= dup_counter_r + 3'd1;
            end
        end
        
        // address handling
        if (address == BLOCK_SIZE) begin
                address <= 18'd0;
                read_enable = ~read_enable;
                write_enable = ~write_enable;
                dup_counter_w <= 3'd0;
                duplicating <= 1'd0;
        end else begin
            if(i_vid_VDE && ~duplicating)
                address <= address + 18'd1; 
        end 
        
        // duplication logic
        if (i_vid_VDE) begin
            duplicating <= 1'd1;
            dup_counter_w <= dup_counter_w + 1'd1;
            if (dup_counter_w >= DUPLICATE_MAX) begin
                dup_counter_w <= 3'd0;
                duplicating <= 1'd0;
            end
        end
        /**/
        
        /* 
        //VANILLA BLOCK RAM
        if(read_enable == 1'd1) begin
                r <= read_out[23:16];
                g <= read_out[15:8];
              b <= read_out[7:0];
        end
        
        // address handling
        if (address == BLOCK_SIZE) begin
            address <= 18'd0;
            read_enable = ~read_enable;
            write_enable = ~write_enable;
        end else begin
            if(i_vid_VDE)
                address <= address + 18'd1; 
        end 
        /**/
        
       /* // inverter
        if (btn == 4'd1) begin
            r <= 255 - i_vid_data[23:16];
            g <= 255 - i_vid_data[15:8];
            b <= 255 - i_vid_data[7:0];
       end
       /**/
       
       /*
       // grayscale
       //if (btn == 4'd1) begin
            r <= ( (30 *  i_vid_data[23:16])/10 + (0.59 * i_vid_data[15:8]) + (0.11 * i_vid_data[7:0]) ); ;
            g <= ( (0.3 *  i_vid_data[23:16]) + (0.59 * i_vid_data[15:8]) + (0.11 * i_vid_data[7:0]) ); ;
            b <= ( (0.3 *  i_vid_data[23:16]) + (0.59 * i_vid_data[15:8]) + (0.11 * i_vid_data[7:0]) ); ;
        //end
        /**/
        
        o_vid_data[23:16] <= r;
        o_vid_data[15:8] <= g;
        o_vid_data[7:0] <= b;
        /**/
        
        o_vid_hsync <= hsync;
        o_vid_vsync <= vsync;
        o_vid_VDE <= VDE;
        
    end
    
endmodule
