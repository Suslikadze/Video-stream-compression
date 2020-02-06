Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Блок RAM, версия для одной шины данных. Присутствует два en - для записи данных в память и для чтения в память. 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------



entity RAM_block is
Generic(
	bit_pix								: integer := 12;		--бит на счетчик пикселей
	bit_strok							: integer := 12;		--бит на счетчик строк
	Address_cell_width					: integer := 10;		--разрядность одной ячейки памяти
	Address_width						: integer := 20			--разрядность числа ячеек памяти
	);

Port(
    clock								: IN STD_LOGIC;
    data_in                             : IN std_logic_vector(Address_cell_width - 1 downto 0);
	active_pix							: IN std_logic_vector(bit_pix - 1 downto 0);
	active_lin							: IN std_logic_vector(bit_strok - 1 downto 0);
	enable_broadcast_from_mem			: IN STD_LOGIC;
	enable_writing_in_mem				: IN std_logic;
	trigger_of_overflow					: OUT std_logic;
	Data_out    						: OUT std_logic_vector(Address_cell_width - 1 downto 0)						
);

end RAM_block;
architecture behavioral of RAM_block is
-------------------------------------------------------------------------
component count_n_modul
generic (n		: integer);
port (
		clk,
		reset,
		en			:	in std_logic;
		modul		: 	in std_logic_vector (n-1 downto 0);
		qout		: 	out std_logic_vector (n-1 downto 0);
		cout		:	out std_logic);
end component;
-------------------------------------------------------------------------
signal rdaddress, wraddress			: std_logic_vector(Address_width - 1 downto 0) := (others => '0');
signal data_in_cell     			: std_logic_vector(Address_cell_width-1 downto 0);
signal Number_of_addr_cells			: std_logic_vector(Address_width - 1 downto 0);

TYPE mem_type IS ARRAY(0 to 2**Address_width) OF std_logic_vector((Address_cell_width-1) DOWNTO 0);
signal RAM	 		: mem_type;

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
Begin
Number_of_addr_cells <= std_logic_vector(to_unsigned(to_integer(signed(active_pix)) * to_integer(signed(active_lin)), Address_width));		
-------------------------------------------------------------------------
Process(clock)
Begin
If rising_edge(clock) then
    If (enable_writing_in_mem = '1') then
        RAM(to_integer(unsigned(wraddress))) <= data_in;	

    end if;
	if (enable_broadcast_from_mem = '1') then
		data_in_cell <= RAM(to_integer(unsigned(rdaddress)));	
		Data_out <= data_in_cell;
	end if;
end if;
end process;
-------------------------------------------------------------------------	
-------------------------------------------------------------------------
Count_mem_write	: count_n_modul
	Generic map (Address_width)
	port map(
		clk			=>  clock,
		reset		=>	'0' ,
		en			=>	enable_writing_in_mem,
		modul		=>  Number_of_addr_cells, 
		qout		=>  wraddress,
		cout		=>	trigger_of_overflow
		);
-------------------------------------------------------------------------	
-------------------------------------------------------------------------
Count_mem_read	: count_n_modul
	Generic map (Address_width)
	port map(
		clk			=>  clock,
		reset		=>	'0' ,
		en			=>	enable_broadcast_from_mem,
		modul		=>  Number_of_addr_cells, 
		qout		=>  rdaddress
		);
-------------------------------------------------------------------------	

end behavioral;