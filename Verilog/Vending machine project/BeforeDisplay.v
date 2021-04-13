`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2019 11:55:12 PM
// Design Name: 
// Module Name: BeforeDisplay
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


module BeforeDisplay(
    input [15:0] code,money,refund,
    
    input [2:0] state,
    output reg [15:0] out
    );
    
    always@(*) begin
        case(state)
            3'b000: out = code;
            3'b010: out = money;
            3'b100: out = refund;
            //default: out = 16'b0;
        endcase
    end
endmodule
