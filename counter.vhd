library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
	generic(
			constant module : positive;
			constant bits : positive
	);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  ocnt : out std_logic_vector(bits-1 downto 0));
end counter;

architecture Behavioral of counter is
	signal scnt : std_logic_vector(bits-1 downto 0);
begin
process(clk, rst) begin
	if(rst = '0') then
		scnt <= (others => '0');
	elsif(rising_edge(clk))then
		if(scnt = module)then
			scnt <= (others => '0');
		else
			scnt <= scnt + 1;
		end if;
	end if;
end process;
ocnt <= scnt;
end Behavioral;

