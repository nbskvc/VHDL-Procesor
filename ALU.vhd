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
        case i_alu_sel is
            when "0000" => o_res <= i_bus;         
            when "0001" => o_res <= i_bus;         
            when "0010" => o_res <= i_reg_a + i_bus;       
            when "0011" => o_res <= i_reg_a - i_bus;        
            when others => o_res <= (others => '0');
        end case;
    end process;
end Behavioral;
