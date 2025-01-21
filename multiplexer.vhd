library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer is
    Port (
        i_data : in  std_logic_vector(15 downto 0);    
        i_reg_0   : in  std_logic_vector(15 downto 0);    
        i_reg_1   : in  std_logic_vector(15 downto 0);  
		  i_reg_2   : in  std_logic_vector(15 downto 0);    
        i_reg_3   : in  std_logic_vector(15 downto 0);   
		  i_reg_4   : in  std_logic_vector(15 downto 0);    
        i_reg_5   : in  std_logic_vector(15 downto 0);   
		  i_reg_6   : in  std_logic_vector(15 downto 0);    
        i_reg_7   : in  std_logic_vector(15 downto 0);
		  i_g		   : in std_logic_vector(15 downto 0);
		  i_data_sel : in std_logic;
		  i_reg_sel : in std_logic_vector(2 downto 0);
		  i_g_sel   : std_logic;
        o_bus     : out std_logic_vector(15 downto 0)

    );
end multiplexer;


architecture Behavioral of multiplexer is
begin
o_bus <= i_data when i_data_sel = '1' else
			i_g when i_g_sel ='1' else
			i_reg_0 when i_reg_sel = "000" else
			i_reg_1 when i_reg_sel = "001" else
			i_reg_2 when i_reg_sel = "010" else
			i_reg_3 when i_reg_sel = "011" else
			i_reg_4 when i_reg_sel = "100" else
			i_reg_5 when i_reg_sel = "101" else
			i_reg_6 when i_reg_sel = "110" else
			i_reg_7 when i_reg_sel = "111" else
			"1111111100000000";
			
    
end Behavioral;
