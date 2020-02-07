`timescale 1ns / 1ps

module compression(
    input clk,
    input rst,
    input enable_broadcast_from_mem,
    input enable_writing_in_mem,
    input [1:0] mode,
    input [11:0] x,
    input [11:0] y,
    //
    input [7:0] data_in,  //параметр
    output [Address_cell_width - 1:0] output_byte,
    output busy
    //
);

//////////////////////////////////////////////////////////
reg [h_bit - 1:0] [v_bit - 1:0] rgb_array [23:0];
wire [Address_cell_width - 1:0] Data_out;
reg busy_signal;
//////////////////////////////////////////////////////////
assign output_byte = Data_out;
assign busy = busy_signal;
//////////////////////////////////////////////////////////
RAM_block RAM_block(
    .clock(clk),  //следует уточнить частоты
    .data_in(data_in),
    .active_pix(x),
    .active_lin(y),
    .enable_broadcast_from_mem(enable_broadcast_from_mem),
    .enable_writing_in_mem(enable_writing_in_mem),	
    .trigger_of_overflow(trigger_of_overflow),		
    .Data_out(Data_out)    			
);

//////////////////////////////////////////////////////////
always @(posedge trigger_of_overflow) begin
        busy_signal <= 1'b1;

    end
end

endmodule