module RF(A1, A2, A3, WD, RFWr, clk, RD1, RD2, RFtoBranch);
  input [4:0]A1;
  input [4:0]A2;
  input [4:0]A3;
  input [31:0]WD;
  input RFWr;
  input clk;
  output reg [31:0]RD1;
  output reg [31:0]RD2;
  output reg RFtoBranch;
  
  reg[5:0] i;
  
  reg [31:0] data[31:0];
  initial
  begin
    RFtoBranch = 0;
    for (i=0;i<32;i=i+1)
      data[i]=32'b0;
    data[28]=32'h00001800;
    data[29]=32'h00002ffe;
  end 
  
  always @(A1 or A2 or data[A1] or data[A2])
  begin
    RD1<=data[A1];
    RD2<=data[A2];
  end
  
  always @(posedge clk)
  begin
  #1
  if (RFWr&&A3!=0)
    data[A3]=WD;
  RFtoBranch = ~RFtoBranch;
  end
endmodule
