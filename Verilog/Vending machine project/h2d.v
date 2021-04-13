`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2019 09:10:24 PM
// Design Name: 
// Module Name: h2d
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


module h2d(
    input [15:0] in,
    output [12:0] out
    );
    
    assign out = in[3:0] + (in[7:4] * 4'b1010) + (in[11:8] * 7'b1100100) + (in[15:12] * 10'b1111101000);
    
endmodule
