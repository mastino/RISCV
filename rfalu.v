// Brian Gravelle
// CIS 510 Complex Digital Design
// Lab1 April 13 2016
// Register File

module RegFileALU #(parameter DATA_WIDTH  = 32, NAME_BITS = 5, CTRL_BITS = 4) 
                (clk, rst, imm_e, rs1, rs2, ws_in, op_in, imm_d);
   
   input wire clk, rst, imm_e; 
   input wire [NAME_BITS-1:0] rs1, rs2, ws_in;
   input wire [CTRL_BITS-1:0] op_in;
   input wire [DATA_WIDTH-1:0] imm_d;

   reg  write; 
   reg [NAME_BITS-1:0] ws;
   reg [DATA_WIDTH-1:0] wd;
   wire [DATA_WIDTH-1:0] rd1, rd2;
   
   wire [DATA_WIDTH-1:0] c;
   wire over, c_out, zero;
   reg [DATA_WIDTH-1:0] a, b;


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

   always @(posedge clk) begin
      write <= 1;
      ws    <= (rst) ? 0 : ws_in;
   end

   always @(*) begin
      a     <= rd1;
      b     <= (imm_e) ? imm_d : rd2;
      wd    <= c;
   end

endmodule

module tb_RegFileALU; 
   parameter reg_len  = 32;
   parameter name_bit = 5;
   parameter num_regs = 32;
   parameter ctrl_bits = 4;

   localparam AND = 4'b0000, OR  = 4'b0001, ADD = 4'b0010, SUB = 4'b0110, 
              SLT = 4'b0111, SGE = 4'b0101, NOR = 4'b1100;

   reg clk, rst, imm_e; 
   reg [ctrl_bits-1:0] op_in;
   reg [reg_len-1:0] imm_d;
   reg [name_bit-1:0] rs1, rs2, ws;

   RegFileALU my_very_small_processor_thingy ( 
     .clk   (clk), 
     .rst  (rst),
     .rs1   (rs1), 
     .rs2   (rs2), 
     .ws_in (ws), 
     .op_in (op_in),
     .imm_e (imm_e),
     .imm_d (imm_d)
   ); 
    
   initial 
   begin 
   clk = 0; 
   ws  = 0;
   imm_e = 0;
   rs1 = 0;
   rs2 = 0;
   op_in = 0;
   rst = 1;
   #20 rst = 0;
   #15 ws  = 1;
       rs1 = 0;
       rs2 = 0;
       op_in = OR;
       imm_d = 5;
       imm_e = 1;
   #10 ws  = 2;
       rs1 = 1;
       rs2 = 0;
       op_in = OR;
       imm_e = 0;
   #10 ws  = 6;
       rs1 = 1;
       rs2 = 0;
       op_in = OR;
   #10 ws  = 3;
       rs1 = 0;
       rs2 = 2;
       op_in = ADD;
   #10 ws  = 7;
       rs1 = 6;
       rs2 = 6;
       op_in = AND;
   #10 ws  = 4;
       rs1 = 0;
       rs2 = 3;
       op_in = SUB;
   #10 ws  = 6;
       rs1 = 7;
       rs2 = 6;
       op_in = SGE;
   #10 ws  = 5;
       rs1 = 0;
       rs2 = 2;
       op_in = SLT; 
   #10 ws  = 0;
       rs1 = 0;
       rs2 = 0;
       op_in = AND;
   #10 ws  = 0;
       rs1 = 0;
       rs2 = 0;
       op_in = AND;
   #10 ws  = 0;
       rs1 = 0;
       rs2 = 0;
       op_in = AND;

   $display("Expect 5 in r1, r2, and r3; -5 in r4; 1 in r5");
   $display("Also 5 in r7; r6 will be 5 then 1");


   end 
    
   always 
     #5  clk =  ! clk; 
    
endmodule 