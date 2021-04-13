`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2019 07:53:52 PM
// Design Name: 
// Module Name: seven_segment_decoder
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


module seven_segment_decoder(in,result);
    input [3:0] in;
    output reg [6:0] result;
    always@(in) begin
        case(in)
            4'b0000: result = 7'b1000000;
            4'b0001: result = 7'b1111001;
            4'b0010: result = 7'b0100100;
            4'b0011: result = 7'b0110000;
            4'b0100: result = 7'b0011001;
            4'b0101: result = 7'b0010010;
            4'b0110: result = 7'b0000010;
            4'b0111: result = 7'b1111000;
            4'b1000: result = 7'b0000000;
            4'b1001: result = 7'b0010000;
            4'b1010: result = 7'b0001000;
            4'b1011: result = 7'b0000011;
            4'b1100: result = 7'b1000110;
            4'b1101: result = 7'b0100001;
            4'b1110: result = 7'b0000110;
            4'b1111: result = 7'b0001110;
            default: result = 7'b0000000;
        endcase
    end
endmodule
