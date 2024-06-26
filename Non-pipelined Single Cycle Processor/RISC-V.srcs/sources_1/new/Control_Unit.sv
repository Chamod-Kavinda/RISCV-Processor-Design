`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2023 11:58:51 PM
// Design Name: 
// Module Name: Control_Unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Control_Unit(
    input logic [31:0] instruction,
    output logic [3:0] operation,
    output logic wrt_en,
    output logic jump,
    output logic sel_ALUsrc,
    output logic MemRead,
    output logic MemWrt,
    output logic sel_wrtdata,
    output logic [2:0] mem_type,
    output logic branch,
    output logic [1:0] branch_type
    );


    logic [15:0] ROM [40:0];

    assign ROM[0]=16'b0000100000000000; //ADD
    assign ROM[1]=16'b0001100000000000; //SUB
    assign ROM[2]=16'b0101100000000000; //SLL
    assign ROM[3]=16'b1000100000000000; //SLT
    assign ROM[4]=16'b1001100000000000; //SLTU
    assign ROM[5]=16'b0100100000000000; //XOR
    assign ROM[6]=16'b0110100000000000; //SRL
    assign ROM[7]=16'b0111100000000000; //SRA
    assign ROM[8]=16'b0011100000000000; //OR
    assign ROM[9]=16'b0010100000000000; //AND

    assign ROM[10]=16'b0000101000000000; //ADDI
    assign ROM[11]=16'b1000101000000000; //SLTI
    assign ROM[12]=16'b1001101000000000; //SLIU
    assign ROM[13]=16'b0100101000000000; //XORI
    assign ROM[14]=16'b0011101000000000; //ORI
    assign ROM[15]=16'b0010101000000000; //ANDI
    assign ROM[16]=16'b0101101000000000; //SLLI
    assign ROM[17]=16'b0110101000000000; //SRLI
    assign ROM[18]=16'b0111101000000000; //SRAI

    assign ROM[19]=16'b0000101101000000; //LB
    assign ROM[20]=16'b0000101101001000; //LH
    assign ROM[21]=16'b0000101101010000; //LW
    assign ROM[22]=16'b0000101101100000; //LBU
    assign ROM[23]=16'b0000101101101000; //LHU

    assign ROM[24]=16'b0000001010000000; //SB
    assign ROM[25]=16'b0000001010001000; //SH
    assign ROM[26]=16'b0000001010010000; //SW

    assign ROM[27]=16'b0001000000000100; //BEQ
    assign ROM[28]=16'b0001000000000101; //BNE
    assign ROM[29]=16'b1000000000000110; //BLT
    assign ROM[30]=16'b1000000000000111; //BGE
    assign ROM[31]=16'b1001000000000110; //BLTU
    assign ROM[32]=16'b1001000000000111; //BGEU

    assign ROM[33]=16'b0000111000000000; //JALR
    assign ROM[34]=16'b1010100000000000; //MUL

    logic [15:0] control_output;
    logic [8:0] control1;
    logic [7:0] control2;
    logic control_sel;

    assign control_sel = (instruction[6:2] == 5'b01100) ||
                         (instruction[6:2] == 5'b00100 && (instruction[14:12] == 3'b101 || instruction[14:12] == 3'b001));
                            
    always_comb 
    begin
        if(control_sel)
        begin
            control1<={instruction[30],instruction[14:12],instruction[6:2]};
            case(control1)
                9'b000001100: control_output<=ROM[0];
                9'b100001100: control_output<=ROM[1];
                9'b000101100: control_output<=ROM[2];
                9'b001001100: control_output<=ROM[3];
                9'b001101100: control_output<=ROM[4];
                9'b010001100: control_output<=ROM[5];
                9'b010101100: control_output<=ROM[6];
                9'b110101100: control_output<=ROM[7];
                9'b011001100: control_output<=ROM[8];
                9'b011101100: control_output<=ROM[9];
                9'b000100100: control_output<=ROM[16];
                9'b010100100: control_output<=ROM[17];
                9'b110100100: control_output<=ROM[18];
                9'b100101100: control_output<=ROM[34];

            endcase
        end
    end
                                   
    always_comb 
    begin
        if(!control_sel)
        begin
            control2<={instruction[14:12],instruction[6:2]};
            case(control2) 
                8'b00000100: control_output<=ROM[10];
                8'b01000100: control_output<=ROM[11];
                8'b01100100: control_output<=ROM[12];
                8'b10000100: control_output<=ROM[13];
                8'b11000100: control_output<=ROM[14];
                8'b11100100: control_output<=ROM[15]; 
                8'b00000000: control_output<=ROM[19];
                8'b00100000: control_output<=ROM[20];
                8'b01000000: control_output<=ROM[21];
                8'b10000000: control_output<=ROM[22];
                8'b10100000: control_output<=ROM[23];
                8'b00001000: control_output<=ROM[24];
                8'b00101000: control_output<=ROM[25];
                8'b01001000: control_output<=ROM[26];
                8'b00011000: control_output<=ROM[27];
                8'b00111000: control_output<=ROM[28];
                8'b10011000: control_output<=ROM[29];
                8'b10111000: control_output<=ROM[30];
                8'b11011000: control_output<=ROM[31];
                8'b11111000: control_output<=ROM[32];
                8'b00011001: control_output<=ROM[33];
            endcase
        end
    end

    assign operation = control_output[15:12];
    assign wrt_en = control_output[11];
    assign jump = control_output[10];
    assign sel_ALUsrc = control_output[9];
    assign MemRead = control_output[8];
    assign MemWrt = control_output[7];
    assign sel_wrtdata = control_output[6];
    assign mem_type = control_output[5:3];
    assign branch = control_output[2];
    assign branch_type = control_output[1:0];
 
endmodule
