// Brian Gravelle
// CIS 510 Complex Digital Design
// RISC-V processor June 4 2016
// executor
//CTRL BITS determined in ALU module

module executor #(parameter DATA_WIDTH  = 32, CTRL_BITS = 4)
                (alu_op, shift, a, b, zero, result);
   
   localparam SLL  = 2'b01,
              SRL  = 2'b10,
              SRA  = 2'b11;

   input wire [CTRL_BITS-1:0] alu_op;
   input wire [1:0] shift;
   input wire [DATA_WIDTH-1:0] a, b;

   wire [DATA_WIDTH-1:0] c;

   output reg [DATA_WIDTH-1:0] result;
   output reg zero;

   alu #(.DATA_WIDTH(DATA_WIDTH)) my_alu ( 
     .ctrl (alu_op), 
     .a (a), 
     .b (b), 
     .c (c), 
     .zero (zero), 
     .over (over), 
     .c_out (c_out) 
   ); 

   always @(*) begin
      case (shift)
         SLL     : result <= a << b;
         SRL     : result <= {a[DATA_WIDTH-1], a[DATA_WIDTH-2:0] >> b}; //TODO this wont work
         SRL     : result <= { {b{a[DATA_WIDTH-1]}}, {(DATA_WIDTH-b){a[DATA_WIDTH-1:b]}} }; //TODO maybe this?
         SRA     : result <= {1'b0, a[DATA_WIDTH-2:0] >> b};
         default : result <= c;
         endcase
   end   

endmodule

module tb_executor; 

parameter data_width  = 32;
parameter ctrl_bit = 4;
localparam  AND  = 6'b000000, 
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
            SLL_TB  = 6'b010000,
            SRL_TB  = 6'b100000,
            SRA_TB  = 6'b110000;

   wire [data_width-1:0] result;
   wire zero;
   reg [ctrl_bit-1:0] ctrl;
   reg [data_width-1:0] a, b;

   executor payne ( 
      .alu_op(ctrl), 
      .shift(shift), 
      .a(a), 
      .b(b), 
      .zero(zero), 
      .result(result)
   ); 
    
   initial 
   begin  
   a    = 0;
   b    = 0;
   ctrl = 0;
   #32 a    = 32'h00FF00FF;
       b    = 32'h00FFFF00;
       {shift, ctrl} = AND;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, a & b, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, result, zero);
       a    = 32'h00FF00FF;
       b    = 32'h00FFFF00;
       {shift, ctrl} = OR;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, a | b, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, result, zero);
       a    = 75;
       b    = 25;
       {shift, ctrl} = ADD;
       $display("Expect a=%d b=%d op=%h c=%d zero=%b", a, b, ctrl, a + b, 1'b0);
   #10 $display("Actual a=%d b=%d op=%h c=%d zero=%b", a, b, ctrl, c, zero);
       a    = -75;
       b    = 25;
       {shift, ctrl} = ADD;
       $display("Expect a=%d b=%d op=%h c=%d zero=%b", a, b, ctrl, a + b, 1'b0);
   #10 $display("Actual a=%d b=%d op=%h c=%d zero=%b", a, b, ctrl, c, zero);
       a    = 1;
       b    = -1;
       {shift, ctrl} = ADD;
       $display("Expect a=%d b=%d op=%h c=%d zero=%b", a, b, ctrl, a + b, 1'b1);
   #10 $display("Actual a=%d b=%d op=%h c=%d zero=%b", a, b, ctrl, c, zero);
       a    = 32'h80000000;
       b    = 32'h80000000;
       {shift, ctrl} = ADD;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, a + b, 1'b1);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, c, zero);
       a    = 75;
       b    = 25;
       {shift, ctrl} = SUB;
       $display("Expect a=%d b=%d op=%h c=%d zero=%b", a, b, ctrl, a - b, 1'b0);
   #10 $display("Actual a=%d b=%d op=%h c=%d zero=%b", a, b, ctrl, c, zero);
       a    = -75;
       b    = 25;
       {shift, ctrl} = SUB;
       $display("Expect a=%d b=%d op=%h c=%d zero=%b", a, b, ctrl, a - b, 1'b0);
   #10 $display("Actual a=%d b=%d op=%h c=%d zero=%b", a, b, ctrl, c, zero);
       a    = 1;
       b    = 1;
       {shift, ctrl} = SUB;
       $display("Expect a=%d b=%d op=%h c=%d zero=%b", a, b, ctrl, a - b, 1'b1);
   #10 $display("Actual a=%d b=%d op=%h c=%d zero=%b", a, b, ctrl, c, zero);
       a    = 32'h80000001;
       b    = 32'h00000010;
       {shift, ctrl} = SUB;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, a - b, 1'b1);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, c, zero);
       a    = 32'd5;
       b    = 32'd3;
       {shift, ctrl} = SGE;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, a >= b, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, c, zero);
       a    = 32'd5;
       b    = 32'd10;
       {shift, ctrl} = SGE;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, a >= b, 1'b1);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, c, zero);
       a    = 32'hFFFFBEEF;
       b    = 32'd3;
       {shift, ctrl} = SGE;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, 32'd1, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, c, zero);
       a    = 32'hFFFFBEEF;
       b    = 32'd3;
       {shift, ctrl} = SGEU;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, 32'd0, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, c, zero);
       a    = 32'd5;
       b    = 32'd3;
       {shift, ctrl} = SLT;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, a < b, 1'b1);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, c, zero);
       a    = 32'hFFFFBEEF;
       b    = 32'd3;
       {shift, ctrl} = SLT;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, a < b, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, c, zero);
       a    = 32'h0FFFBEEF;
       b    = 32'hFFFFFFF3;
       {shift, ctrl} = SLTU;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, 1, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, c, zero);
       a    = 32'h00FF00FF;
       b    = 32'h00FFFF00;
       {shift, ctrl} = NOR;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, ~(a | b), 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, zero);
       a    = 32'd1;
       b    = 32'd3;
       {shift, ctrl} = SLL;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, 32'd8, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, zero);
       a    = 32'h80000008;
       b    = 32'd3;
       {shift, ctrl} = SRL;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, 32'hF0000001, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, zero);
       a    = 32'h80000008;
       b    = 32'd3;
       {shift, ctrl} = SRA;
       $display("Expect a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, 32'h10000001, 1'b0);
   #10 $display("Actual a=%h b=%h op=%h c=%h zero=%b", a, b, ctrl, zero);

   end   
    
endmodule 