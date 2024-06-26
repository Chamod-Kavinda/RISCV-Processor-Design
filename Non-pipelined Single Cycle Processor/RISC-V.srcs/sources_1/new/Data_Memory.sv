`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 11:56:23 AM
// Design Name: 
// Module Name: Data_Memory
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


module Data_Memory#(addr_width=9)(
    input logic clk,
    input logic [31:0] Mem_addr,
    input logic signed [31:0] Wrt_data,
    input logic MemWrt,
    input logic MemRead,
    input logic [2:0] mem_type,
    output logic signed [31:0] Read_data
    );

logic signed [31:0] memory [((2**addr_width)-1):0];

    always_comb 
    begin
        if(MemRead) 
        begin
            case(mem_type)
                //lb (000)
                3'b000: Read_data <= {memory[Mem_addr][7]? {24{1'b1}}:24'b0,memory[Mem_addr][7:0]};
                //lbu (100)
                3'b100: Read_data <= {24'b0,memory[Mem_addr][7:0]};
                //lh (001)
                3'b001: Read_data <= {memory[Mem_addr][15]? {16{1'b1}}:16'b0,memory[Mem_addr][15:0]};
                //lhu (101)
                3'b101: Read_data <= {16'b0,memory[Mem_addr][15:0]};
                //lw  (010)
                3'b010: Read_data <= memory[Mem_addr];
            endcase
        end
    end

    always_ff @(posedge clk) 
    begin
        if(MemWrt)
        begin
            case(mem_type) 
                3'b000:memory[Mem_addr] <= {24'b0,Wrt_data[7:0]};
                3'b001:memory[Mem_addr] <= {16'b0,Wrt_data[15:0]};
                3'b010:memory[Mem_addr] <= Wrt_data[31:0];
            endcase
        end
    end
endmodule
