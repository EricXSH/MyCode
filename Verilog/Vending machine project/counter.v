`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2019 08:53:13 PM
// Design Name: 
// Module Name: counter
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


module counter(reset, clk, out);
  input reset, clk;
  output reg  out;
  
  always@ (posedge clk, posedge reset) begin 
    if (reset) begin
      out = 1'b00;
    end else  begin
      out = out + 1;
    end
  end
endmodule
