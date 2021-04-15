`timescale 1ns / 1ns

module ALU_control(
	 input [5:0] instruction,
	 input [5:0] opcode,
	 input [1:0] ALUOp,
	 output reg [2:0] func
    );

 always @(*) begin
	if (ALUOp == 2'b00) begin  
		if (instruction == 6'h20 || opcode == 6'b00_1000 ) // add
		func = 3'd0;
		else if (instruction == 6'h22) // sub
		func = 3'd1;
		else if (instruction == 6'h24 || opcode == 6'b00_1100) // and
		func = 3'd2;
		else if (instruction == 6'h25 || opcode == 6'b00_1101) // or
		func = 3'd3;
		else if (instruction == 6'h11) // not
		func = 3'd4;
		else if (instruction == 6'h2A || opcode == 6'b00_1010) // slt
		func = 3'd6;
		else if (instruction == 6'h10) // mov
		func = 3'd5;
		else if ( opcode == 6'b00_1111)
		
		func = 3'd7;
		
	end else if (ALUOp == 2'b01) begin
		func = 3'd1;
	end else if (ALUOp == 2'b10) begin
	   
		func = 3'd0;
		
	
	end
   end


endmodule
