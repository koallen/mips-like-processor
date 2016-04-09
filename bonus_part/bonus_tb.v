`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:40:05 10/24/2015
// Design Name:   bonus
// Module Name:   D:/Dropbox/Current Semester/CZ3001/Project/bonus_part_code/bonus_tb.v
// Project Name:  bonus_part_code
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bonus
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module bonus_tb;

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
	wire [3:0] raddr1;
	wire [3:0] raddr2;
	wire [15:0] dmrdata_out_MEM_WB;
	wire [15:0] aluout_out_MEM_WB;
	wire [3:0] waddr_out_MEM_WB;
	wire [15:0] aluout_out_EXE_MEM;
	wire [15:0] rdata2_out_EXE_MEM;
	wire [3:0] waddr_out_EXE_MEM;
	wire [15:0] dmrdata;
    wire [15:0] wdata;
    wire [15:0] alu_A, alu_B;
    wire stall, memread_out_ID_EXE, nop;

	// Instantiate the Unit Under Test (UUT)
	bonus uut (
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
		.raddr2(raddr2), 
		.dmrdata_out_MEM_WB(dmrdata_out_MEM_WB), 
		.aluout_out_MEM_WB(aluout_out_MEM_WB), 
		.waddr_out_MEM_WB(waddr_out_MEM_WB), 
		.aluout_out_EXE_MEM(aluout_out_EXE_MEM), 
		.rdata2_out_EXE_MEM(rdata2_out_EXE_MEM), 
		.waddr_out_EXE_MEM(waddr_out_EXE_MEM), 
		.dmrdata(dmrdata),
        .wdata(wdata),
        .alu_A(alu_A),
        .alu_B(alu_B),
        .stall(stall),
        .memread_out_ID_EXE(memread_out_ID_EXE),
        .nop(nop)
	);

initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		fileid = 0;

// Wait 100 ns for global reset to finish
		#10;
		#10 rst = 1;
		#10 rst = 0;
        
		// Add stimulus here

	end
always #5 clk=~clk; 
endmodule

