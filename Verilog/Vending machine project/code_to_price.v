`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2019 08:13:21 PM
// Design Name: 
// Module Name: code_to_price
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


module code_to_price(clk_1, clk_2, reset, switch,state, code_out);
 input clk_1, clk_2,reset, switch;
 input [2:0] state;
 //output [12:0] price_out; // need  module that transferring 4 4-bit to 1 16-bit
 output [15:0] code_out;
 //wire [15:0] out; // price in four 4-bit
 wire [15:0] w; // store code
 
 assign w[15:8] = 8'b0;
 code gate_0 (.clk(clk_1), .reset(reset),.switch(switch),.state(state), .out(w[7:4]));
 code gate_1 (.clk(clk_2), .reset(reset), .switch(switch),.state(state), .out(w[3:0]));
 
 //get_price gate_2 (.in(w), .out_2(out[11:8]), .out_1(out[7:4]), .out_0(out[3:0]));
 
 //h2d gate_4(.in(out), .out(price_out));
 
 assign code_out = w;
 
endmodule
