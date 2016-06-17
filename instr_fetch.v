// Brian Gravelle
// CIS 510 Complex Digital Design
// RISC-V processor May 16 2016
// instrustion fetch

module instr_fetch #(ADDR_WIDTH  = 16, DATA_WIDTH = 32) (clk, br_addr, br_true, j_addr, stall, j_true, pc_out, instr);
   

   output reg [DATA_WIDTH-1:0] instr;
   output reg [ADDR_WIDTH-1:0] pc_out;
   input [ADDR_WIDTH-1:0] br_addr, j_addr;
   input br_true, j_true, stall, clk;

   reg [ADDR_WIDTH-1:0] pc, pc_next;
   wire [DATA_WIDTH-1:0] mem_rd;

   //clk and memory write are unused, size is always 4 bytes
   Memory #(.ADDR_WIDTH(ADDR_WIDTH)) i_mem ( 
     .clk (1'b0),  
     .rst (mem_rst), 
     .we  (1'b0),
     .re  (mem_re),
     .ra  (pc), 
     .wa  (ADDR_WIDTH'd0),
     .rs  (1'b0), 
     .ws  (1'b0), 
     .wd  (DATA_WIDTH'd0),  
     .rd  (mem_rd)
   ); 

   always @ (posedge clk) begin
      pc <= pc_next;
   end

   always @ (*)
   begin
      instr  <= mem_rd;
      pc_out <= pc;

      if(br_true) begin
         pc_next <= br_addr;
      end else if(j) begin
         pc_next <= j_addr;
      end else if(stall) begin
         pc_next <= pc;
      end else begin
         pc_next <= pc + 4;
   end

endmodule

module tb_instr_fetch; 

   
    
endmodule 