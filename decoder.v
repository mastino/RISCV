// Brian Gravelle
// CIS 510 Complex Digital Design
// RISC-V processor May 16 2016
// decoder
//

module decoder #(DATA_WIDTH  = 32) (instr, pc, imm, op, func, rs1, rs2, rd);
   

   output reg [DATA_WIDTH-1:0] imm;
   output reg [6:0] op;
   output reg [2:0] func;
   output reg [4:0] rs1, rs2, rd;
   input [DATA_WIDTH-1:0] instr, pc;

   reg cn, co;
   reg [DATA_WIDTH-1:0] neg_b;
   reg [DATA_WIDTH-2:0] c_temp;

   always @ (*)
   begin
      op   <= instr[6:0];
      func <= instr[14:12];
      rs1  <= instr[19:15];
      rs2  <= instr[24:20];
      rd   <= instr[11:7];

      case ( instr[6:0] )
         6'b0000 : begin
            imm <= 
            end
         default : begin
            
            end
      endcase
   end

endmodule

module tb_decoder; 

   
    
endmodule 