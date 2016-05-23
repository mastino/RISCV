// Brian Gravelle
// CIS 510 Complex Digital Design
// Lab1 April 13 2016
// Register File

module RegFileALUMem #(parameter DATA_WIDTH  = 32, NAME_BITS = 5, CTRL_BITS = 4, addr_bits  = 16)
                 (clk, rst, rs1_in, rs2_in, ws_in, op_in, imm_d_in, inputs);
   
   input wire clk, rst;
   input wire [6:0] inputs; // reg_we, imm_e, mem_rst, mem_we, mem_re, mem_rs, mem_ws
   input wire [NAME_BITS-1:0] rs1_in, rs2_in, ws_in;
   input wire [CTRL_BITS-1:0] op_in;
   input wire [DATA_WIDTH-1:0] imm_d_in;

   // for RF
   reg  write, read;  
   reg [NAME_BITS-1:0] ws, rs1, rs2;
   wire [DATA_WIDTH-1:0] rd1, rd2;
   reg [DATA_WIDTH-1:0] wd, imm_d;
   
   // for ALU
   wire [DATA_WIDTH-1:0] c;
   wire over, c_out, zero;
   reg [DATA_WIDTH-1:0] a, b;
   reg reg_we, imm_e;

   // for MEM
   wire [DATA_WIDTH-1:0] mem_rd;
   reg  [DATA_WIDTH-1:0] mem_wd;
   reg  [addr_bits-1:0]  mem_ra, mem_wa;
   reg  mem_rst, mem_we, mem_re, mem_rs, mem_ws;

   Memory #(.ADDR_WIDTH(addr_bits)) foam ( 
     .clk (clk), 
     .rst (mem_rst), 
     .we  (mem_we),
     .re  (mem_re),
     .ra  (mem_ra), 
     .wa  (mem_wa),
     .rs  (mem_rs), 
     .ws  (mem_ws), 
     .wd  (mem_wd),  
     .rd  (mem_rd)
   ); 
    
   registerFile_2 regFile ( 
     .rst (rst), 
     .we  (reg_we), 
     .rs1 (rs1), 
     .rs2 (rs2), 
     .ws  (ws),  
     .wd  (wd), 
     .rd1 (rd1), 
     .rd2 (rd2) 
   ); 

   alu my_alu ( 
     .ctrl (op_in), 
     .a (a), 
     .b (b), 
     .c (c), 
     .zero (zero), 
     .over (over), 
     .c_out (c_out) 
   ); 

   always @(*) begin
      a  <= rd1;
      b  <= (imm_e)  ? imm_d : rd2;
      wd <= (mem_re) ? mem_rd : c;

      mem_wd <= rd2;
      mem_ra <= c;
      mem_wa <= c;
   end

   always @(posedge clk) begin
      ws      <= (rst) ? 0 : ws_in;
      rs1     <= (rst) ? 0 : rs1_in;
      rs2     <= (rst) ? 0 : rs2_in;
      imm_d   <= (rst) ? 0 : imm_d_in;
      reg_we  <= (rst) ? 0 : inputs[6];
      imm_e   <= (rst) ? 0 : inputs[5];
      mem_rst <= (rst) ? 1 : inputs[4];
      mem_we  <= (rst) ? 0 : inputs[3];
      mem_re  <= (rst) ? 0 : inputs[2];
      mem_rs  <= (rst) ? 0 : inputs[1];
      mem_ws  <= (rst) ? 0 : inputs[0];
   end

endmodule

module tb_RegFileALUMem; 
   parameter reg_len  = 32;
   parameter name_bit = 5;
   parameter num_regs = 32;
   parameter ctrl_bits = 4;

   // for op_in
   localparam AND = 4'b0000, OR  = 4'b0001, ADD = 4'b0010, SUB = 4'b0110, 
              SLT = 4'b0111, SGE = 4'b0101, NOR = 4'b1100;

   // for inputs
   localparam REG = 7'b1000000, IMM = 7'b1100000, SW = 7'b0101000, LW = 7'b1100100; 


   reg clk, rst, imm_e, mem_rst, mem_we, mem_re, mem_rs, mem_ws; 
   reg [ctrl_bits-1:0] op;
   reg [reg_len-1:0] imm_d;
   reg [name_bit-1:0] rs1, rs2, ws;
   reg [6:0] inputs; // reg_we, imm_e, mem_rst, mem_we, mem_re, mem_rs, mem_ws

   RegFileALUMem little_processing_thing ( 
      .clk       (clk), 
      .rst       (rst),
      .rs1_in    (rs1), 
      .rs2_in    (rs2),
      .ws_in     (ws),
      .op_in     (op),
      .imm_d_in  (imm_d),
      .inputs    (inputs)
   ); 
    
   initial 
   begin 
   clk     = 0; 
   rst     = 1;
   rs1     = 0;
   rs2     = 0;
   ws      = 0;
   op      = 0;
   imm_d   = 0;
   inputs  = REG;

   #20 rst = 0;
   #15 rs1     = 0;
       rs2     = 0;
       ws      = 0;
       op      = 0;
       imm_d   = 0;
       inputs  = REG;
   #10 rs1     = 0;
       rs2     = 0;
       ws      = 1;
       op      = ADD;
       imm_d   = 5;
       inputs  = IMM;
   #10 rs1     = 0;
       rs2     = 1;
       ws      = 0;
       op      = ADD;
       imm_d   = 4;
       inputs  = SW;
   #10 rs1     = 0;
       rs2     = 1;
       ws      = 1;
       op      = ADD;
       imm_d   = 0;
       inputs  = SW;
   #10 rs1     = 0;
       rs2     = 1;
       ws      = 0;
       op      = ADD;
       imm_d   = 8;
       inputs  = SW;
   #10 rs1     = 0;
       rs2     = 0;
       ws      = 2;
       op      = ADD;
       imm_d   = 8;
       inputs  = LW;
   #10


   $display("Expect 5 in r1 and r2");

   end 
    
   always 
     #5  clk =  ! clk; 
    
endmodule 