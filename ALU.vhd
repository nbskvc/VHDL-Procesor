library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port (
        i_reg_a      : in  STD_LOGIC_VECTOR(15 downto 0); 
        i_bus      : in  STD_LOGIC_VECTOR(15 downto 0); 
        i_alu_sel  : in  STD_LOGIC_VECTOR(3 downto 0); 
        o_res : out STD_LOGIC_VECTOR(15 downto 0) 
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(i_reg_a, i_bus, i_alu_sel)
    begin
		if(i_alu_sel = "0000")then
			o_res <= i_bus;
		elsif(i_alu_sel = "0001")then
			o_res <= i_bus;
		elsif(i_alu_sel = "0010")then
			o_res <= i_reg_a + i_bus;
		elsif(i_alu_sel = "0011")then
			o_res <= i_reg_a - i_bus;
		elsif(i_alu_sel = "0111")then
			if(i_reg_a = i_bus)then
				o_res <= (others => '1');
			else
				o_res <= (others => '0');
			end if;
		else
			o_res <= (others => '0');
		end if;
    end process;
end Behavioral;