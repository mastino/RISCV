// Brian Gravelle
// CIS 510 Complex Digital Design
// RISC-V processor May 16 2016
// decoder
//

module #(parameter FUNC_BITS = 3, OP_BITS = 7) alu_op_gen (op, func3, alt_op );
   
  localparam AND  = 4'b0000, 
             OR   = 4'b0011, 
             XOR  = 4'b0001, 
             ADD  = 4'b0010, 
             SUB  = 4'b0110, 
             SLT  = 4'b0111, 
             SLTU = 4'b1111, 
             SGE  = 4'b0101, 
             NOR  = 4'b1100;

   input [FUNC_BITS-1:0] funct3;
   input [OP_BITS-1:0] op;
   output reg;

   always @ (*)
   begin
      case ( ctrl )
        OP_IMM : begin
          case (func3)
            3'b000 : 

          end
        LUI : begin 
          
          end
        AUIPC : begin 
          
          end
        OP : begin 
          
          end
        JAL : begin 
          
          end
        JALR : begin
          
          end
        BRANCH : begin 
          
          end
        LOAD : begin 
         
          end
        STORE : begin 
          
          end
        default : begin //MISC_MEM, SYSTEM
          
          end
      endcase
   end

endmodule

module tb_alu_op_gen; 

   
    
endmodule 