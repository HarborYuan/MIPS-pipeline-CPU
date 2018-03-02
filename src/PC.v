module PCUnit(in,PC,clk,sig,NEXflush,start,NEXflush_2);
    output reg [31:0] PC;
    input [31:0] in;
    input clk;
    input sig;
    input NEXflush;
    input NEXflush_2;
    input start;

    initial
    begin
        PC = 32'h0000_3000;
        $display("PC: %h",PC);
    end
    always@(negedge clk)
	begin
		if (sig)
            begin
                PC = in;
                $display("PC: %h",PC);
            end
	end
    always @(negedge NEXflush)
    begin
        if (start==1)
            PC = PC - 4;
    end
    always @(negedge NEXflush_2)
    begin 
        if (start==1)
            PC = PC - 8;
    end
endmodule