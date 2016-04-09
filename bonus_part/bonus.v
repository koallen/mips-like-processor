`timescale 1ns / 1ps
`include "define.v"

//////////////////////////////////
// BONUS PART OF CZ3001 PROJECT //
//                              //
// Things to be implemented:    //
// - Pipeline stall/flush       //
// - Data Forwarding            //
// - NOP                        //
// - Data Cache                 //
//                              //
//         JIAYOU = =!          //
//////////////////////////////////

// Data forwarding is already implemented
// Currently the following data forwarding can be achieved:
//   ALU to ALU forwarding (EXE_MEM to ID_EXE & MEM_WB to ID_EXE)
//   MEM to MEM forwarding (MEM_WB to EXE_MEM)
//
// Pipeline stall is already implemented
// Inserting NOP is implemented with stall

module bonus(
	clk,
	rst,
	fileid,
	PCOUT,
	INST,
	rdata1,
	rdata2,
	rdata1_out_ID_EXE,
	rdata2_out_ID_EXE,
	imm_out_ID_EXE,
	rdata2_imm_out_ID_EXE,
	aluop_out_ID_EXE,
	alusrc,
	waddr_out_ID_EXE,
	aluout,
	raddr1,
	raddr2,
    aluout_out_EXE_MEM,
	rdata2_out_EXE_MEM,
	waddr_out_EXE_MEM,
	dmrdata_out_MEM_WB,
	aluout_out_MEM_WB,
	waddr_out_MEM_WB,
	dmrdata,
    wdata,
    alu_A,
    alu_B,
    stall,
    memread_out_ID_EXE,
    nop
);

//
// I/O declarations
//
input clk;											
input rst;
input fileid; 
 
output [`ISIZE-1:0] PCOUT;
output [`DSIZE-1:0] rdata1;
output [`DSIZE-1:0] rdata1_out_ID_EXE;
output [`DSIZE-1:0] rdata2;
output [`DSIZE-1:0] rdata2_out_ID_EXE;
output [`DSIZE-1:0] imm_out_ID_EXE;
output [`DSIZE-1:0] rdata2_imm_out_ID_EXE;
output [`DSIZE-1:0] INST;
output alusrc;
output [2:0] aluop_out_ID_EXE;
output [`ASIZE-1:0] waddr_out_ID_EXE;	
output [`DSIZE-1:0] aluout;
output [`ASIZE-1:0] raddr1, raddr2;
output [`DSIZE-1:0] aluout_out_EXE_MEM, rdata2_out_EXE_MEM;
output [`ASIZE-1:0] waddr_out_EXE_MEM;
output [`DSIZE-1:0] dmrdata;
output [`DSIZE-1:0] dmrdata_out_MEM_WB, aluout_out_MEM_WB;
output [`ASIZE-1:0] waddr_out_MEM_WB;
output [`DSIZE-1:0] wdata;
output [`DSIZE-1:0] alu_A, alu_B;
output stall;
output memread_out_ID_EXE;
output nop;

//
// wire declarations
//
wire [2:0] aluop;
wire [`DSIZE-1:0] imm = {{12{INST[3]}}, INST[3:0]};
wire [`DSIZE-1:0] rdata1_out_ID_EXE, rdata2_out_ID_EXE, rdata2_imm_out_ID_EXE;
wire [`ASIZE-1:0] waddr_out_ID_EXE;
wire [`ISIZE-1:0] nPC_out_ID_EXE;
wire [`ISIZE-1:0] nPC_out_EXE_MEM;
wire [`ISIZE-1:0] nPC_out_MEM_WB;
wire [2:0] aluop_out_ID_EXE;
// rt/imm rd mux
wire [`ASIZE-1:0] raddr2 = regdst ? INST[11:8] : INST[3:0];
// dm regfile mux
wire [`DSIZE-1:0] wdata_MEM_WB = memtoreg_out_MEM_WB ? dmrdata : aluout_out_MEM_WB; // compensate for the memory delay
// jump related
wire [`DSIZE-1:0] wdata = jal_out_MEM_WB ? nPC_out_MEM_WB : wdata_MEM_WB;
wire [`ASIZE-1:0] waddr = jal_out_MEM_WB ? 4'b1111 : waddr_out_MEM_WB;
wire [`ISIZE-1:0] jaddr = {nPC[15:12], INST[11:0]};
// rdata2 imm mux
wire [`DSIZE-1:0] rdata2_imm = alusrc ? imm : rdata2;// mux for selecting immedaite or the rdata2 value
// program counter
wire [`ISIZE-1:0] nPC = PCOUT + 16'b1; // increments PC to PC +1
wire [`ISIZE-1:0] res = nPC + imm;
wire PCsrc = branch & zero;
wire [`ISIZE-1:0] PCIN = stall ? PCOUT : (jr ? rdata1 : (jump ? jaddr : (PCsrc ? res : nPC)));
// data forwarding
wire [3:0] ID_EXE_rs, ID_EXE_rt;
wire [1:0] forwardA, forwardB;
wire [`DSIZE-1:0] alu_A, alu_B;
wire [`DSIZE-1:0] wdata_dm;
// stall related
wire [2:0] aluop_nop = nop ? 3'b0 : aluop;
wire wen_nop = nop ? 1'b0 : wen;
wire memwrite_nop = nop ? 1'b0 : memwrite;
wire memread_nop = nop ? 1'b0 : memread;
wire memtoreg_nop = nop ? 1'b0 : memtoreg;
wire branch_nop = nop ? 1'b0 : branch;
wire jal_nop = nop ? 1'b0 : jal;

//
// assignments
//
assign raddr1 = INST[7:4];
// branch
assign zero = (rdata1 == rdata2_imm) ? 1'b1 : 1'b0;
// data forwarding
assign wdata_dm = forwardC ? dmrdata_out_MEM_WB : rdata2_out_EXE_MEM;

//
// module instantiations
//

// program counter
PC1 pc (
    .clk(clk),
	 .rst(rst),
	 .nextPC(PCIN),
	 .currPC(PCOUT)
	 );

// instruction memory
imemory im (
	 .clk(clk),
	 .rst(rst),
	 .wen(1'b0),
     .stall(stall),
	 .addr(PCIN),
	 .data_in(16'b0),
	 .fileid(4'b0),
	 .data_out(INST)
	 );

// data memory
memory dm (
    .clk(clk), 
    .rst(rst), 
    .wen(memwrite_out_EXE_MEM), // from control unit, implicit wire
    .addr(aluout_out_EXE_MEM), // from alu output
    .data_in(wdata_dm), // rdata2 or forwarded data
    .fileid(4'b1000), // 8 for data memory input
    .data_out(dmrdata) // out to aluout dmout mux
    );

// control unit
control C0 (
    .inst(INST[15:12]),
	 .wen(wen), // implicit wire
	 .alusrc(alusrc), // implicit wire
	 .aluop(aluop),  
	 .regdst(regdst), // implicit wire
	 .memwrite(memwrite), // implicit wire
	 .memtoreg(memtoreg), // implicit wire
	 .branch(branch), // implicit wire
	 .jump(jump), // implicit wire
	 .jr(jr), // implicit wire
	 .jal(jal), // implicit wire
     .memread(memread) // implicit wire
	 );
	 
// register file
regfile RF0 (
	 .clk(clk),
	 .rst(rst),
	 .wen(wen_out_MEM_WB),
	 .raddr1(INST[7:4]),
	 .raddr2(raddr2),
	 .waddr(waddr),
	 .wdata(wdata),
	 .rdata1(rdata1),
	 .rdata2(rdata2)
	 );

// ID EXE pipeline
ID_EXE_stage PIPE1 (
    .clk(clk), 
    .rst(rst), 
    .rdata1_in(rdata1), 
    .rdata2_in(rdata2), 
    .rdata2_imm_in(rdata2_imm),
    .waddr_in(INST[11:8]), 
    .nPC_in(nPC), 
    .aluop_in(aluop_nop), 
    .wen_in(wen_nop), // implicit wire
    .memwrite_in(memwrite_nop), // implicit wire
    .memread_in(memread_nop), // implicit wire
    .memtoreg_in(memtoreg_nop), // implicit wire
	.jal_in(jal_nop), // implicit wire
    //
    .reg_rs_in(INST[7:4]),
    .reg_rt_in(INST[3:0]),
    //
    .rdata1_out(rdata1_out_ID_EXE), 
    .rdata2_out(rdata2_out_ID_EXE), 
    .rdata2_imm_out(rdata2_imm_out_ID_EXE),
    .waddr_out(waddr_out_ID_EXE), 
    .nPC_out(nPC_out_ID_EXE), 
    .aluop_out(aluop_out_ID_EXE), 
    .wen_out(wen_out_ID_EXE), // implicit wire
    .memwrite_out(memwrite_out_ID_EXE), // implicit wire
    .memread_out(memread_out_ID_EXE), // implicit wire
    .memtoreg_out(memtoreg_out_ID_EXE), // implicit wire
	 .jal_out(jal_out_ID_EXE), // implicit wire
     //
    .reg_rs_out(ID_EXE_rs),
    .reg_rt_out(ID_EXE_rt)
    );

// ALU
alu ALU0 (
    .a(alu_A),
	.b(alu_B),
	.op(aluop_out_ID_EXE),
	.out(aluout)
    );//ALU takes its input from pipeline register and the output of mux.

// EXE MEM pipeline
EXE_MEM_stage PIPE2 (
    .clk(clk), 
    .rst(rst), 
    .aluout_in(aluout), 
    .rdata2_in(rdata2_out_ID_EXE), 
    .waddr_in(waddr_out_ID_EXE), 
    .memread_in(memread_out_ID_EXE), 
    .memwrite_in(memwrite_out_ID_EXE), 
    .memtoreg_in(memtoreg_out_ID_EXE), 
    .wen_in(wen_out_ID_EXE), // implicit wire
	.jal_in(jal_out_ID_EXE), // implicit wire
	.nPC_in(nPC_out_ID_EXE),
    .aluout_out(aluout_out_EXE_MEM), 
    .rdata2_out(rdata2_out_EXE_MEM), 
    .waddr_out(waddr_out_EXE_MEM), 
    .memread_out(memread_out_EXE_MEM), // implicit wire
    .memwrite_out(memwrite_out_EXE_MEM), // implicit wire
    .memtoreg_out(memtoreg_out_EXE_MEM), // implicit wire
    .wen_out(wen_out_EXE_MEM), // implicit wire
	.jal_out(jal_out_EXE_MEM),
	.nPC_out(nPC_out_EXE_MEM)
    );

// MEM WB pipeline
MEM_WB_stage PIPE3 (
    .clk(clk), 
    .rst(rst), 
    .waddr_in(waddr_out_EXE_MEM), 
    .dmrdata_in(dmrdata), 
    .aluout_in(aluout_out_EXE_MEM), 
    .wen_in(wen_out_EXE_MEM), // implicit wire
	.jal_in(jal_out_EXE_MEM),
	.nPC_in(nPC_out_EXE_MEM),
    .memtoreg_in(memtoreg_out_EXE_MEM), // implicit wire
    .waddr_out(waddr_out_MEM_WB), 
    .dmrdata_out(dmrdata_out_MEM_WB), 
    .aluout_out(aluout_out_MEM_WB), 
    .wen_out(wen_out_MEM_WB), // implicit wire
    .memtoreg_out(memtoreg_out_MEM_WB), // implicit wire
	.jal_out(jal_out_MEM_WB),
	.nPC_out(nPC_out_MEM_WB)
    );
   
// Data forwarding unit
forwardUnit FU (
    .ID_EXE_rs(ID_EXE_rs),
    .ID_EXE_rt(ID_EXE_rt),
    .EXE_MEM_rd(waddr_out_EXE_MEM),
    .MEM_WB_rd(waddr_out_MEM_WB),
    .EXE_MEM_wen(wen_out_EXE_MEM),
    .MEM_WB_wen(wen_out_MEM_WB),
    .MEM_WB_memtoreg(memtoreg_out_MEM_WB),
    .forwardA(forwardA),
    .forwardB(forwardB),
    .forwardC(forwardC) // implicit wire
    );
    
// alu A forwarding MUX
forwardA FA (
    .rdata1(rdata1_out_ID_EXE),
    .EXE_MEM_forward(aluout_out_EXE_MEM),
    .MEM_WB_forward(wdata_MEM_WB),
    .select(forwardA),
    .alu_A(alu_A)
    );

// alu B forwarding MUX
forwardB FB (
    .rdata2_imm(rdata2_imm_out_ID_EXE),
    .EXE_MEM_forward(aluout_out_EXE_MEM),
    .MEM_WB_forward(wdata_MEM_WB),
    .select(forwardB),
    .alu_B(alu_B)
    );
    
// stall unit
stallUnit SU (
    .clk(clk),
    .ID_EXE_memread(memread_out_ID_EXE),
    .ID_EXE_rd(waddr_out_ID_EXE),
    .IF_ID_rs(INST[7:4]),
    .IF_ID_rt(INST[3:0]),
    .stallPC(stall), // implicit wire
    .nop(nop) // implicit wire
    );

endmodule
