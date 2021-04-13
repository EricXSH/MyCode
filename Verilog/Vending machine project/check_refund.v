`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2019 09:14:23 PM
// Design Name: 
// Module Name: check_refund
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


module check_refund(

    input [12:0] price,
    input [12:0] money,
    output reg [12:0] refund
    );
    
    always@(*) begin
        refund <= money - price;
    end
    
    
endmodule
