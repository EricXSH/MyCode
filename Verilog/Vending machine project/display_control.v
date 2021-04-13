`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2019 08:07:16 PM
// Design Name: 
// Module Name: display_control
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

module display_control(clk,reset,counter_in,digit_select,binary_to_segment);
    input clk;
    input reset;
    input [15:0] counter_in;
    output reg [3:0] digit_select;
    output reg [3:0] binary_to_segment;
    reg [1:0] s;
    parameter[1:0] s0=2'b00,s1=2'b01,s2=2'b10,s3=2'b11;
    
    always@(posedge clk or posedge reset) begin
        if(reset) begin 
            s = s0;
        end
        else begin 
            s = s+1;
        end
    end
    
    always@(*) begin
        case(s)
            s0:begin
                digit_select = 4'b1110;
                binary_to_segment = counter_in[3:0];
            end
            s1:begin
                digit_select = 4'b1101;
                binary_to_segment = counter_in[7:4];
            end
            s2:begin
                digit_select = 4'b1011;
                binary_to_segment = counter_in[11:8];
            end
            s3:begin
                digit_select = 4'b0111;
                binary_to_segment = counter_in[15:12];
            end
        endcase
    end
    
endmodule
