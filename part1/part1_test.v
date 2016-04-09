`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:50:27 10/09/2015
// Design Name:   part1
// Module Name:   D:/Dropbox/Current Semester/CZ3001/Project/code/part1_test.v
// Project Name:  code
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: part1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module part1_test;

	// Inputs
	reg clk;
	reg rst;
	reg fileid;

	// Outputs
	wire [15:0] PCOUT;
	wire [15:0] INST;
	wire [15:0] rdata1;
	wire [15:0] rdata2;
	wire [15:0] rdata1_out_ID_EXE;
	wire [15:0] rdata2_out_ID_EXE;
	wire [15:0] imm_out_ID_EXE;
	wire [15:0] rdata2_imm_out_ID_EXE;
	wire [2:0] aluop_out_ID_EXE;
	wire alusrc;
	wire [3:0] waddr_out_ID_EXE;
	wire [15:0] aluout;
	wire [3:0] raddr1, raddr2;

	// Instantiate the Unit Under Test (UUT)
	part1 uut (
		.clk(clk), 
		.rst(rst), 
		.fileid(fileid), 
		.PCOUT(PCOUT), 
		.INST(INST), 
		.rdata1(rdata1), 
		.rdata2(rdata2), 
		.rdata1_out_ID_EXE(rdata1_out_ID_EXE), 
		.rdata2_out_ID_EXE(rdata2_out_ID_EXE), 
		.imm_out_ID_EXE(imm_out_ID_EXE), 
		.rdata2_imm_out_ID_EXE(rdata2_imm_out_ID_EXE), 
		.aluop_out_ID_EXE(aluop_out_ID_EXE), 
		.alusrc(alusrc), 
		.waddr_out_ID_EXE(waddr_out_ID_EXE), 
		.aluout(aluout),
		.raddr1(raddr1),
		.raddr2(raddr2)
	);

initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		fileid = 0;

		// Wait 100 ns for global reset to finish
		#100 ;
      #25 rst =1;
		#25 rst=0;
		#1000 $finish;
		// Add stimulus here

	end
     
always #15 clk = ~clk;	
endmodule

