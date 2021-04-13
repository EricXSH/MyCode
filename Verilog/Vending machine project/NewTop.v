`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2019 09:01:49 PM
// Design Name: 
// Module Name: NewTop
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


module NewTop(
    input clk,
    input [3:0] in,
    input [1:0] switch,
    input reset,
    
    output reg indicator, LED,
    output  [3:0] digit_s,
    output  [6:0] seven
    );
    
    reg [2:0] curr_state;
    parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100;
    
    initial begin
        curr_state = s0;
    end
    
    //Input Preprocessing
    wire clk1k,in0,in1,in2,in3;
    
    clock_divider100Mto1k clockDivider(.clk(clk), .reset(reset), .signal(clk1k));
    debouncer Deb0(.clk(clk), .reset(reset), .in(in[0]), .signal(in0));
    debouncer Deb1(.clk(clk), .reset(reset), .in(in[1]), .signal(in1));
    debouncer Deb2(.clk(clk), .reset(reset), .in(in[2]), .signal(in2));
    debouncer Deb3(.clk(clk), .reset(reset), .in(in[3]), .signal(in3));
    
    wire [12:0] price, money;
    wire [7:0] code;
    wire code_checker;
    wire money_checker;
    wire[12:0] refund;
    wire [15:0] ending;
    
    always@(*) begin
        case(curr_state)
            s0:begin
                
                assign curr_state = (switch == 2'b01)? s1: s0;
            end
            s1:begin
            
                assign curr_state = (code_checker == 1'b1)? s2: s0;
            end
            s2:begin
                
                assign curr_state = (switch == 2'b11)? s3: s2;
            end
            s3:begin
            
                assign curr_state = (money_checker == 1'b1)? s4: s0;
            end
            s4:begin
            
                assign curr_state = (switch == 2'b00)? s0: s4;
            end
        endcase
    end
    
endmodule
