library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_unit is
    Port ( clk     : in  STD_LOGIC;
           rst   : in  STD_LOGIC;
           i_run : in STD_LOGIC;
			  i_inst : in STD_LOGIC_VECTOR(9 downto 0);
			  o_reg_sel : out STD_LOGIC_VECTOR(2 downto 0);
			  o_reg_in : out STD_LOGIC_VECTOR(2 downto 0);
			  o_reg_en : out STD_LOGIC;
			  o_acc_we : out STD_LOGIC;
			  o_result_we : out STD_LOGIC;
			  o_alu_sel : out STD_LOGIC_VECTOR(3 downto 0);
			  o_g_sel : out STD_LOGIC;
			  o_data_sel : out STD_LOGIC;
			  o_pc_clear : out STD_LOGIC;
			  o_pc_en : out STD_LOGIC;
			  o_jmp_val : out std_logic_vector(5 downto 0);
			  i_eq_flag : in std_logic
			  );
end control_unit;

architecture Behavioral of control_unit is
	type state_type is (Fetch, ID, EX, WB);
	signal state, next_state : state_type;
	signal fetch_done : std_logic;
	signal test : std_logic_vector(3 downto 0);
    
begin
	--registar za pamcenje stanja
	process(clk, rst) begin
		if(rst = '0') then
			state <= Fetch;
		elsif rising_edge(clk) then
			state <= next_state;
		else
			state <= state;
		end if;
	end process;
	
	--funkcija prelaza
	process(clk, state, i_inst) begin
			  o_reg_en <= '0';
			  o_acc_we <= '0';
			  o_result_we <= '0';
			  o_g_sel <= '0';
			  o_data_sel <= '0';
			  o_pc_clear <= '0';
			  o_pc_en <= '0';	
			  o_reg_sel <= "000";
			  o_alu_sel <= "0000";
			  o_jmp_val <= "000000";
			  test <= "0000";
		case(state) is
			when Fetch=>
				if(i_run = '1')then	
					next_state <= ID;
					o_pc_en <= '1';
					if(i_inst(9 downto 6) = "0100")then  --jmp
						o_jmp_val <= i_inst(5 downto 0);
					elsif(i_inst(9 downto 6) = "0101")then
						if(i_eq_flag = '1')then
							o_jmp_val <= i_inst(5 downto 0);
						end if;
					end if;
				else
					next_state <= Fetch;
				end if;
			when ID =>
				if(i_inst(9 downto 6) = "0000")then --mv
					test <= "0001";
					o_reg_sel <= i_inst(2 downto 0);
					o_reg_in <= i_inst(5 downto 3);
					o_reg_en <= '1';
				elsif(i_inst(9 downto 6) = "0001")then --mvi
					test <= "0011";
					o_data_sel <= '1' ;
					o_reg_in <= i_inst(5 downto 3);
					o_reg_en <= '1';
				elsif(i_inst(9 downto 6) = "0010")then --add
					test <= "0101";
					o_reg_sel <= i_inst(5 downto 3);  --rx out
					o_acc_we <= '1'; --write rx to A reg
					--o_alu_sel <= "0010"; --select add
				elsif(i_inst(9 downto 6) = "0011")then --sub
				test <= "0111";
					o_reg_sel <= i_inst(5 downto 3);
					o_acc_we <= '1';
				elsif(i_inst(9 downto 6) = "0111")then --cmp
					o_reg_sel <= i_inst(5 downto 3);  --rx out
					o_acc_we <= '1'; --write rx to A reg
					--o_alu_sel <= "0111"; --select cmp
				elsif(i_inst(9 downto 6) = "1000")then --shl
					o_reg_sel <= i_inst(2 downto 0);
					o_acc_we <= '1';
					--o_alu_sel <= "1000";
				elsif(i_inst(9 downto 6) = "1001")then --shr
					o_reg_sel <= i_inst(2 downto 0);
					o_acc_we <= '1';
				elsif(i_inst(9 downto 6) = "1010")then --and
					o_reg_sel <= i_inst(5 downto 3);  --rx out
					o_acc_we <= '1'; --write rx to A reg
				elsif(i_inst(9 downto 6) = "1011")then --or
					o_reg_sel <= i_inst(5 downto 3);  --rx out
					o_acc_we <= '1'; --write rx to A reg
				elsif(i_inst(9 downto 6) = "1100")then --not
					o_reg_sel <= i_inst(2 downto 0);
					o_acc_we <= '1';
				elsif(i_inst(9 downto 6) = "1111")then --ashr
					o_reg_sel <= i_inst(2 downto 0);
					o_acc_we <= '1';
				end if;
				o_alu_sel <= i_inst(9 downto 6);
				next_state <= EX;
			when EX =>
				if(i_inst(9 downto 6) = "0000")then --mv
					test <= "0000";
				elsif(i_inst(9 downto 6) = "0001")then --mvi
					o_data_sel <= '1';
					test <= "0001";
					--o_alu_sel <= "0001";
				elsif(i_inst(9 downto 6) = "0010")then --add
					test <= "0010";
					o_result_we <= '1';
					o_reg_sel <= i_inst(2 downto 0); --ry out
					--o_alu_sel <= "0010"; --select add
				elsif(i_inst(9 downto 6) = "0011")then --sub
					o_result_we <= '1';
					o_reg_sel <= i_inst(2 downto 0);
					--o_alu_sel <= "0011";
					test <= "0011";
				elsif(i_inst(9 downto 6) = "0111")then --cmp
					test <= "0010";
					o_result_we <= '1';
					o_reg_sel <= i_inst(2 downto 0); --ry out
					--o_alu_sel <= "0111"; --select cmp
				elsif(i_inst(9 downto 6) = "1000")then --shl
					o_result_we <= '1';
					o_reg_sel <= i_inst(2 downto 0);
					--o_alu_sel <= "1000";
				elsif(i_inst(9 downto 6) = "1001")then --shr
					o_result_we <= '1';
					o_reg_sel <= i_inst(2 downto 0);
				elsif(i_inst(9 downto 6) = "1010")then --and
					o_result_we <= '1';
					o_reg_sel <= i_inst(2 downto 0); --ry out
				elsif(i_inst(9 downto 6) = "1011")then --or
					o_result_we <= '1';
					o_reg_sel <= i_inst(2 downto 0); --ry out
				elsif(i_inst(9 downto 6) = "1100")then --not
					o_result_we <= '1';
					o_reg_sel <= i_inst(2 downto 0);
				elsif(i_inst(9 downto 6) = "1101")then --inc
					o_result_we <= '1';
					o_reg_sel <= i_inst(2 downto 0);
				elsif(i_inst(9 downto 6) = "1110")then --dec
					o_result_we <= '1';
					o_reg_sel <= i_inst(2 downto 0);
				elsif(i_inst(9 downto 6) = "1111")then --ashr
					o_result_we <= '1';
					o_reg_sel <= i_inst(2 downto 0);
				else
					test <= "1111";
				end if;
				o_alu_sel <= i_inst(9 downto 6);
				next_state <= WB;
			when WB =>
				if(i_inst(9 downto 6) = "0000")then --mv
					o_reg_sel <= i_inst(5 downto 3);
				elsif(i_inst(9 downto 6) = "0001")then --mvi
					o_reg_sel <= i_inst(5 downto 3);
				elsif(i_inst(9 downto 6) = "0010")then --add
					o_reg_in <= i_inst(5 downto 3);
					o_reg_en <= '1';
					o_g_sel <= '1';
				elsif(i_inst(9 downto 6) = "0011")then --sub
					o_reg_in <= i_inst(5 downto 3);
					o_reg_en <= '1';
					o_g_sel <= '1';
				elsif(i_inst(9 downto 6) = "0111")then --cmp
					o_reg_in <= "111";
					o_reg_en <= '1';
					o_g_sel <= '1';
				elsif(i_inst(9 downto 6) = "1000")then --shl
					o_reg_in <= i_inst(5 downto 3);
					o_reg_en <= '1';
					o_g_sel <= '1';
				elsif(i_inst(9 downto 6) = "1001")then --shr
					o_reg_in <= i_inst(5 downto 3);
					o_reg_en <= '1';
					o_g_sel <= '1';
				elsif(i_inst(9 downto 6) = "1010")then --and
					o_reg_in <= i_inst(5 downto 3);
					o_reg_en <= '1';
					o_g_sel <= '1';
				elsif(i_inst(9 downto 6) = "1011")then --or
					o_reg_in <= i_inst(5 downto 3);
					o_reg_en <= '1';
					o_g_sel <= '1';
				elsif(i_inst(9 downto 6) = "1100")then --not
					o_reg_in <= i_inst(5 downto 3);
					o_reg_en <= '1';
					o_g_sel <= '1';
				elsif(i_inst(9 downto 6) = "1101")then --inc
					o_reg_in <= i_inst(5 downto 3);
					o_reg_en <= '1';
					o_g_sel <= '1';
				elsif(i_inst(9 downto 6) = "1110")then --dec
					o_reg_in <= i_inst(5 downto 3);
					o_reg_en <= '1';
					o_g_sel <= '1';
				elsif(i_inst(9 downto 6) = "1111")then --ashr
					o_reg_in <= i_inst(5 downto 3);
					o_reg_en <= '1';
					o_g_sel <= '1';
				end if;
				next_state <= Fetch;
			when others =>
				next_state <= Fetch;
		end case;
	
	end process;
end Behavioral;
