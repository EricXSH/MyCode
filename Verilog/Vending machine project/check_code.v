`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2019 09:13:37 PM
// Design Name: 
// Module Name: check_code
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


module check_code(
    input [15:0] code,
    output reg code_v,
    output reg [12:0] price
    );
    always@(*) begin
    case(code)
    16'b0000000010100001: begin code_v = 1;
    price = 13'b 0000001100100;
    end
    16'b0000000010100010: begin code_v = 1;
    price = 13'b 0000001100100;
    end
    16'b0000000010100011: begin code_v = 1;
    price = 13'b 0000001001011;
    end
    16'b0000000010110001: begin code_v = 1;
    price = 13'b 0000001111101;
    end
    16'b0000000010110010: begin code_v = 1;
    price = 13'b 0000001100100;
    end
    16'b0000000010110011: begin code_v = 1;
    price = 13'b 0000001111101;
    end
    16'b0000000011000001: begin code_v = 1;
    price = 13'b 0000001001011;
    end
    16'b0000000011000010: begin code_v = 1;
    price = 13'b 0000001001011;
    end
    default: begin code_v = 0;
    price = 0;
    end
    endcase
    end
endmodule

