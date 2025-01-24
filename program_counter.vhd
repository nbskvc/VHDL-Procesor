library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity program_counter is
    Port (
        clk         : in  STD_LOGIC;      
        rst         : in  STD_LOGIC;   
        o_pc        : out STD_LOGIC_VECTOR(15 downto 0);
        i_pc_clear  : in  STD_LOGIC;
        i_pc_en     : in  STD_LOGIC;
        i_jmp_val   : in  STD_LOGIC_VECTOR(5 downto 0)
    );
end program_counter;

architecture Behavioral of program_counter is
    signal pc_reg : UNSIGNED(15 downto 0); 
	 signal negative_jmp : unsigned(4 downto 0);
begin
	
	negative_jmp <= unsigned(i_jmp_val(4 downto 0));

    process(clk, rst, i_jmp_val)
    begin
        if rst = '0' then
            pc_reg <= (others => '0');  
        elsif rising_edge(clk) then
            if i_pc_clear = '1' then
                pc_reg <= (others => '0');
            elsif i_pc_en = '1' then
                if pc_reg = x"000F" then
                    pc_reg <= pc_reg; 
                else
						  if(i_jmp_val(5) = '0')then
								pc_reg <= (pc_reg + 1) + resize(unsigned(i_jmp_val), 16);
							else
								pc_reg <= pc_reg + 1 - resize(negative_jmp, 16);
							end if;
                end if;
            end if;
        end if;
    end process;

    o_pc <= std_logic_vector(pc_reg);                   

end Behavioral;
