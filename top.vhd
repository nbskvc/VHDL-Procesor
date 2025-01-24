library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


library work;

entity top is
	generic(
		-- Default frequency used in synthesis.
		constant CLK_FREQ         : positive := 12000000;
		constant CNT_BITS_COMPENS : integer  := 0
	);
    port (
        clk  : in  std_logic; 
        rst  : in  std_logic;
		  --i_data : in std_logic_vector(15 downto 0);
		  i_run : in std_logic;
		  
			--max1000
			i_sw : in std_logic_vector(7 downto 0);
			
			o_mux_row_or_digit         : out std_logic_vector(2 downto 0);
					
			o_mux_sel_color_or_7segm   : out std_logic_vector(1 downto 0);		

			-- RGB 8x8 LED matrix and 7-segm outputs.
			o_n_col_0_or_7segm_a       : out std_logic;
			o_n_col_1_or_7segm_b       : out std_logic;
			o_n_col_2_or_7segm_c       : out std_logic;
			o_n_col_3_or_7segm_d       : out std_logic;
			o_n_col_4_or_7segm_e       : out std_logic;
			o_n_col_5_or_7segm_f       : out std_logic;
			o_n_col_6_or_7segm_g       : out std_logic;
			o_n_col_7_or_7segm_dp      : out std_logic
		
    );
end entity top;

architecture Behavioral of top is
	signal s_address : std_logic_vector(15 downto 0);
	signal s_inst : std_logic_vector(9 downto 0);
	signal s_bus : std_logic_vector(15 downto 0);
	signal s_data : std_logic_vector(15 downto 0);
	--max1000
	signal segm_afbgecd : std_logic_vector(6 downto 0);
	signal mux_sel_color_or_7segm : std_logic_vector(1 downto 0);
	signal mux_color_or_7segm : std_logic_vector(7 downto 0);
	signal mux_row_or_digit : std_logic_vector(2 downto 0);
	signal segm_dp : std_logic;
	signal segm : std_logic_vector(7 downto 0);
	signal n_mux_color_or_7segm : std_logic_vector(7 downto 0);
	--brojaci
	signal s_cnt : std_logic_vector(13 downto 0);
--	signal s_cnt : std_logic_vector(4 downto 0); --sim
	--digit
	signal digit_1 : std_logic_vector(3 downto 0);
	signal digit_2 : std_logic_vector(3 downto 0);
	signal digit_3 : std_logic_vector(3 downto 0);
	signal digit_4 : std_logic_vector(3 downto 0);
	signal digit : std_logic_vector(3 downto 0);
	signal sreg : std_logic_vector(15 downto 0);
	--
	signal s_reg_sel :  std_logic_vector(2 downto 0);
	signal s_g_sel : std_logic;
	signal s_data_sel : std_logic;
begin
mem: entity work.memory
port map(
	clock => clk,
	data => (others => '0'),
	wren => '0',
	q => s_inst,
	address => s_address
);
processor: entity work.lprs_processor
port map(
	clk => clk,        
  rst => rst,          
  i_inst => s_inst,
  i_run => i_run,
  i_data => s_data,
  o_bus => s_bus,
  o_pc => s_address,
  o_reg_1 => sreg,
  o_reg_sel => s_reg_sel,
  o_data_sel => s_data_sel,
  o_g_sel => s_g_sel
);

select_digit: entity work.counter
	generic map(
		module => CLK_FREQ/1000,
		bits => 14
	)
	port map(
		clk => clk,
		rst => rst,
		ocnt => s_cnt
	);
	
--s_data(7 downto 0) <= i_sw;
--s_data(15 downto 8) <= i_sw;

s_data <= x"0003";

digit_1 <= sreg(3 downto 0);
digit_2 <= sreg(7 downto 4); 
digit_3 <= sreg(11 downto 8);
digit_4 <= sreg(15 downto 12);


digit <= digit_1  when mux_row_or_digit = "000" else
			digit_2 when mux_row_or_digit = "001" else
			digit_3 when mux_row_or_digit = "010" else
			digit_4;

-- 7-segm decoder.
	with digit select segm_afbgecd <=
		     '1'&
		'1'&      '1'&
		     '0'&
		'1'&      '1'&
		     '1'
				when x"0",
		     '0'&
		'0'&      '1'&
		     '0'&
		'0'&      '1'&
		     '0'
				when x"1",
		     '1'&
		'0'&      '1'&
		     '1'&
		'1'&      '0'&
		     '1'
				when x"2",
		     '1'&
		'0'&      '1'&
		     '1'&
		'0'&      '1'&
		     '1'
				when x"3",
		     '0'&
		'1'&      '1'&
		     '1'&
		'0'&      '1'&
		     '0'
				when x"4",
		     '1'&
		'1'&      '0'&
		     '1'&
		'0'&      '1'&
		     '1'
				when x"5",
		     '1'&
		'1'&      '0'&
		     '1'&
		'1'&      '1'&
		     '1'
				when x"6",
		     '1'&
		'0'&      '1'&
		     '0'&
		'0'&      '1'&
		     '0'
				when x"7",
		     '1'&
		'1'&      '1'&
		     '1'&
		'1'&      '1'&
		     '1'
				when x"8",
		     '1'&
		'1'&      '1'&
		     '1'&
		'0'&      '1'&
		     '1'
				when x"9",
		     '1'&
		'1'&      '1'&
		     '1'&
		'1'&      '1'&
		     '0'
				when x"a",
		     '0'&
		'1'&      '0'&
		     '1'&
		'1'&      '1'&
		     '1'
				when x"b",
			  '1'&
		'1'&      '0'&
		     '0'&
		'1'&      '0'&
		     '1'
				when x"c",
			  '0'&
		'0'&      '1'&
		     '1'&
		'1'&      '1'&
		     '1'
				when x"d",
			  '1'&
		'1'&      '0'&
		     '1'&
		'1'&      '0'&
		     '1'
				when x"e",
			  '1'&
		'1'&      '0'&
		     '1'&
		'1'&      '0'&
		     '0'
				when x"f",
		     '0'&
		'0'&      '0'&
		     '0'&
		'0'&      '0'&
		     '0'
				when others;

-- Set point on 3rd digit.
segm_dp <= '1' when mux_row_or_digit = "010"else
				'0';

segm(0) <= segm_afbgecd(6);
segm(1) <= segm_afbgecd(4);
segm(2) <= segm_afbgecd(1);
segm(3) <= segm_afbgecd(0);
segm(4) <= segm_afbgecd(2);
segm(5) <= segm_afbgecd(5);
segm(6) <= segm_afbgecd(3);
segm(7) <= segm_dp;


mux_sel_color_or_7segm <= "11"; -- select 7segm

mux_row_or_digit <= "000" when s_cnt < (CLK_FREQ/1000)/4 else
						 "001" when s_cnt < (CLK_FREQ/1000)/2 else
						 "010" when s_cnt < 3*(CLK_FREQ/1000)/4 else
						 "011";


mux_color_or_7segm <= segm;
n_mux_color_or_7segm <= not mux_color_or_7segm;

o_n_col_0_or_7segm_a  <= n_mux_color_or_7segm(0);
o_n_col_1_or_7segm_b  <= n_mux_color_or_7segm(1);
o_n_col_2_or_7segm_c  <= n_mux_color_or_7segm(2);
o_n_col_3_or_7segm_d  <= n_mux_color_or_7segm(3);
o_n_col_4_or_7segm_e  <= n_mux_color_or_7segm(4);
o_n_col_5_or_7segm_f  <= n_mux_color_or_7segm(5);
o_n_col_6_or_7segm_g  <= n_mux_color_or_7segm(6);
o_n_col_7_or_7segm_dp <= n_mux_color_or_7segm(7);

o_mux_row_or_digit <= mux_row_or_digit;	
o_mux_sel_color_or_7segm <= mux_sel_color_or_7segm;

end architecture Behavioral;
