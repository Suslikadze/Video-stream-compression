`timescale 1ns / 1ps

module Recoding(
input clk_old,
input clk_new,
input enable,
input newframe,
input newline,
input [`address_cell_width - 1 : 0] data_in_pix, 
output [`address_cell_width - 1 : 0] data_out,
output [`bit_new_pix - 1 : 0] new_x,
output [`bit_new_line - 1 : 0] new_y,
output enable_next
);

//////////////////////////////////////////////////////////
wire [1:0][`address_cell_width - 1 : 0] pix_shift_register <= (others => '0');
wire [2:0][`address_cell_width - 1 : 0] first_pix_FIFO <= (others => '0');
wire [`address_cell_width - 1: 0] new_data_pix;
wire [`five_lines_address_buffer - 1 : 0][`address_cell_width - 1 : 0] pix_intermediate_RAM;
integer number_of_lines_new = 2 * `number_of_lines;
integer counter = 0;
reg enable_for_lines <= '0';
//////////////////////////////////////////////////////////
//Модуль vhdl RAM для динамичного прохода записи и чтения строк, передаем сначала две строки 
//для первой операции, потом пять строк
first_operation RAM_block(
    .clock(clk_old),
    .clk
    .data_
);
//////////////////////////////////////////////////////////
//Сдвиговый регист FIFO для удвоения пикселей
always @(posedge clk_old) begin
    if (enable) begin
       pix_shift_register[0] <= data_in_pix;
       pix_shift_register = pix_shift_register << 1;
    end
end
//////////////////////////////////////////////////////////
//Первая операция
always @(posedge clk_old) begin
    if (enable) begin
        first_pix_FIFO[0] <= data_in_pix;
        first_pix_FIFO[1] <= (pix_shift_register[0] + pix_shift_register[1]) / 2;
        first_pix_FIFO = first_pix_FIFO << 1;          
    end      
end
//////////////////////////////////////////////////////////
//Вторая операция и передача конечного пикселя (в строке) во временную RAM
//Временная память для модифицирования строк будет длиной в одну строку - тоже FIFO
//Нет, пять строк??? ПОнять, что будет в конце, как по строкам, так и по пикселям
always @(posedge clk_old) begin
    if (enable) begin
        new_data_pix <= (first_pix_FIFO[0] + first_pix_FIFO[1] + first_pix_FIFO[2]) / 3; //Ненужная переменная, убрать
        pix_intermediate_RAM <= new_data_pix;
        pix_intermediate_RAM = pix_intermediate_RAM << 1;
    end
end
//////////////////////////////////////////////////////////
always @(posedge newline) begin
    if (counter_for_lines < `number_of_lines) begin
        counter_for_lines <= counter_for_lines + 1;
    end else begin
        counter_for_lines <= 0;//?????
end
//////////////////////////////////////////////////////////
// Ждем, пока буфер для строки не заполнится до конца
always @(posedge туц) begin
    if (enable) begin
        if (counter < `number_of_lines) begin
            counter <= counter + 1;
        end else begin
            enable_for_lines <= '1';
            counter <= 0; 
        end
    end        
end
//////////////////////////////////////////////////////////
always @(posedge clk_old) begin
    if (enable_for_lines) begin
        
    end
end
endmodule