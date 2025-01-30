library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


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
			o_res <= std_logic_vector(unsigned(i_reg_a) + unsigned(i_bus));
		elsif(i_alu_sel = "0011")then
			o_res <= std_logic_vector(unsigned(i_reg_a) - unsigned(i_bus));
		elsif(i_alu_sel = "0111")then
			if(i_reg_a = i_bus)then
				o_res <= (others => '1');
			else
				o_res <= (others => '0');
			end if;
		elsif(i_alu_sel = "1000")then--shl
			o_res <= i_bus(14 downto 0)&'0';
		elsif(i_alu_sel = "1001")then
			o_res <= '0'&i_bus(15 downto 1);--shr
		elsif(i_alu_sel = "1010")then --and
			o_res <= std_logic_vector(unsigned(i_bus) and unsigned(i_reg_a));
		elsif(i_alu_sel = "1011")then --or
			o_res <= std_logic_vector(unsigned(i_bus) or unsigned(i_reg_a));
		elsif(i_alu_sel = "1100")then --not
			o_res <= std_logic_vector(not unsigned(i_bus));
		elsif(i_alu_sel = "1101")then --inc
			o_res <= std_logic_vector(unsigned(i_bus) + 1);
		elsif(i_alu_sel = "1110")then --dec
			o_res <= std_logic_vector(unsigned(i_bus) - 1);
		elsif(i_alu_sel = "1111")then --ashr
			o_res <= i_bus(15)&i_bus(15 downto 1);
		else
			o_res <= (others => '0');
		end if;
    end process;
end Behavioral;