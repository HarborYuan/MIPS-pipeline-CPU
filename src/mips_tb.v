module mips_tb();
    `timescale  1ns/1ps
    reg clk;
    reg rst;
    reg start;
    initial
    begin
        clk=1;
        start = 0;
        #2
        start =1;
    end
    always
    begin
        #20 clk<=~clk;
    end
    mips my_mips(clk,rst,start);
endmodule
