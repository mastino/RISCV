// Brian Gravelle
// CIS 510 Complex Digital Design
// RISCV processor 
// Memory
// NOTE: LITTLE ENDIAN, do not change DATA WIDTH

module Memory #(parameter ADDR_WIDTH  = 32) 
                    (clk, rst, re, we, ra, wa, wd, rs, ws, rd);

    localparam DATA_WIDTH = 32;

    output reg [DATA_WIDTH-1:0] rd;
    input [DATA_WIDTH-1:0] wd;
    input [ADDR_WIDTH-1:0] ra, wa;
    input clk, rst, re, we, rs, ws;

    //Byte addressed; does non-aligned
    // reg [7:0] mem [(1<<ADDR_WIDTH)-1:0];

    // always @ (*)
    // begin
    //   if(rst) begin
    //     //rd <= 32'h00000000;  
    //     rd <= 0;  
    //   end else begin
    //     if(re & rs) begin
    //       rd <= ( (ra == wa) & we) ? wd : {16'h0000, mem[ra], mem[ra+1]};
    //     end else if(re) begin
    //       //rd <= ( (ra == wa) & we) ? wd : {mem[ra], mem[ra], mem[ra], mem[ra]};
    //       rd <= ( (ra == wa) & we) ? wd : {mem[ra], mem[ra+1], mem[ra+2], mem[ra+3]};
    //     end else begin
    //       rd <= 32'h00000000;
    //     end

    //     if(we & ws) begin
    //       mem[wa]   <= wd[15:8];
    //       mem[wa+1] <= wd[7:0]; 
    //     end else if (we) begin
    //       mem[wa]   <= wd[31:24];
    //       mem[wa+1] <= wd[23:16];
    //       mem[wa+2] <= wd[15:8];
    //       mem[wa+3] <= wd[7:0];  
    //     end 
    //   end

    //aligned to half or word
    reg [DATA_WIDTH-1:0] mem [(1<<(ADDR_WIDTH-2))-1:0];

    always @ (*)
    begin
      if(rst) begin 
        rd <= 0;  
      end else begin
        if(re & rs) begin
          rd <= ( (ra == wa) & we) ? wd : 
                (ra[1]) ? {16'h0000, mem[ra[ADDR_WIDTH-1:2]][15:0]} : {16'h0000, mem[ra[ADDR_WIDTH-1:2]][31:16]} ;
        end else if(re) begin
          rd <= ( (ra == wa) & we) ? wd : mem[ra[ADDR_WIDTH-1:2]];
        end else begin
          rd <= 32'h00000000;
        end

        if(we & ws) begin
          mem[wa[ADDR_WIDTH-1:2]] <= (wa[1]) ? {mem[ra[ADDR_WIDTH-1:2]][31:16], wd[15:0]} : {wd[15:0], mem[ra[ADDR_WIDTH-1:2]][15:0]};
        end else if (we) begin
          mem[wa[ADDR_WIDTH-1:2]] <= wd; 
        end 
      end
    end
   
endmodule

module tb_Memory; 
   parameter addr_bits  = 16;
   parameter data_width = 32;

   wire [data_width-1:0] rd;
   reg  [data_width-1:0] wd;
   reg  [addr_bits-1:0]  ra, wa;
   reg  clk, rst, we, re, rs, ws;

   Memory #(.ADDR_WIDTH(addr_bits)) foam ( 
     .clk (clk), 
     .rst (rst), 
     .we  (we),
     .re  (re),
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
        ws  = 1'b0;
        rs  = 1'b0;
   #5   rst = 0; 
        we  = 0;
        re  = 0;
        ra  = 0;
        wa  = 0;
        wd  = 1;
   #10  rst = 1; // reset
        we  = 0;
        re  = 0;
        ra  = 0;
        wa  = 0;
        wd  = 1;
   #10  $display("Expect rd=%h", 0);
        $display("Actual rd=%h", rd);
        $display(" ");
        rst = 0;
        we  = 1;
        re  = 0;
        ra  = 4;
        wa  = 0;
        wd  = 5;
   #10  $display("Expect rd=%h", 0);
        $display("Actual rd=%h", rd);
        $display(" ");
        we  = 0;
        re  = 1;
        ra  = 0;
        wa  = 4;
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
        ra  = 4;
        wa  = 4;
        wd  = 1;
   #10  $display("Expect rd=%h", 1);
        $display("Actual rd=%h", rd);
        $display(" ");
        we  = 1;
        ra  = 4;
        wa  = 32'h1234;
        wd  = 2;
   #10  $display("Expect rd=%h", 1);
        $display("Actual rd=%h", rd);
        $display(" ");
        we  = 1;
        ra  = 32'h1234;
        wa  = 8;
        wd  = 3;
   #10  $display("Expect rd=%h", 2);
        $display("Actual rd=%h", rd);
        $display(" ");
        we  = 0;
        ra  = 8;
        wa  = 8;
        wd  = 6;
   #10  $display("Expect rd=%h", 3);
        $display("Actual rd=%h", rd);
        $display(" ");

   end 
    
   always 
     #5  clk =  ! clk; 
    
endmodule 