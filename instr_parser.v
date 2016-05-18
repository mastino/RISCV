// Brian Gravelle
// CIS 510 Complex Digital Design
// RISC-V processor May 16 2016
// instr_parser
// separates instruction into relevant chunks

module instr_parser #(parameter INSTR_WIDTH  = 32, REG_NAME_BITS = 5, FUNC_BITS = 3, OP_BITS = 7) 
                    (instr, rs1, rs2, rd, funct3, imm, op);
   
   //opcodes
   localparam OP_IMM   = 7'b0010011, 
			  LUI      = 7'b0110111, 
			  AUIPC    = 7'b0010111, 
			  OP       = 7'b0110011, 
			  JAL      = 7'b1101111, 
			  JALR     = 7'b1100111, 
			  BRANCH   = 7'b1100011, 
			  LOAD     = 7'b0000011, 
			  STORE    = 7'b0100011, 
			  MISC_MEM = 7'b0001111, 
			  SYSTEM   = 7'b1110011;
   
   output reg [REG_NAME_BITS-1:0] rs1, rs2, rd;
   output reg [FUNC_BITS-1:0] funct3;
   output reg [INSTR_WIDTH-1:0] imm;
   output reg [OP_BITS-1:0] op;

   input [INSTR_WIDTH-1:0] instr;

   always @ (instr)
   begin
      case ( instr[OP_BITS-1:0] )

        op <= instr[OP_BITS-1:0];

        OP_IMM : begin
          rs1    <= instr[19:15];
          rs2    <= instr[24:20];
          rd     <= instr[11:7];
          funct3 <= instr[14:12];
          imm    <= { {30{instr[31]}}, instr[30:20]};
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
        MISC_MEM : begin 
          
          end
        SYSTEM : begin 
          
          end
        default : begin
          
          end
      endcase

      zero = c == 0 ? 1 : 0;

   end

endmodule

module tb_decoder; 

   
    
endmodule 