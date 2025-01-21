library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity nbit_register is
	generic(
		constant bits: positive
	);
    Port ( clk     : in  STD_LOGIC;
           rst   : in  STD_LOGIC;
           in_data : in STD_LOGIC_VECTOR(bits-1 downto 0);
			  out_data : out STD_LOGIC_VECTOR(bits-1 downto 0);
			  write_en : in STD_LOGIC);
end nbit_register;

architecture Behavioral of nbit_register is
signal reg_data : std_logic_vector(bits-1 downto 0);
    
begin
process(clk, rst) begin
	if rising_edge(clk) then
		if rst = '0' then
			reg_data <= (others => '0');
		else
			if write_en = '1' then
				reg_data <= in_data;
			else
				reg_data <= reg_data;
			end if;
		end if;
	end if;
end process;

out_data <= reg_data;

end Behavioral;
