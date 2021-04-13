`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2019 09:31:56 PM
// Design Name: 
// Module Name: money_in
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


module money_in(clk_0, clk_1, clk_2, clk_3, reset, switch, state, money_out);

    input clk_0,clk_1,clk_2,clk_3,reset,switch;
    input [2:0] state;
    output [15:0]money_out;
    
    wire [15:0] money;
    
    money gate_0 (.clk(clk_0), .reset(reset), .switch(switch),.state(state), .out(money_out[3:0]));
    money gate_1 (.clk(clk_1), .reset(reset), .switch(switch),.state(state), .out(money_out[7:4]));
    money gate_2 (.clk(clk_2), .reset(reset), .switch(switch),.state(state), .out(money_out[11:8]));
    money gate_3 (.clk(clk_3), .reset(reset), .switch(switch), .state(state),.out(money_out[15:12]));
    
    
endmodule
