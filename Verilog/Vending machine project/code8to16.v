`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2019 10:39:11 PM
// Design Name: 
// Module Name: code8to16
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



module code_tansform(in, out);
 input [7:0] in;
 output [15:0] out;
 
 assign out = {8'b10001000, in};
 
endmodule
