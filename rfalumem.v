// Brian Gravelle
// CIS 510 Complex Digital Design
// Lab1 April 13 2016
// Register File

module RegFileALUMemory #(parameter DATA_WIDTH  = 32, NAME_BITS = 5, CTRL_BITS = 4, addr_bits  = 16)
                 (clk, rst, imm_e, rs1, rs2, ws_in, op_in, imm_d, mem_rst, mem_we, mem_re, mem_rs, mem_ws);
   
   input wire clk, rst, imm_e, mem_rst, mem_we, mem_re, mem_rs, mem_ws; 
   input wire [NAME_BITS-1:0] rs1, rs2, ws_in;
   input wire [CTRL_BITS-1:0] op_in;
   input wire [DATA_WIDTH-1:0] imm_d;

   // for RF
   reg  write, read; 
   reg [NAME_BITS-1:0] ws;
   wire [DATA_WIDTH-1:0] rd1, rd2;
   reg [DATA_WIDTH-1:0] wd;
   
   // for ALU
   wire [DATA_WIDTH-1:0] c;
   wire over, c_out, zero;
   reg [DATA_WIDTH-1:0] a, b;

   // for MEM
   wire [DATA_WIDTH-1:0] mem_rd;
   reg  [DATA_WIDTH-1:0] mem_wd;
   reg  [addr_bits-1:0]  mem_ra, mem_wa;

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
     .we  (write), 
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
      write <= 1;
      ws    <= (rst) ? 0 : ws_in;
   end

endmodule

module tb_RegFileALU; 
   parameter reg_len  = 32;
   parameter name_bit = 5;
   parameter num_regs = 32;
   parameter ctrl_bits = 4;

   localparam AND = 4'b0000, OR  = 4'b0001, ADD = 4'b0010, SUB = 4'b0110, 
              SLT = 4'b0111, SGE = 4'b0101, NOR = 4'b1100;


   reg clk, rst, imm_e, mem_rst, mem_we, mem_re, mem_rs, mem_ws; 
   reg [ctrl_bits-1:0] op_in;
   reg [reg_len-1:0] imm_d;
   reg [name_bit-1:0] rs1, rs2, ws;

   RegFileALU my_very_small_processor_thingy ( 
     .clk     (clk), 
     .rst     (rst),
     .rs1     (rs1), 
     .rs2     (rs2), 
     .ws_in   (ws), 
     .op_in   (op_in),
     .imm_e   (imm_e),
     .imm_d   (imm_d),
     .mem_rst (mem_rst),
     .mem_we  (mem_we),
     .mem_re  (mem_re),
     .mem_rs  (mem_rs),
     .mem_ws  (mem_ws)
   ); 
    
   initial 
   begin 
   clk     = 0; 
   ws      = 0;
   imm_e   = 0;
   rs1     = 0;
   rs2     = 0;
   op_in   = 0;
   rst     = 1;
   mem_rst = 0;
   mem_re  = 0;
   mem_we  = 0;

   #20 rst = 0;
   #15 ws  = 1;
       rs1 = 0;
       rs2 = 0;
       op_in = 4'b0001;
       imm_d = 5;
       imm_e = 1;
       mem_re  = 0;
       mem_we  = 0;
   #10 ws  = 2;
       rs1 = 1;
       rs2 = 0;
       op_in = 4'b0001;
       imm_e = 0;
       mem_re  = 0;
       mem_we  = 0;


   $display("Expect ");

   end 
    
   always 
     #5  clk =  ! clk; 
    
endmodule 