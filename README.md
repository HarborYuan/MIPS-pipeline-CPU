# MIPS-pipeline-CPU
## Introduction
This is a MIPS five-stage pipeline CPU simulation code. Currently supports 42 instructions.
## Instructions
MIPS-C2＝{LB、LBU、LH、LHU、LW、SB、SH、SW、ADD、ADDU、SUB、SUBU、SLL、SRL、SRA、SLLV、SRLV、SRAV、AND、OR、XOR、NOR、SLT、SLTU、ADDI、ADDIU、ANDI、ORI、XORI、LUI、SLTI、SLTIU、BEQ、BNE、BLEZ、BGTZ、BLTZ、BGEZ、J、JAL、JALR、JR}
## Details
Data hazard, control hazard and bypass are supported. But in order to simplify this problem, it predicts all of the branch statements happening.
## Installation
You can use any software that can understand verilog. I recommend using Modelsim to emulate this code. Create a new project, add all the .v files in the src folder and simulate mips_tb.v.<br>
If you want to try to write your own assembler to test this code, the use of Mars is a good choice.<br>
If you want to compile your c code, try codescape to bulid your cross-compiler environment.
## License
MIT License