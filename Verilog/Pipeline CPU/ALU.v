`timescale 1ns / 1ns


module ALU(
    a,
    b,
	 func,
	 opcode,
    out,
    zero_flag
    );


	 parameter size = 32;
	 
    input [size-1:0] a;
    input [size-1:0] b;
	 input [2:0] func;
	 input [5:0] opcode;
    output reg [size-1:0] out;
    output reg zero_flag;
	
	
	
	
	
	always @(*) begin
	 if (out == 0 && opcode == 6'b00_0100) begin
	   zero_flag = 1'b1;
	 end else if (out != 0 && opcode == 6'b000101) begin
	   zero_flag = 1'b1;
	 end else begin
	   zero_flag = 1'b0;
	 end
	end
	
	always @(*) begin
		if (func == 3'd0) 
		out = a+b;
		
		else if (func == 3'd1)
		out = a-b;
		else if (func == 3'd2)
		out = a&b;
		else if (func == 3'd3)
		out = a|b;
		else if (func == 3'd4) // not
		out = ~a;
		else if (func == 3'd5) // mov
		out = a;
		else if (func == 3'd6) //slt
		out = (a < b) ? 1'b1 : 1'b0;
		else if (func == 3'd7) //lui
		out = b * 17'd65536;
		
		else
		out = 0;
   end
 
 


endmodule
