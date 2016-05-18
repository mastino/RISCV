// Brian Gravelle
// CIS 510 Complex Digital Design
// RISCV processor 
// Memory
// NOTE: LITTLE ENDIAN

module Memory #(parameter ADDR_WIDTH  = 32) 
                    (clk, rst, we, ra, wa, wd, rs, ws, rd);

    localparam DATA_WIDTH = 32;

    output reg [DATA_WIDTH-1:0] rd;
    input [DATA_WIDTH-1:0] wd;
    input [ADDR_WIDTH-1:0] ra, wa;
    input [1:0] rs, ws;
    input clk, rst, we;

    reg [7:0] mem [(1<<ADDR_WIDTH)-1:0];

    always @ (*)
    begin
      if(rst) begin
        rd <= 0;  
      end else begin
        case (rs)
          2'd1    : rd <= ( (ra == wa) & we) ? wd : {24'd0, mem[ra+3]};
          2'd2    : rd <= ( (ra == wa) & we) ? wd : {16'd0, mem[ra+2], mem[ra+3]};
          2'd3    : rd <= ( (ra == wa) & we) ? wd : {8'd0,  mem[ra+1], mem[ra+2], mem[ra+3]};
          default : rd <= ( (ra == wa) & we) ? wd : {mem[ra], mem[ra+1], mem[ra+2], mem[ra+3]};
        endcase
        if(we) begin
          case (ws)
            2'd1    : begin
              mem[wa] <= wd[DATA_WIDTH-25:DATA_WIDTH-32];
            end
            2'd2    : begin
              mem[wa]   <= wd[DATA_WIDTH-17:DATA_WIDTH-24];
              mem[wa+1] <= wd[DATA_WIDTH-25:DATA_WIDTH-32];
            end
            2'd3    : begin
              mem[wa]   <= wd[DATA_WIDTH-9:DATA_WIDTH-16];
              mem[wa+1] <= wd[DATA_WIDTH-17:DATA_WIDTH-24];
              mem[wa+2] <= wd[DATA_WIDTH-25:DATA_WIDTH-32];
            end
            default : begin
              mem[wa]   <= wd[DATA_WIDTH-1:DATA_WIDTH-8];
              mem[wa+1] <= wd[DATA_WIDTH-9:DATA_WIDTH-16];
              mem[wa+2] <= wd[DATA_WIDTH-17:DATA_WIDTH-24];
              mem[wa+3] <= wd[DATA_WIDTH-25:DATA_WIDTH-32];
            end
          endcase
        end
      end
    end
   
endmodule

module tb_Memory; 
   parameter addr_bits  = 32;
   parameter data_width = 32;

   wire [data_width-1:0] rd;
   reg  [data_width-1:0] wd;
   reg  [addr_bits-1:0]  ra, wa;
   reg  clk, rst, we;
   reg  [1:0] rs, ws;

   Memory #(.ADDR_WIDTH(addr_bits)) foam ( 
     .clk (clk), 
     .rst (rst), 
     .we  (we),
     .ra  (ra), 
     .wa  (wa),
     .rs  (rs), 
     .ws  (ws), 
     .wd  (wd),  
     .rd  (rd)
   ); 
    
   initial 
   begin 
        clk = 0;
        ws  = 0;
        rs  = 0;
   #5   rst = 0; 
        we  = 0;
        ra  = 0;
        wa  = 0;
        wd  = 1;
   #10  rst = 1; // reset
        we  = 0;
        ra  = 0;
        wa  = 0;
        wd  = 1;
   #10  $display("Expect rd=%h", 0);
        $display("Actual rd=%h", rd);
        $display(" ");
        rst = 0;
        we  = 1;
        ra  = 1;
        wa  = 0;
        wd  = 5;
   #10  $display("Expect rd=????");
        $display("Actual rd=%h", rd);
        $display(" ");
        we  = 0;
        ra  = 0;
        wa  = 1;
        wd  = 8;
   #10  $display("Expect rd=%h", 5);
        $display("Actual rd=%h", rd);
        $display(" ");
        we  = 0;
        ra  = 0;
        wa  = 0;
        wd  = 8;
   #10  $display("Expect rd=%h", 5);
        $display("Actual rd=%h", rd);
        $display(" ");
        we  = 0;
        ra  = 0;
        wa  = 0;
        wd  = 8;
   #10  $display("Expect rd=%h", 5);
        $display("Actual rd=%h", rd);
        $display(" ");
        we  = 1;
        ra  = 1;
        wa  = 1;
        wd  = 1;
   #10  $display("Expect rd=%h", 1);
        $display("Actual rd=%h", rd);
        $display(" ");
        we  = 1;
        ra  = 1;
        wa  = 32'hACDC1234;
        wd  = 2;
   #10  $display("Expect rd=%h", 1);
        $display("Actual rd=%h", rd);
        $display(" ");
        we  = 1;
        ra  = 32'hACDC1234;
        wa  = 2;
        wd  = 3;
   #10  $display("Expect rd=%h", 2);
        $display("Actual rd=%h", rd);
        $display(" ");
        we  = 0;
        ra  = 2;
        wa  = 2;
        wd  = 6;
   #10  $display("Expect rd=%h", 3);
        $display("Actual rd=%h", rd);
        $display(" ");

   end 
    
   always 
     #5  clk =  ! clk; 
    
endmodule 