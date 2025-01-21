library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end entity top_tb;

architecture Behavioral of top_tb is

    -- Component declaration for the DUT (Design Under Test)
    component top is
        generic (
            CLK_FREQ         : positive := 12000000;
            CNT_BITS_COMPENS : integer  := 0
        );
        port (
            clk                          : in  std_logic;
            rst                          : in  std_logic;
            i_run                        : in  std_logic;
            i_sw                         : in  std_logic_vector(7 downto 0);
            o_mux_row_or_digit           : out std_logic_vector(2 downto 0);
            o_mux_sel_color_or_7segm     : out std_logic_vector(1 downto 0);
            o_n_col_0_or_7segm_a         : out std_logic;
            o_n_col_1_or_7segm_b         : out std_logic;
            o_n_col_2_or_7segm_c         : out std_logic;
            o_n_col_3_or_7segm_d         : out std_logic;
            o_n_col_4_or_7segm_e         : out std_logic;
            o_n_col_5_or_7segm_f         : out std_logic;
            o_n_col_6_or_7segm_g         : out std_logic;
            o_n_col_7_or_7segm_dp        : out std_logic
        );
    end component;

    -- Signals to connect to DUT
    signal clk                  : std_logic := '0';
    signal rst                  : std_logic := '0';
    signal i_run                : std_logic := '0';
    signal i_sw                 : std_logic_vector(7 downto 0) := (others => '0');
    signal o_mux_row_or_digit   : std_logic_vector(2 downto 0);
    signal o_mux_sel_color_or_7segm : std_logic_vector(1 downto 0);
    signal o_n_col_0_or_7segm_a : std_logic;
    signal o_n_col_1_or_7segm_b : std_logic;
    signal o_n_col_2_or_7segm_c : std_logic;
    signal o_n_col_3_or_7segm_d : std_logic;
    signal o_n_col_4_or_7segm_e : std_logic;
    signal o_n_col_5_or_7segm_f : std_logic;
    signal o_n_col_6_or_7segm_g : std_logic;
    signal o_n_col_7_or_7segm_dp : std_logic;

    -- Clock period constant
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the DUT
    uut: top
        generic map (
            CLK_FREQ => 12000000
        )
        port map (
            clk => clk,
            rst => rst,
            i_run => i_run,
            i_sw => i_sw,
            o_mux_row_or_digit => o_mux_row_or_digit,
            o_mux_sel_color_or_7segm => o_mux_sel_color_or_7segm,
            o_n_col_0_or_7segm_a => o_n_col_0_or_7segm_a,
            o_n_col_1_or_7segm_b => o_n_col_1_or_7segm_b,
            o_n_col_2_or_7segm_c => o_n_col_2_or_7segm_c,
            o_n_col_3_or_7segm_d => o_n_col_3_or_7segm_d,
            o_n_col_4_or_7segm_e => o_n_col_4_or_7segm_e,
            o_n_col_5_or_7segm_f => o_n_col_5_or_7segm_f,
            o_n_col_6_or_7segm_g => o_n_col_6_or_7segm_g,
            o_n_col_7_or_7segm_dp => o_n_col_7_or_7segm_dp
        );

    -- Clock process
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the system
        rst <= '0';
        wait for 20 ns;
        rst <= '1';

        -- Test case 1: Set inputs and observe outputs
        i_run <= '1';
        wait for 100 ns;

        -- Test case 2: Change inputs and observe outputs
        wait for 100 ns;

        -- Add more test cases as needed
        wait;
    end process;

end architecture Behavioral;
