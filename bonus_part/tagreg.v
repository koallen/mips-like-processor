`timescale 1ns / 1ps

module tagreg(
	 input clk,
	 input rst,
    input [1:0] index,
    output [9:0] tagbits
    );

	// 4 10bit tag registers
	reg [9:0] tagreg [0:3];
	
	always @ (posedge clk) begin
		if(rst) begin
			tagreg[0] <= 0;
			tagreg[1] <= 0;
			tagreg[2] <= 0;
			tagreg[3] <= 0;
		end
	end
	
	assign tagbits = tagreg[index];

endmodule
