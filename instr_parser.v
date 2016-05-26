// Brian Gravelle
// CIS 510 Complex Digital Design
// RISC-V processor May 16 2016
// instr_parser
// separates instruction into relevant chunks

module instr_parser #(parameter INSTR_WIDTH  = 32, REG_NAME_BITS = 5, FUNC_BITS = 3, OP_BITS = 7) 
                    (instr, rs1, rs2, rd, funct3, imm, op, 
                    reg1_en, reg2_en, imm_en, regw_en, memr_en, memw_en, alt_op, br_en, j_en);
   
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
   output reg reg1_en, reg2_en, imm_en, regw_en, memr_en, memw_en, alt_op, br_en, j_en;

   input [INSTR_WIDTH-1:0] instr;

   always @ (instr)
   begin
      case ( instr[OP_BITS-1:0] )

        op     <= instr[OP_BITS-1:0];
        rs1    <= instr[19:15];
        rs2    <= instr[24:20];
        rd     <= instr[11:7];
        funct3 <= instr[14:12];

        OP_IMM : begin
          imm <= { {21{instr[31]}}, instr[30:20] };
          reg1_en <= 1;
          reg2_en <= 0;
          imm_en  <= 1;
          regw_en <= 1;
          memr_en <= 0;
          memw_en <= 0;
          br_en   <= 0;
          j_en    <= 0;
          if(instr[14:12] == 3'b101) begin /* shift r */
            imm <= { {27{1'b0}}, instr[24:20] };
            alt_op <= instr[30];
          end else if(instr[14:12] == 3'b001) begin /* shift l */
            imm <= { {27{1'b0}}, instr[24:20] };
            alt_op <= 1'b0;
          end else begin
            imm    <= { {21{instr[31]}}, instr[30:20] };
            alt_op <= 1'b0;
          end
          end
        LUI : begin 
          imm <= { instr[31], instr[30:12], {12{1'b0}} };
          reg1_en <= 0;
          reg2_en <= 0;
          imm_en  <= 1;
          regw_en <= 1;
          memr_en <= 0;
          memw_en <= 0;
          alt_op  <= 1'b0;
          br_en   <= 0;
          j_en    <= 0;
          end
        AUIPC : begin 
          imm <= { instr[31], instr[30:12], {12{1'b0}} };
          reg1_en <= 0;
          reg2_en <= 0;
          imm_en  <= 1;
          regw_en <= 1;
          memr_en <= 0;
          memw_en <= 0;
          alt_op  <= 1'b0;
          br_en   <= 0;
          j_en    <= 0;
          end
        OP : begin 
          imm <= 32'b0;
          reg1_en <= 1;
          reg2_en <= 1;
          imm_en  <= 0;
          regw_en <= 1;
          memr_en <= 0;
          memw_en <= 0;
          br_en   <= 0;
          j_en    <= 0;
          if( (instr[14:12] == 3'b000) | (instr[14:12] == 3'b101) ) begin
            alt_op = instr[30];
          end else begin
            alt_op  <= 1'b0;
          end
          end
        JAL : begin 
          imm <= { {12{instr[31]}}, instr[19:12],  instr[20],  instr[30:21], 1'b0 };
          reg1_en <= 1;
          reg2_en <= 0;
          imm_en  <= 1;
          regw_en <= 1;
          memr_en <= 0;
          memw_en <= 0;
          alt_op  <= 1'b0;
          br_en   <= 0;
          j_en    <= 1;
          end
        JALR : begin
          imm <= { {21{instr[31]}}, instr[30:20] };
          reg1_en <= 0;
          reg2_en <= 0;
          imm_en  <= 1;
          regw_en <= 1;
          memr_en <= 0;
          memw_en <= 0;
          alt_op  <= 1'b0;
          br_en   <= 0;
          j_en    <= 1;
          end
        BRANCH : begin 
          imm <= { {21{instr[31]}}, instr[30:20] };
          reg1_en <= 1;
          reg2_en <= 1;
          imm_en  <= 1;
          regw_en <= 0;
          memr_en <= 0;
          memw_en <= 0;
          alt_op  <= 1'b0;
          br_en   <= 1;
          j_en    <= 0;
          end
        LOAD : begin 
          imm <= { {21{instr[31]}}, instr[30:20] };
          reg1_en <= 1;
          reg2_en <= 0;
          imm_en  <= 1;
          regw_en <= 1;
          memr_en <= 1;
          memw_en <= 0;
          alt_op  <= 1'b0;
          br_en   <= 0;
          j_en    <= 0;
          end
        STORE : begin 
          imm <= { {21{instr[31]}}, instr[30:25], instr[11:8], instr[7] };
          reg1_en <= 1;
          reg2_en <= 1;
          imm_en  <= 1;
          regw_en <= 0;
          memr_en <= 0;
          memw_en <= 1;
          alt_op  <= 1'b0;
          br_en   <= 0;
          j_en    <= 0;
          end
        default : begin //MISC_MEM, SYSTEM
          imm <= 32'b0;
          reg1_en <= 0;
          reg2_en <= 0;
          imm_en  <= 0;
          regw_en <= 0;
          memr_en <= 0;
          memw_en <= 0;
          alt_op  <= 1'b0;
          br_en   <= 0;
          j_en    <= 0;
          end
      endcase
   end

endmodule

module tb_instr_parser; 

   
    
endmodule 