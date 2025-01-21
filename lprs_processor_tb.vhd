LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY lprs_processor_tb IS
END lprs_processor_tb;

ARCHITECTURE behavior OF lprs_processor_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT lprs_processor
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         i_inst : IN  std_logic_vector(9 downto 0);
         i_run : IN  std_logic;
         i_data : IN  std_logic_vector(15 downto 0);
         o_bus : OUT std_logic_vector(15 downto 0);
			o_pc : out std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    
    -- Signals for driving inputs and observing outputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal i_inst : std_logic_vector(9 downto 0) := (others => '0');
   signal i_run : std_logic := '0';
   signal i_data : std_logic_vector(15 downto 0) := (others => '0');
   signal o_bus : std_logic_vector(15 downto 0);
	signal o_pc : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   
BEGIN

    -- Instantiate the Unit Under Test (UUT)
   uut: lprs_processor PORT MAP (
          clk => clk,
          rst => rst,
          i_inst => i_inst,
          i_run => i_run,
          i_data => i_data,
          o_bus => o_bus,
			 o_pc => o_pc
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin
      -- Reset the processor
      rst <= '1';
      wait for 20 ns;
      rst <= '0';
      wait for 20 ns;
      
      -- mvi
      i_inst <= "0001001010";  --mvi(R1, x000F)
      i_data <= x"000F";       
      i_run <= '1';
      wait for clk_period * 10;
      
      -- mv
      wait for 50 ns;
      i_inst <= "0000000001";   --mv(R0, R1)
      i_run <= '1';
      wait for clk_period * 10;
		
		-- mvi
      i_inst <= "0001001010";  --mvi(R1, x00FF)
      i_data <= x"00FF";       
      i_run <= '1';
      wait for clk_period * 10;
		
		--add
		i_inst <= "0010000001";   --add(R0, R1)
		wait for clk_period * 10;
		
		--sub
		i_inst <= "0011000001";   --add(R0, R1)
		wait for clk_period * 10;
		i_run <= '0';

      -- Wait for outputs to stabilize and observe
      wait for 100 ns;
      
      -- Stop the simulation
      wait;
   end process;

END;
