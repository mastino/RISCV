// Brian Gravelle
// CIS 510 Complex Digital Design
// RISC-V processor May 16 2016
// branch ctrl
//

module branch_ctrl #(ADDR_WIDTH  = 16) (func3, imm, pc, zero, br_en, j_en, br_addr, br_true, j_addr, j_true);
   

   output reg [ADDR_WIDTH-1:0] br_addr, j_addr;
   output reg br_true, j_true;
   input [DATA_WIDTH-1:0] instr, pc;
   input br_en, j_en;

   reg cn, co;
   reg [DATA_WIDTH-1:0] neg_b;
   reg [DATA_WIDTH-2:0] c_temp;

   always @ (*)
   begin
      if(br_en) begin
         j_addr <= pc;
         j_true <= 1'b0;
         case (func3)
            3'b000 : {br_true, br_addr} <= (zero)  ? {1'b1, pc+imm} : {1'b0, pc}; //EQ
            3'b001 : {br_true, br_addr} <= (!zero) ? {1'b1, pc+imm} : {1'b0, pc}; //NE
            3'b100 : {br_true, br_addr} <= (!zero) ? {1'b1, pc+imm} : {1'b0, pc}; //LT
            3'b101 : {br_true, br_addr} <= (!zero) ? {1'b1, pc+imm} : {1'b0, pc}; //GE
            3'b110 : {br_true, br_addr} <= (!zero) ? {1'b1, pc+imm} : {1'b0, pc}; //LTU
            3'b111 : {br_true, br_addr} <= (!zero) ? {1'b1, pc+imm} : {1'b0, pc}; //GEU
            default: {br_true, br_addr} <= {1'b0, pc}; 
            endcase
      end else if(j_en) begin //TODO implement jump
         br_addr <= pc;
         br_true <= 1'b0;
         j_addr <= pc;
         j_true <= 1'b0;         
   end

endmodule

module tb_branch_ctrl; 

   
    
endmodule 