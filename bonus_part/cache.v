`timescale 1ns / 1ps
`include "define.v"

module cache(
	 input clk,
	 input rst,
    input [1:0] index,
	 input [3:0] offset,
    output [`DSIZE-1:0] rdata
    );

	// cache registers
	reg [`DSIZE-1:0] cachedata [0:3][0:15];
	
	always @ (posedge clk) begin
	end

endmodule
