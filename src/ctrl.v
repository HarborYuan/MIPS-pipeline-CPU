`include "./alu_def.v"
module ctrl(ID_ins, EX_ins, MEM_ins, WB_ins,
ALUOp, PCSrc, ALUASrc, ALUBSrc, WBdSrc, WBaSrc, DMWr, RFWr,
clk,RD1,RD2,IDflush,forward1,forward2,EXflush,EXflush_2,
RFtoBranch);
    input [31:0] ID_ins;
    input [31:0] EX_ins;
    input [31:0] MEM_ins;
    input [31:0] WB_ins;
    input clk;
    input RFtoBranch;
    output reg [3:0] ALUOp;
    output reg [1:0] PCSrc;
    output reg [1:0] ALUASrc;
    output reg [1:0] ALUBSrc;
    output reg [1:0] WBaSrc;
    output reg [1:0] WBdSrc;
    output reg DMWr;
    output reg RFWr;
    input [31:0] RD1;
    input [31:0] RD2;

    output reg IDflush;
    output reg EXflush;
    output reg EXflush_2;
    output reg [1:0]forward1;
    output reg [1:0]forward2;

    reg [4:0] MEM_des;
    reg [4:0] WB_des;
    reg [4:0] EX_des;

    initial
    begin
        ALUOp <= `ALU_NOP;
        PCSrc <= 0;
        ALUASrc <= 0;
        ALUBSrc <= 0;
        WBaSrc <= 0;
        WBdSrc <= 0;
        DMWr <=0;
        RFWr <= 0;
        IDflush <= 0;
        EXflush <= 0;
    end
/*
    always @(posedge clk)
    begin
        case (ID_ins[31:26])
            6'h1,6'h4,6'h5,6'h6,6'h7:  
                begin
                    PCSrc = 0;
                end
            default:
                begin
                    PCSrc = 0;
                end
        endcase
    end
*/
    always @(posedge clk)
    begin
        case (EX_ins[31:26])
            6'h00:  
                begin
                        case (EX_ins[5:0])
                            6'h0,6'h2,6'h3:
                                begin
                                    ALUASrc <= 1;
                                    ALUBSrc <= 0;
                                end
                            default:
                                begin
                                    ALUASrc <=0;
                                    ALUBSrc <=0;
                                end
                        endcase
                        case (EX_ins[5:0])
                            6'h20,6'h8,6'h9:ALUOp <= `ALU_ADD;
                            6'h21:ALUOp <= `ALU_ADD;
                            6'h22:ALUOp <= `ALU_SUB;
                            6'h23:ALUOp <= `ALU_SUB;
                            6'h0 :ALUOp <= `ALU_SLL;
                            6'h2 :ALUOp <= `ALU_SRL;
                            6'h3 :ALUOp <= `ALU_SRA;
                            6'h4 :ALUOp <= `ALU_SLL;
                            6'h6 :ALUOp <= `ALU_SRL;
                            6'h7 :ALUOp <= `ALU_SRA;
                            6'h24:ALUOp <= `ALU_AND;
                            6'h25:ALUOp <= `ALU_OR;
                            6'h26:ALUOp <= `ALU_XOR;
                            6'h27:ALUOp <= `ALU_NOR;
                            6'h2a:ALUOp <= `ALU_SLT;
                            6'h2b:ALUOp <= `ALU_SLTU;
                            default:ALUOp <= `ALU_NOP;
                        endcase
                 end
            6'h8, 6'h9, 6'ha, 6'hb, 6'hc, 6'hd, 6'he, 6'hf, 6'h20,
            6'h21, 6'h23, 6'h24, 6'h25, 6'h28, 6'h29, 6'h2b:
                begin
                    case (EX_ins[31:26])
                        6'hc, 6'hd, 6'he, 6'hb:
                            begin
                                ALUASrc <= 0;
                                ALUBSrc <= 2;
                            end
                        default:
                            begin
                                ALUASrc <= 0;
                                ALUBSrc <= 1;
                            end
                    endcase
                    case(EX_ins[31:26])
                        6'h8:ALUOp <= `ALU_ADD;
                        6'h9:ALUOp <= `ALU_ADD;
                        6'hc:ALUOp <= `ALU_AND;
                        6'hd:ALUOp <= `ALU_OR;
                        6'he:ALUOp <= `ALU_XOR;
                        6'hf:ALUOp <= `ALU_LUI;
                        6'ha:ALUOp <= `ALU_SLT;
                        6'hb:ALUOp <= `ALU_SLTU;
                        default: ALUOp <= `ALU_ADD;
                    endcase
                end
        endcase
    end

    always @(posedge clk)
    begin
        case (MEM_ins[31:26])
            6'h28, 6'h29, 6'h2b:  
                begin
                    DMWr <= 1;
                end
            default:
                begin
                    DMWr <= 0;
                end
        endcase
    end

    always @(posedge clk)
    begin
        case (WB_ins[31:26])
            6'h0: 
                begin
                    if (WB_ins[5:0]==6'h8)
                        RFWr <= 0;
                    else
                        RFWr <= 1;
                end
            6'h8, 6'h9, 6'ha, 6'hb, 6'hc, 6'hd, 6'he, 6'hf, 
            6'h20, 6'h21, 6'h23, 6'h24, 6'h25, 6'h3:
                begin
                   RFWr <= 1;
                end
            default:
                begin
                    RFWr <= 0;
                end
        endcase
        case (WB_ins[31:26])
            6'h0: 
                begin
                    if (WB_ins[5:0]==6'h9)
                        begin
                            WBaSrc <= 0;
                            WBdSrc <= 2;
                        end
                    else
                        begin
                            WBaSrc <= 0;
                            WBdSrc <= 1;
                        end
                end
            6'h8, 6'h9, 6'ha, 6'hb, 6'hc, 6'hd, 6'he, 6'hf:
                begin
                    WBaSrc <= 1;
                    WBdSrc <= 1;
                end
            6'h20, 6'h21, 6'h23, 6'h24, 6'h25:
                begin
                    WBaSrc <= 1;
                    WBdSrc <= 0;
                end
            6'h3:
                begin
                    WBaSrc <= 2;
                    WBdSrc <= 2;
                end
            // no use
            default:
                begin
                    WBaSrc <= 0;
                    WBdSrc <= 1;
                end
        endcase
    end


    always @(posedge clk)
    begin
        EX_des = 5'b0;
        case (EX_ins[31:26])
            6'h0: 
                begin
                    if (EX_ins[5:0]!=6'h8)
                        EX_des = MEM_ins[15:11];
                    else
                        EX_des = 5'b0;
                end
            6'h8, 6'h9, 6'ha, 6'hb, 6'hc, 6'hd, 6'he, 6'hf, 
            6'h20, 6'h21, 6'h23, 6'h24, 6'h25:
                begin
                   EX_des = EX_ins[20:16];
                end
        endcase
        MEM_des = 5'b0;
        case (MEM_ins[31:26])
            6'h0: 
                begin
                    if (MEM_ins[5:0]!=6'h8)
                        MEM_des = MEM_ins[15:11];
                    else
                        MEM_des = 5'b0;
                end
            6'h8, 6'h9, 6'ha, 6'hb, 6'hc, 6'hd, 6'he, 6'hf, 
            6'h20, 6'h21, 6'h23, 6'h24, 6'h25:
                begin
                   MEM_des = MEM_ins[20:16];
                end
        endcase
        WB_des = 5'b0;
        forward1 = 2'b00;
        forward2 = 2'b00;
        case (WB_ins[31:26])
            6'h0: 
                begin
                    if (WB_ins[5:0]!=6'h8)
                        WB_des = WB_ins[15:11];
                    else
                        WB_des = 5'b0;
                end
            6'h8, 6'h9, 6'ha, 6'hb, 6'hc, 6'hd, 6'he, 6'hf, 
            6'h20, 6'h21, 6'h23, 6'h24, 6'h25:
                begin
                   WB_des = WB_ins[20:16];
                end
        endcase
        if (EX_ins[25:21] == WB_des && WB_des!=0)
        begin
            forward1 = 2'b11;
        end
        if (EX_ins[20:16] == WB_des && WB_des!=0)
        begin
            forward2 = 2'b11;
        end

        if (WB_ins[31:26]==6'h20 || WB_ins[31:26]==6'h21 
        || WB_ins[31:26]==6'h23 || WB_ins[31:26]==6'h24 || WB_ins[31:26]==6'h25)
        begin
            if (EX_ins[25:21] == WB_des && WB_des!=0)
            begin
                forward1 = 2'b10;
            end
            if (EX_ins[20:16] == WB_des && WB_des!=0)
            begin
                forward2 = 2'b10;
            end
        end
        if (EX_ins[25:21] == MEM_des && MEM_des!=0)
        begin
            forward1 = 2'b01;
        end
        if (EX_ins[20:16] == MEM_des && MEM_des!=0)
        begin
            forward2 = 2'b01;
        end

        if (ID_ins[31:26] == 6'h0 &&(ID_ins[5:0] == 6'h8 || ID_ins[5:0] == 6'h9))
        begin
            if (ID_ins[25:21] == EX_des)
            begin
                #2
                EXflush_2 = 1;
                PCSrc = 0;
            end
            else if (ID_ins[25:21] == MEM_des)
            begin
                #2
                EXflush = 1;
                PCSrc = 0;
            end
        end
    end

    always @(posedge clk)
    begin
        EXflush = 0;
        EXflush_2 = 0;
        if (EX_ins[31:26]==6'h20 || EX_ins[31:26]==6'h21 
        || EX_ins[31:26]==6'h23 || EX_ins[31:26]==6'h24 || EX_ins[31:26]==6'h25)
        begin
            case (ID_ins[31:26])
                6'h28,6'h29,6'h2b:
                    begin
                        if(ID_ins[25:21]==EX_ins[20:16] && EX_ins[20:16]!=0)
                            begin
                                EXflush = 1;
                            end
                        if(ID_ins[20:16]==EX_ins[20:16] && EX_ins[20:16]!=0)
                            begin
                                EXflush_2 = 1;
                            end
                    end
                6'h8,6'h9,6'ha,6'hb,6'hc,6'hd,6'he,6'hf:
                    begin
                        if(ID_ins[25:21]==EX_ins[20:16] && EX_ins[20:16]!=0)
                            begin
                                EXflush = 1;
                            end
                    end
                6'h0:
                    begin
                        if (ID_ins[5:0]!=6'h8 && ID_ins[5:0]!=6'h9)
                            begin
                                if((ID_ins[25:21]==EX_ins[20:16]||ID_ins[20:16]==EX_ins[20:16])&&EX_ins[20:16]!=0)
                                    begin
                                        EXflush = 1;
                                    end
                            end 
                    end
            endcase
        end
    end

    always@(RFtoBranch)
    begin 
        IDflush = 0;
        case (ID_ins[31:26])
            6'h0:
                begin
                    if (ID_ins[5:0] == 6'h8 || ID_ins[5:0] == 6'h9 )
                        begin
                            PCSrc = 2;
                            IDflush = 1;
                        end
                    else
                        begin
                            PCSrc = 0;
                        end
                end
            6'h1:
                begin
                    if (ID_ins[20:16]==1)
                        begin
                            if ($signed(RD1)>=0)
                                begin
                                    PCSrc = 1;
                                    IDflush = 1;
                                end
                            else
                                begin
                                    PCSrc = 0;
                                end
                        end
                    else
                        begin
                            if ($signed(RD1)<0)
                                begin
                                    PCSrc = 1;
                                    IDflush = 1;
                                end
                            else
                                begin
                                    PCSrc = 0;
                                end
                        end
                end
            6'h4:
                begin
                    if (RD1 == RD2)
                        begin
                            PCSrc = 1;
                            IDflush = 1;
                        end
                    else
                        begin
                            PCSrc = 0;
                        end
                end
            6'h5:
                begin
                    if (RD1 != RD2)
                        begin
                            PCSrc = 1;
                            IDflush = 1;
                        end
                    else
                        begin
                            PCSrc = 0;
                        end
                end
            6'h6: 
                begin
                    if ($signed(RD1) <= 0)
                        begin
                            PCSrc = 1;
                            IDflush = 1;
                        end
                    else
                        begin
                            PCSrc = 0;
                        end
                end
            6'h7:  
                begin
                    if ($signed(RD1) > 0)
                        begin
                            PCSrc = 1;
                            IDflush = 1;
                        end
                    else
                        begin
                            PCSrc = 0;
                        end
                end
            6'h2,6'h3:
                begin
                    PCSrc =3;
                    IDflush =1;
                end

            default:
                begin
                    PCSrc = 0;
                end
        endcase
    end
endmodule