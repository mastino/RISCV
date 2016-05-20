// Brian Gravelle
// CIS 510 Complex Digital Design
// Lab1 April 13 2016
// Register File
//  - this RF is designed to not clock split
//  - complete combinational

module registerFile_2 #(parameter REG_WIDTH  = 32, NAME_BITS = 5) (rst, we, rs1, rs2, ws, wd, rd1, rd2);
   
   output [REG_WIDTH-1:0] rd1, rd2;
   input [REG_WIDTH-1:0] wd;
   input [NAME_BITS-1:0] rs1, rs2, ws;
   input rst, we;

   reg [REG_WIDTH-1:0] rd1, rd2;
   reg [REG_WIDTH-1:0] regs [(1<<NAME_BITS)-1:0];


   always @ (*)
   begin
      if(rst) begin
        regs[0] <= 0;
      end else if(we) begin
        regs[ws] <= (ws == 0) ? 0 : wd;
        rd1 <= (rs1 == 0) ? 0 : (rs1 == ws) ? wd : regs[rs1];
        rd2 <= (rs2 == 0) ? 0 : (rs2 == ws) ? wd : regs[rs2];
      end else begin
        rd1 <= regs[rs1];
        rd2 <= regs[rs2];
      end
   end
   
endmodule

module tb_registerFile; 
   parameter reg_len  = 32;
   parameter name_bit = 5;
   parameter num_regs = 32;

   reg rst, write; 
   wire [reg_len-1:0] rd1, rd2;
   reg [reg_len-1:0] wd;
   reg [name_bit-1:0] rs1, rs2, ws;

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
    
   initial 
   begin 
        rst   = 0; 
        write = 0;
   #10  rst   = 1; // reset
        write = 0;
   #10  rst   = 0; // wait
        write = 0;
        rs1   = 0;
        rs2   = 0;
   #10  $display("Expect rd1=%h rd1=%h", 0, 0);
        $display("Actual rd1=%h rd2=%h", rd1, rd2);
        $display(" ");
        write = 1;
        ws    = 1;
        wd    = 1;
        rs1   = 1;
        rs2   = 0;
   #10  $display("Expect rd1=%h rd1=%h", 1, 0);
        $display("Actual rd1=%h rd2=%h", rd1, rd2);
        $display(" ");
        write = 0;
        ws    = 1;
        wd    = 5;
        rs1   = 0;
        rs2   = 1;
   #10  $display("Expect rd1=%h rd1=%h", 0, 1);
        $display("Actual rd1=%h rd2=%h", rd1, rd2);
        $display(" ");
        write = 1;
        ws    = 2;
        wd    = 2;
        rs1   = 1;
        rs2   = 1;
   #10  $display("Expect rd1=%h rd1=%h", 1, 1);
        $display("Actual rd1=%h rd2=%h", rd1, rd2);
        $display(" ");
        write = 1;
        ws    = 0;
        wd    = 5;
        rs1   = 2;
        rs2   = 0;
   #10  $display("Expect rd1=%h rd1=%h", 2, 0);
        $display("Actual rd1=%h rd2=%h", rd1, rd2);
        $display(" ");
        write = 0;
        ws    = 1;
        wd    = 5;
        rs1   = 1;
        rs2   = 0;
   #10  $display("Expect rd1=%h rd1=%h", 1, 0);
        $display("Actual rd1=%h rd2=%h", rd1, rd2);
        $display(" ");
      
       

   end 
    
   // always 
   //   #5  clk =  ! clk; 
    
endmodule 