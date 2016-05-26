// Brian Gravelle
// CIS 510 Complex Digital Design
// RISC-V processor May 16 2016
// decoder
//

module #(parameter FUNC_BITS = 3, OP_BITS = 7) alu_op_gen (op, func3, alt_op, alu_op, shift);
   
  //note: these are modified from the ALU op to include shift info
  localparam AND  = 6'b000000, 
             OR   = 6'b000011, 
             XOR  = 6'b000001, 
             ADD  = 6'b000010, 
             SUB  = 6'b000110, 
             SLT  = 6'b000111, 
             SLTU = 6'b001111, 
             SGE  = 6'b000101,
             SGE  = 6'b001101,  
             SGEU = 6'b001101, 
             NOR  = 6'b001100,
             SLL  = 6'b010000,
             SRL  = 6'b100000,
             SRA  = 6'b110000;

   input [FUNC_BITS-1:0] funct3;
   input [OP_BITS-1:0] op;
   input alt_op
   output reg [3:0] alu_op;
   output reg [1:0] shift;

   always @ (*)
   begin
      case ( ctrl )
        OP_IMM : begin
          case (func3)
            3'b000 : {shift, alu_op} <= ADD;
            3'b010 : {shift, alu_op} <= SLT;
            3'b011 : {shift, alu_op} <= SLTU;
            3'b100 : {shift, alu_op} <= XOR;
            3'b110 : {shift, alu_op} <= OR;
            3'b111 : {shift, alu_op} <= AND;
            3'b001 : {shift, alu_op} <= SLL;
            3'b101 : {shift, alu_op} <= (alt_op) ? SRA : SRL;
            default: {shift, alu_op} <= AND;
            endcase
          end
        LUI : begin 
          {shift, alu_op} <= ADD;
          end
        AUIPC : begin 
          {shift, alu_op} <= ADD;
          end
        OP : begin 
          case (func3)
            3'b000 : {shift, alu_op} <= (alt_op) ? SUB : ADD;
            3'b010 : {shift, alu_op} <= SLT;
            3'b011 : {shift, alu_op} <= SLTU;
            3'b100 : {shift, alu_op} <= XOR;
            3'b110 : {shift, alu_op} <= OR;
            3'b111 : {shift, alu_op} <= AND;
            3'b001 : {shift, alu_op} <= SLL;
            3'b101 : {shift, alu_op} <= (alt_op) ? SRA : SRL;
            default: {shift, alu_op} <= AND;
            endcase
          end
        JAL : begin 
          {shift, alu_op} <= ADD;
          end
        JALR : begin
          {shift, alu_op} <= ADD;
          end
        BRANCH : begin 
          case (func3)
            3'b000 : {shift, alu_op} <= SUB;
            3'b001 : {shift, alu_op} <= SUB;
            3'b100 : {shift, alu_op} <= SLT;
            3'b101 : {shift, alu_op} <= SGE;
            3'b110 : {shift, alu_op} <= SLTU;
            3'b111 : {shift, alu_op} <= SGEU;
            default: {shift, alu_op} <= AND;
            endcase
          end
        LOAD : begin 
          {shift, alu_op} <= ADD;         
          end
        STORE : begin 
          {shift, alu_op} <= ADD; 
          end
        default : begin //MISC_MEM, SYSTEM
          {shift, alu_op} <= AND;           
          end
      endcase
   end

endmodule

module tb_alu_op_gen; 

   
    
endmodule 