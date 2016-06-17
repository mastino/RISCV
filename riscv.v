// Brian Gravelle
// CIS 510 Complex Digital Design
// Lab1 June 4 2016
// Top-Level module for single cycle RISCV
//   uses 32-bit base ISA

module riscv #(parameter DATA_WIDTH  = 32, ADDR_WIDTH  = 16) (clk, rst);
   
   input wire clk, rst;

   // for IF or ID or other
   wire [ADDR_WIDTH-1:0] br_addr, j_addr, pc;
   wire [DATA_WIDTH-1:0] instr, imm;
   wire [6:0] instr_op;
   wire [2:0] funct3;
   wire br_true, j_true, br_en, j_en, stall, alt_op, reg1_en, reg2_en, imm_en;

   // for RF
   wire rf_write, rf_read;  
   wire [4:0] rf_ws, rf_rs1, rf_rs2;
   wire [DATA_WIDTH-1:0] rf_rd1, rf_rd2;
   wire [DATA_WIDTH-1:0] rf_wd;
   
   // for executor
   wire [data_width-1:0] exe_result;
   wire exe_zero;
   wire [3:0] exe_ctrl;
   wire [1:0] exe_shift;
   wire [data_width-1:0] exe_a, exe_b;

   // for MEM
   wire [DATA_WIDTH-1:0] mem_rd;
   wire [DATA_WIDTH-1:0] mem_wd;
   wire [ADDR_WIDTH-1:0]  mem_ra, mem_wa;
   wire mem_rst, mem_we, mem_re, mem_rs, mem_ws;
  
   instr_fetch #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) instrFetch (
      .clk(clk), //input
      .br_addr(br_addr), //all others output 
      .br_true(br_true), 
      .j_addr(j_addr), 
      .stall(stall), //not used
      .j_true(j_true), 
      .pc_out(pc), 
      .instr(instr)
   );

   instr_parser instrParser (
      .instr(instr), //input
      .rs1(rf_rs1),  //all others output
      .rs2(rf_rs2), 
      .rd(rf_ws), 
      .funct3(funct3), 
      .imm(imm), 
      .op(instr_op), 
      .reg1_en(reg1_en), 
      .reg2_en(reg2_en), 
      .imm_en(imm_en), 
      .regw_en(rf_reg_we), 
      .memr_en(mem_re), 
      .memw_en(memw_en), 
      .alt_op(alt_op), 
      .br_en(br_en), 
      .j_en(j_en)
   );

   alu_op_gen aluOpGen (
      op(instr_op), 
      func3(funct3), 
      alt_op(alt_op), 
      alu_op(exe_ctrl), 
      shift(exe_shift)
   );

   branch_ctrl branchCtrl (
      func3(funct3), 
      imm(imm), 
      pc(pc), 
      zero(exe_zero), 
      br_en(br_en), 
      j_en(j_en), 
      br_addr(br_addr), 
      br_true(br_true), 
      j_addr(j_addr), 
      j_true(j_true)

   );

   registerFile_2 regFile ( 
     .rst (rst), 
     .we  (rf_write), 
     .rs1 (rf_rs1), 
     .rs2 (rf_rs2), 
     .ws  (rf_ws),  
     .wd  (rf_wd), 
     .rd1 (rf_rd1), 
     .rd2 (rf_rd2) 
   ); 

   executor exe ( 
      .alu_op(exe_ctrl), 
      .shift(exe_shift), 
      .a(rf_rd1), 
      .b(exe_b), 
      .zero(exe_zero), 
      .result(exe_result)
   ); 

   Memory #(.ADDR_WIDTH(ADDR_WIDTH)) d_mem ( 
     .clk (clk), 
     .rst (rst), 
     .we  (mem_we),
     .re  (mem_re),
     .ra  (exe_result), 
     .wa  (exe_result),
     .rs  (mem_rs), 
     .ws  (mem_ws), 
     .wd  (rf_rd2),  
     .rd  (mem_rd)
   ); 

   always @(*) begin
      exe_b  <= (imm_en)  ? imm : rf_rd2;
      rf_wd  <= (mem_re) ? mem_rd : exe_result;
   end

endmodule

module tb_riscv; 
  
    
endmodule 