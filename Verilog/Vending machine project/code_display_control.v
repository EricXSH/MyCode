`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2019 08:48:10 PM
// Design Name: 
// Module Name: code_display_control
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


module code_display_control(code_in, digit_select, out, clk, reset);
  input [7:0] code_in;
  input clk, reset;
  output [3:0] digit_select, out;
  wire w;
  
  counter ins_0 (.clk(clk), .reset(reset), .out(w));
  mux ins_1 (.s(w), .in1(4'b0010), .in0(4'b0011), .out(digit_select));
  mux ins_2 (.s(w), .in1(code_in[7:4]), .in0(code_in[3:0]));
  
endmodule
