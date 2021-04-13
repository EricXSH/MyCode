`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2019 09:23:38 PM
// Design Name: 
// Module Name: clock_divider100Mto1k
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


module clock_divider100Mto1k(clk,reset,signal);
    input clk;
    input reset;
    output reg signal;
    parameter num = 250000;
    reg [31:0]counter;
    
    initial begin
        signal = clk;
    end
    
    always@(posedge clk) begin
        if(reset) begin
            signal = 0;
            counter = 1;
        end
        else if(counter == num) begin
            counter = 1;
            signal = ~signal;
        end
        else begin
            counter = counter + 1;  
        end
    end
endmodule
