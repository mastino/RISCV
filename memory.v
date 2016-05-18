// Brian Gravelle
// CIS 510 Complex Digital Design
// Lab1 April 13 2016
// Memory

module Memory #(parameter ADDR_WIDTH  = 32, DATA_WIDTH  = 32) 
                    (clk, rst, we, ra, wa, wd, rd);

    output reg [DATA_WIDTH-1:0] rd;
    input [DATA_WIDTH-1:0] wd;
    input [ADDR_WIDTH-1:0] ra, wa;
    input clk, rst, we;

    reg [DATA_WIDTH-1:0] mem [(1<<ADDR_WIDTH)-1:0];

    always @ (posedge clk)
    begin
      if(rst) begin
        rd <= 0;  
      end else begin
        rd <= ( (ra == wa) & we) ? wd : mem[ra];
        if(we) begin
           mem[wa] <= wd;
        end
      end
    end
   
endmodule

module tb_Memory; 
   parameter data_width  = 32;
   parameter addr_bits = 32;

   wire [data_width-1:0] rd;
   reg  [data_width-1:0] wd;
   reg  [addr_bits-1:0]  ra, wa;
   reg  clk, rst, we;

   Memory foam #(.ADDR_WIDTH(addr_bits), .DATA_WIDTH(data_width)) ( 
     .clk (clk), 
     .rst (rst), 
     .we (we),
     .ra (ra), 
     .wa (wa), 
     .wd  (wd),  
     .rd  (rd)
   ); 
    
   initial 
   begin 
       rst = 0; 
       we  = 0;
       ra  = 0;
       wa  = 0;
       wd  = 1;
   #5  rst = 1; // reset
       we  = 0;
       ra  = 0;
       wa  = 0;
       wd  = 1;
       $display("Expect rd=%h", 0);
       $display("Actual rd=%h", rd);
   #5  rst = 0;
       we  = 1;
       ra  = 1;
       wa  = 0;
       wd  = 5;
       $display("Expect rd=????");
       $display("Actual rd=%h", rd);
   #5  we  = 0;
       ra  = 0;
       wa  = 1;
       wd  = 8;
       $display("Expect rd=%h", 5);
       $display("Actual rd=%h", rd);
   #5  we  = 0;
       ra  = 0;
       wa  = 0;
       wd  = 8;
       $display("Expect rd=%h", 5);
       $display("Actual rd=%h", rd);
   #5  we  = 0;
       ra  = 0;
       wa  = 0;
       wd  = 8;
       $display("Expect rd=%h", 5);
       $display("Actual rd=%h", rd);
   #5  we  = 1;
       ra  = 1;
       wa  = 1;
       wd  = 1;
       $display("Expect rd=%h", 1);
       $display("Actual rd=%h", rd);
   #5  we  = 1;
       ra  = 1;
       wa  = 32'hACDC1234;
       wd  = 2;
       $display("Expect rd=%h", 1);
       $display("Actual rd=%h", rd);
   #5  we  = 1;
       ra  = 32'hACDC1234;
       wa  = 2;
       wd  = 3;
       $display("Expect rd=%h", 2);
       $display("Actual rd=%h", rd);
   #5  we  = 0;
       ra  = 2;
       wa  = 2;
       wd  = 6;
       $display("Expect rd=%h", 3);
       $display("Actual rd=%h", rd);

   end 
    
   always 
     #5  clk =  ! clk; 
    
endmodule 