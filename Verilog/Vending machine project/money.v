`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2019 10:57:06 PM
// Design Name: 
// Module Name: money
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


module money(clk, reset, switch,state,  out    );

 input clk, reset,switch;
 input [2:0] state;
 output reg [3:0] out;
 wire signal;
 
 assign signal = (state == 3'b010)?clk:0;
 always @ (posedge signal or posedge reset) begin
    if (reset) begin
        out = 4'b0;
    end else if(out == 4'b1001) begin
        out = 4'b0;
    end else begin
        out = out + 1;
    end
  end   
endmodule