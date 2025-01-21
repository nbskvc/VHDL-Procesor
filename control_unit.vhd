library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_unit is
    Port ( clk     : in  STD_LOGIC;
           rst   : in  STD_LOGIC;
           --i_run : in STD_LOGIC;
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
			  o_pc_en : out STD_LOGIC);
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
			--if(i_run = '1') then
				state <= next_state;
			--else
			--	state <= state;
			--end if;
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
			  test <= "0000";
		case(state) is
			when Fetch=>
				next_state <= ID;
				o_pc_en <= '1';
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
					o_alu_sel <= "0010"; --select add
				elsif(i_inst(9 downto 6) = "0011")then --sub
				test <= "0111";
					o_reg_sel <= i_inst(5 downto 3);
					o_acc_we <= '1';
					--o_alu_sel <= opcode;
				end if;
				next_state <= EX;
			when EX =>
				if(i_inst(9 downto 6) = "0000")then --mv
					--o_pc_en <= '1';
					test <= "0000";
				elsif(i_inst(9 downto 6) = "0001")then --mvi
					o_data_sel <= '1';
					test <= "0001";
					--o_pc_en <= '1';
				elsif(i_inst(9 downto 6) = "0010")then --add
					--o_pc_en <= '1';
					test <= "0010";
					o_result_we <= '1';
					o_reg_sel <= i_inst(2 downto 0); --ry out
					o_alu_sel <= "0010"; --select add
				elsif(i_inst(9 downto 6) = "0011")then --sub
					--o_pc_en <= '1';
					o_result_we <= '1';
					o_reg_sel <= i_inst(2 downto 0);
					o_alu_sel <= "0011";
					test <= "0011";
				else
					test <= "1111";
				end if;
				next_state <= WB;
			when WB =>
				if(i_inst(9 downto 6) = "0000")then
					o_reg_sel <= i_inst(5 downto 3);
				elsif(i_inst(9 downto 6) = "0001")then
					o_reg_sel <= i_inst(5 downto 3);
				elsif(i_inst(9 downto 6) = "0010")then --add
					o_reg_in <= i_inst(5 downto 3);
					o_reg_en <= '1';
					o_g_sel <= '1';
				elsif(i_inst(9 downto 6) = "0011")then
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
