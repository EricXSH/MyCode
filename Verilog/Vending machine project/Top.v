`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2019 08:05:16 PM
// Design Name: 
// Module Name: Top
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


module Top(
    input clk,
    input [3:0] in,
    input [3:0] switch,
    input reset,
    
    output reg [4:0] debug,
    output reg indicator, LED1, LED2,
    output  [3:0] digit_s,
    output  [6:0] seven
    );
    
    //Input Preprocessing
    wire clk1k,in0,in1,in2,in3;
    
    clock_divider100Mto1k clockDivider(.clk(clk), .reset(reset), .signal(clk1k));
    debouncer Deb0(.clk(clk), .reset(reset), .in(in[0]), .signal(in0));
    debouncer Deb1(.clk(clk), .reset(reset), .in(in[1]), .signal(in1));
    debouncer Deb2(.clk(clk), .reset(reset), .in(in[2]), .signal(in2));
    debouncer Deb3(.clk(clk), .reset(reset), .in(in[3]), .signal(in3));
    
    
    //Wire
    
    wire [12:0] price, money_int;
    wire [15:0] code, refund_h, money;
    wire code_checker;
    wire money_checker;
    wire[12:0] refund;
    
    wire [3:0] S;
    
    reg [2:0] curr_state;
    reg [2:0] next_state;
    reg switch_int,money_switch;
    wire [2:0] curr;
    parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100;
    /*
    initial begin
        curr_state = s0;
    end
    */
    
    always@(posedge clk, posedge reset)begin
    if(reset) begin
        curr_state <= s0;
    end else begin
        curr_state <= next_state;
        end
    end
    
    always@(*)begin
        case(curr_state)
            s0:begin
                debug = 5'b10000;
                switch_int = 0;
                indicator = 1'b0;
                LED1 = 1'b0;
                LED2 = 1'b0;
                next_state = (switch == 4'b0001)? s1: s0;
            end
            s1:begin
                debug = 5'b01000;
                indicator = 1'b1;
                LED1 = (code_checker == 1'b1)? 1'b1: 1'b0;
                LED2 = 1'b0;
                money_switch = (code_checker == 1'b1)?1'b1:1'b0;
                next_state = (/*switch == 4'b0011 &&*/ code_checker == 1'b1)? s2: /*s1*/s0;
            end
            s2:begin
                debug = 5'b00100;
                money_switch = 0;
                indicator = 1'b0;
                LED1 = 1'b1;
                LED2 = 1'b0;
                next_state = (/*switch == 4'b0111*/switch == 4'b0011)? s3:(switch == 4'b0000)?s0: s2;
            end
            s3:begin
                debug = 5'b00010;
                indicator = 1'b1;
                LED1 = 1'b1;
                LED2 = (money_checker == 1'b1)? 1'b0: 1'b1;
                switch_int = (money_checker == 1'b1)?1'b0: 1'b1;
                next_state = (/*switch == 4'b1111 &&*/ money_checker == 1'b0)? s4: /*s3*/s2;
            end
            s4:begin
                debug = 5'b00001;
                indicator = 1'b0;
                LED1 = 1'b1;
                LED2 = 1'b1;
                next_state = (switch == 4'b0000)? s0: s4;
            end
        endcase
    end
    
    /*
    always@(*)begin
        case(curr_state)
            s0:begin
                debug = 5'b10000;
                switch_int = 0;
                indicator = 1'b0;
                next_state = (switch == 2'b01)? s1: s0;
            end
            s1:begin
                debug = 5'b01000;
                indicator = 1'b1;
                LED = (code_checker == 1'b1)? 1'b1: 1'b0;
                money_switch = (code_checker == 1)?1:0;
                next_state = (code_checker == 1'b1)? s2: s0;
            end
            s2:begin
                debug = 5'b00100;
                money_switch = 0;
                indicator = 1'b0;
                next_state = (switch == 2'b11)? s3: s2;
            end
            s3:begin
                debug = 5'b00010;
                indicator = 1'b1;
                LED = (money_checker == 1'b1)? 1'b1: 1'b0;
                switch_int = (money_checker == 1)?0: 1;
                next_state = (money_checker == 1'b1)? s4: s0;
            end
            s4:begin
                debug = 5'b00001;
                indicator = 1'b0;
                next_state = (switch == 2'b00)? s0: s4;
            end
        endcase
    end
    */
    
    assign curr = curr_state;
    assign switchCode = switch_int;
    assign switch_money = money_switch;
    
    
    
    //assign curr = s0;
    
    code_to_price S0(.clk_1(in0), .clk_2(in1), .reset(reset), .switch(switchCode),.state(curr), .code_out(code));
    
    check_code S1(.code(code), .code_v(code_checker), .price(price));
    
    money_in S2(.clk_0(in0), .clk_1(in1), .clk_2(in2), .clk_3(in3), .reset(reset), .switch(switch_money),.state(curr), .money_out(money));
    
    h2d gate_4(.in(money), .out(money_int));
    
    check_money S3(.price(price), .money(money_int), .sufficient(money_checker));
    
    check_refund S4(.price(price), .money(money_int), .refund(refund));
    
    d2h sn(.in(refund), .out(refund_h));
    
    wire [15:0] display;
    BeforeDisplay O0(.code(code), .money(money), .refund(refund_h), .state(curr), .out(display));
    
    display_control O1(.clk(clk1k), .reset(reset), .counter_in(display), .digit_select(digit_s), .binary_to_segment(S));
    seven_segment_decoder O2(.in(S), .result(seven));
    
    
    
    
endmodule
