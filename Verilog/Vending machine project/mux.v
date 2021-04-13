`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2019 08:57:06 PM
// Design Name: 
// Module Name: mux
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


module mux(in1, in0, s, out);
 input [3:0] in1, in0;
 input s;
 output reg [3:0] out;
 
 always @(*) begin
   case (s) 
    1'b1: out <= in0;
    1'b0: out <= in1;
   endcase
  end
endmodule
