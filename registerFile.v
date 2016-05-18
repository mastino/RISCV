// Brian Gravelle
// CIS 510 Complex Digital Design
// Lab1 April 13 2016
// Register File

module registerFile #(parameter REG_WIDTH  = 32, NAME_BITS = 5) (rst, write, read, rs1, rs2, ws, wd, rd1, rd2);
   
   output [REG_WIDTH-1:0] rd1, rd2;
   input [REG_WIDTH-1:0] wd;
   input [NAME_BITS-1:0] rs1, rs2, ws;
   input rst, write, read;

   reg [REG_WIDTH-1:0] rd1, rd2;
   reg [REG_WIDTH-1:0] regs [(1<<NAME_BITS)-1:0];

   always @ (posedge rst)
   begin
      regs[0] <= 0;
   end 

   always @ (posedge write)
   begin
      if(rst)
      begin
         regs[0] <= 0;
      end else
      begin
        if(ws == 0)
        begin
          regs[ws] <= 0;
        end else
        begin
          regs[ws] <= wd;
        end
      end
   end

   always @ (posedge read)
   begin
      rd1 <= regs[rs1];
      rd2 <= regs[rs2];
   end
   
endmodule

module tb_registerFile; 
   parameter reg_len  = 32;
   parameter name_bit = 5;
   parameter num_regs = 32;

   reg rst, write, read; 
   wire [reg_len-1:0] rd1, rd2;
   reg [reg_len-1:0] wd;
   reg [name_bit-1:0] rs1, rs2, ws;

   registerFile regFile ( 
   .rst (rst), 
   .write (write), 
   .read (read), 
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
       read  = 0;
   #5  rst   = 1; // reset
       write = 0;
       read  = 0;
   #5  rst   = 0; // wait
       write = 0;
       read  = 0;
   #5  ws    = 1; // r1 = 1
       wd    = 1;
       write = 1;
   #5  read  = 1; // read r1 and r0
       rs1   = 1;
       rs2   = 0;
       write = 0;
   #5  read  = 0; // r31 = 3
       ws    = 31;
       wd    = 3;
       write = 1;
   #5  read  = 1; // read r0 and r31
       rs1   = 0;
       rs2   = 31;
       write = 0;
   #5  read  = 0; // r1 = 5
       ws    = 1;
       wd    = 5;
       write = 1;
   #5  read  = 1; //read r1 and r31
       rs1   = 1;
       rs2   = 31;
       write = 0;
   #5  rst   = 0; // wait
       write = 0;
       read  = 0;

   end 
    
   // always 
   //   #5  clk =  ! clk; 
    
endmodule 