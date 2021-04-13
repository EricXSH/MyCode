`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2019 07:38:12 PM
// Design Name: 
// Module Name: check_money
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


module check_money(
    
    input [12:0] price,
    input [12:0] money,
    output reg sufficient
    );
    
    always@(*) begin
        if (price <= money) begin
            sufficient <= 1'b0;
        end else begin
            sufficient <= 1'b1;
        end
    end
endmodule
