`timescale 1ns / 1ps

module compression(
    input clk,
    input rst,
    input enable,
    input [1:0] mode,
    input [11:0] x,
    input [11:0] y,
    //
    input [7:0] data_in,  //параметр
    output [7:0] output_byte
    //
);

//////////////////////////////////////////////////////////
reg [h_bit - 1:0] [v_bit - 1:0] rgb_array [23:0];

RAM_block RAM_block(
    .clock(clk),  //следует уточнить частоты
    .data_in(data_in),
    
);

//////////////////////////////////////////////////////////
always @(posedge clk) begin
    if (enable) begin
        if 
    end
end

endmodule