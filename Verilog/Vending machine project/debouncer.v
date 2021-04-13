`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2019 07:17:51 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer(clk,reset,in,signal);
    input clk;
    input reset;
    input in;
    output reg signal;
    reg deb_count_start;
    reg [31:0] deb_count;
    parameter max = 12000;
    reg output_exist;
    
    always@(posedge clk)begin
        if(reset) begin
            deb_count = 0;
        end
        else if(in) begin
            //deb_count_start = 1'b1;
            deb_count = deb_count + 1;
        end
        else begin
            deb_count_start = 1'b0;
            deb_count = 0;
        end
    end
    
    always@(posedge clk) begin
        if(reset) begin
            signal = 1'b0;
        end
        else if(deb_count == max) begin
            signal = 1'b1;
        end
        else begin
            signal = 1'b0;
        end
    end
endmodule



