library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder3to8 is
    Port ( 
        input : in STD_LOGIC_VECTOR (2 downto 0);  
        i_en : in STD_LOGIC;                     
        output : out STD_LOGIC_VECTOR (7 downto 0)  
    );
end decoder3to8;

architecture Behavioral of decoder3to8 is
begin
    output <= "00000001" when (i_en = '1' and input = "000") else
          "00000010" when (i_en = '1' and input = "001") else
          "00000100" when (i_en = '1' and input = "010") else
          "00001000" when (i_en = '1' and input = "011") else
          "00010000" when (i_en = '1' and input = "100") else
          "00100000" when (i_en = '1' and input = "101") else
          "01000000" when (i_en = '1' and input = "110") else
          "10000000" when (i_en = '1' and input = "111") else
          "00000000";
end Behavioral;
