// Brian Gravelle
// CIS 510 Complex Digital Design
// Lab1 April 13 2016
// ALU

module alu #(parameter DATA_WIDTH  = 32, parameter CTRL_BITS = 4) (ctrl, a, b, c, zero, over, c_out);
   
  localparam AND  = 4'b0000, 
             OR   = 4'b0011, 
             XOR  = 4'b0001, 
             ADD  = 4'b0010, 
             SUB  = 4'b0110, 
             SLT  = 4'b0111, 
             SLTU = 4'b1111, 
             SGE  = 4'b0101, 
             SGEU = 4'b1101, 
             NOR  = 4'b1100;

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
        AND : begin
          c <= a & b; // and
          over <= 0;
          c_out <= 0;
          end
        OR  : begin 
          c <= a | b; // or
          over <= 0;
          c_out <= 0;
          end
        ADD : begin 
          {cn, c_temp} <= a[DATA_WIDTH-2:0] + b[DATA_WIDTH-2:0]; // add
          c <= {(cn ^ a[DATA_WIDTH-1] ^ b[DATA_WIDTH-1]), c_temp};
          co <= (cn & a[DATA_WIDTH-1]) | (cn & b[DATA_WIDTH-1]) | (b[DATA_WIDTH-1] & a[DATA_WIDTH-1]);
          over <= (cn != co ? 1 : 0);
          c_out <= co;
          end
        SUB : begin 
          neg_b <= (~b) + 1;
          {cn, c_temp} = a[DATA_WIDTH-2:0] + neg_b[DATA_WIDTH-2:0]; // add
          c <= {(cn ^ a[DATA_WIDTH-1] ^ neg_b[DATA_WIDTH-1]), c_temp};
          co <= (cn & a[DATA_WIDTH-1]) | (cn & neg_b[DATA_WIDTH-1]) | (neg_b[DATA_WIDTH-1] & a[DATA_WIDTH-1]);
          over <= (cn != co ? 1 : 0);
          c_out <= co;
          end
        SLT : begin 
          c <= a < b ? 1 : 0; // slt
          over <= 0;
          c_out <= 0;
          end
        SLTU : begin 
          c <= {1'b0, a} < {1'b0, b} ? 1 : 0; // slt
          over <= 0;
          c_out <= 0;
          end
        SGE : begin
          c <= a >= b ? 1 : 0; // sge for BGRE in RISCV
          over <= 0;
          c_out <= 0;
          end
        SLTU : begin 
          c <= {1'b0, a} >= {1'b0, b} ? 1 : 0; // slt
          over <= 0;
          c_out <= 0;
          end
        NOR : begin 
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

module tb_alu; 
   parameter data_width  = 32;
   parameter ctrl_bit = 4;

  localparam AND  = 4'b0000, 
             OR   = 4'b0011, 
             XOR  = 4'b0001, 
             ADD  = 4'b0010, 
             SUB  = 4'b0110, 
             SLT  = 4'b0111, 
             SLTU = 4'b1111, 
             SGE  = 4'b0101, 
             SGEU = 4'b1101, 
             NOR  = 4'b1100;

   wire [data_width-1:0] c;
   wire over, c_out, zero;
   reg [ctrl_bit-1:0] ctrl;
   reg [data_width-1:0] a, b;

   alu my_alu ( 
   .ctrl (ctrl), 
   .a (a), 
   .b (b), 
   .c (c), 
   .zero (zero), 
   .over (over), 
   .c_out (c_out) 
   ); 
    
   initial 
   begin  
   a    = 0;
   b    = 0;
   ctrl = 0;
   #32 a    = 32'h00FF00FF;
       b    = 32'h00FFFF00;
       ctrl = 4'b0000;
       $display("Expect a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, a & b, 1'b0, 1'b0, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 32'h00FF00FF;
       b    = 32'h00FFFF00;
       ctrl = 4'b0001;
       $display("Expect a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, a | b, 1'b0, 1'b0, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 75;
       b    = 25;
       ctrl = 4'b0010;
       $display("Expect a=%d b=%d op=%h c=%d over=%b c_out=%b zero=%b", a, b, ctrl, a + b, 1'b0, 1'b0, 1'b0);
   #10 $display("Actual a=%d b=%d op=%h c=%d over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = -75;
       b    = 25;
       ctrl = 4'b0010;
       $display("Expect a=%d b=%d op=%h c=%d over=%b c_out=%b zero=%b", a, b, ctrl, a + b, 1'b0, 1'b0, 1'b0);
   #10 $display("Actual a=%d b=%d op=%h c=%d over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 1;
       b    = -1;
       ctrl = 4'b0010;
       $display("Expect a=%d b=%d op=%h c=%d over=%b c_out=%b zero=%b", a, b, ctrl, a + b, 1'b0, 1'b1, 1'b1);
   #10 $display("Actual a=%d b=%d op=%h c=%d over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 32'h80000000;
       b    = 32'h80000000;
       ctrl = 4'b0010;
       $display("Expect a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, a + b, 1'b1, 1'b1, 1'b1);
   #10 $display("Actual a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 75;
       b    = 25;
       ctrl = 4'b0110;
       $display("Expect a=%d b=%d op=%h c=%d over=%b c_out=%b zero=%b", a, b, ctrl, a - b, 1'b0, 1'b1, 1'b0);
   #10 $display("Actual a=%d b=%d op=%h c=%d over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = -75;
       b    = 25;
       ctrl = 4'b0110;
       $display("Expect a=%d b=%d op=%h c=%d over=%b c_out=%b zero=%b", a, b, ctrl, a - b, 1'b0, 1'b0, 1'b0);
   #10 $display("Actual a=%d b=%d op=%h c=%d over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 1;
       b    = 1;
       ctrl = 4'b0110;
       $display("Expect a=%d b=%d op=%h c=%d over=%b c_out=%b zero=%b", a, b, ctrl, a - b, 1'b0, 1'b1, 1'b1);
   #10 $display("Actual a=%d b=%d op=%h c=%d over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 32'h80000001;
       b    = 32'h00000010;
       ctrl = 4'b0110;
       $display("Expect a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, a - b, 1'b1, 1'b1, 1'b1);
   #10 $display("Actual a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 32'd5;
       b    = 32'd3;
       ctrl = 4'b0101;
       $display("Expect a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, a >= b, 1'b0, 1'b0, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 32'hFFFFBEEF;
       b    = 32'd3;
       ctrl = 4'b0101;
       $display("Expect a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, a >= b, 1'b0, 1'b0, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 32'd5;
       b    = 32'd10;
       ctrl = 4'b0101;
       $display("Expect a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, a >= b, 1'b0, 1'b0, 1'b1);
   #10 $display("Actual a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 32'd5;
       b    = 32'd3;
       ctrl = 4'b0111;
       $display("Expect a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, a < b, 1'b0, 1'b0, 1'b1);
   #10 $display("Actual a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 32'hFFFFBEEF;
       b    = 32'd3;
       ctrl = 4'b0111;
       $display("Expect a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, a < b, 1'b0, 1'b0, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 32'h0FFFBEEF;
       b    = 32'hFFFFFFF3;
       ctrl = SLTU;
       $display("Expect a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, 1, 1'b0, 1'b0, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);
       a    = 32'h00FF00FF;
       b    = 32'h00FFFF00;
       ctrl = 4'b1100;
       $display("Expect a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, ~(a | b), 1'b0, 1'b0, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h over=%b c_out=%b zero=%b", a, b, ctrl, c, over, c_out, zero);

   end

    
endmodule 