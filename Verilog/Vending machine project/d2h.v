`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2019 09:11:55 PM
// Design Name: 
// Module Name: d2h
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


module d2h(
    input [12:0] in,
    output [15:0] out
    );
    assign out[15:12] = in/10'b1111101000;
    assign out[11:8] = (in%10'b1111101000)/7'b1100100;
    assign out[7:4] = (in% 7'b1100100)/ 4'b1010;
    assign out[3:0] = in% 4'b1010;
    
    
endmodule

