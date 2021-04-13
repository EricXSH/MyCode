`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2019 07:43:50 PM
// Design Name: 
// Module Name: project
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


module code(clk, reset, switch,state,  out    );

 input clk, reset, switch;
 input [2:0] state;
 output reg [3:0] out;
 wire w;
wire signal;
assign signal = (state == 3'b000)?clk: 0;
 
 always @ (posedge signal or posedge reset) begin
    if (reset) begin

        out = 0;
    end else begin
        out = out + 1;
    end
  end   
endmodule
