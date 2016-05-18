// Brian Gravelle
// CIS 510 Complex Digital Design
// RISC-V processor May 16 2016
// decoder
//

module decoder #(parameter INSTR_WIDTH  = 32) (instr, pc, );
   
   output reg [DATA_WIDTH-1:0] c;
   output reg zero, over, c_out;
   input [DATA_WIDTH-1:0] a, b;
   input [CTRL_BITS-1:0] ctrl;

   reg cn, co;
   reg [DATA_WIDTH-1:0] neg_b;
   reg [DATA_WIDTH-2:0] c_temp;

   always @ (*)
   begin
      case ( ctrl )
        4'b0000 : begin
          c <= a & b; // and
          over <= 0;
          c_out <= 0;
          end
        4'b0001 : begin 
          c <= a | b; // or
          over <= 0;
          c_out <= 0;
          end
        4'b0010 : begin 
          {cn, c_temp} <= a[DATA_WIDTH-2:0] + b[DATA_WIDTH-2:0]; // add
          c <= {(cn ^ a[DATA_WIDTH-1] ^ b[DATA_WIDTH-1]), c_temp};
          co <= (cn & a[DATA_WIDTH-1]) | (cn & b[DATA_WIDTH-1]) | (b[DATA_WIDTH-1] & a[DATA_WIDTH-1]);
          over <= (cn != co ? 1 : 0);
          c_out <= co;
          end
        4'b0110 : begin 
          neg_b <= (~b) + 1;
          {cn, c_temp} = a[DATA_WIDTH-2:0] + neg_b[DATA_WIDTH-2:0]; // add
          c <= {(cn ^ a[DATA_WIDTH-1] ^ neg_b[DATA_WIDTH-1]), c_temp};
          co <= (cn & a[DATA_WIDTH-1]) | (cn & neg_b[DATA_WIDTH-1]) | (neg_b[DATA_WIDTH-1] & a[DATA_WIDTH-1]);
          over <= (cn != co ? 1 : 0);
          c_out <= co;
          end
        4'b0111 : begin 
          c <= a < b ? 1 : 0; // slt
          over <= 0;
          c_out <= 0;
          end
        4'b0101 : begin
          c <= a >= b ? 1 : 0; // sge for BGRE in RISCV
          over <= 0;
          c_out <= 0;
          end
        4'b1100 : begin 
          c <= ~(a | b); // nor
          over <= 0;
          c_out <= 0;
          end
        default : begin
          c <= 0; over <= 0; c_out <= 0;
          end
      endcase

      zero = c == 0 ? 1 : 0;

   end

endmodule

module tb_decoder; 

   
    
endmodule 