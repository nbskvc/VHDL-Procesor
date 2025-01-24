library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lprs_processor is
    Port (
        clk         : in  std_logic;                 
        rst       : in  std_logic;                 
        i_inst : in std_logic_vector(9 downto 0);
		  i_run : in std_logic;
		  i_data : in std_logic_vector(15 downto 0);
		  o_bus : out std_logic_vector(15 downto 0);
		  o_pc : out std_logic_vector(15 downto 0);
		  o_reg_1 : out std_logic_vector(15 downto 0);
		  --test
		  o_reg_sel : out std_logic_vector(2 downto 0);
		  o_data_sel : out std_logic;
		  o_g_sel : out std_logic 
    );
end lprs_processor;


architecture Behavioral of lprs_processor is
signal s_inst : std_logic_vector(9 downto 0); 
signal s_bus : std_logic_vector(15 downto 0);
signal sr_0, sr_1, sr_2, sr_3, sr_4, sr_5, sr_6, sr_7, s_a, s_g : std_logic_vector(15 downto 0);
--izlazi iz CU
signal s_reg_sel :  STD_LOGIC_VECTOR(2 downto 0);
signal s_reg_in : std_logic_vector(2 downto 0);
signal s_reg_en : STD_LOGIC;
signal s_acc_we : STD_LOGIC;
signal s_result_we :  STD_LOGIC;
signal s_alu_sel : STD_LOGIC_VECTOR(3 downto 0);
signal s_g_sel : STD_LOGIC;
signal s_data_sel : STD_LOGIC;
signal s_jmp_val : std_logic_vector(5 downto 0);
--program counter
signal s_pc_clear : std_logic;
signal s_pc_en : std_logic;
signal s_pc : std_logic_vector(15 downto 0);
--izlaz iz dekodera
signal s_reg_we : std_logic_vector(7 downto 0);
--izlaz iz alu
signal s_alu_res : std_logic_vector(15 downto 0);


begin
--inicjalizacija registara
reg_instr: entity work.nbit_register
	generic map(
		bits => 10
	)
	port map(
		clk => clk,
		rst => rst,
		in_data => i_inst,
		out_data => s_inst,
		write_en => '1'--i_run
	);
reg_0: entity work.nbit_register
	generic map(
		bits => 16
	)
	port map(
		clk => clk,
		rst => rst,
		in_data => s_bus,
		out_data => sr_0,
		write_en => s_reg_we(0)
	);
reg_1: entity work.nbit_register
	generic map(
		bits => 16
	)
	port map(
		clk => clk,
		rst => rst,
		in_data => s_bus,
		out_data => sr_1,
		write_en => s_reg_we(1)
	);
reg_2: entity work.nbit_register
	generic map(
		bits => 16
	)
	port map(
		clk => clk,
		rst => rst,
		in_data => s_bus,
		out_data => sr_2,
		write_en => s_reg_we(2)
	);
reg_3: entity work.nbit_register
	generic map(
		bits => 16
	)
	port map(
		clk => clk,
		rst => rst,
		in_data => s_bus,
		out_data => sr_3,
		write_en => s_reg_we(3)
	);
reg_4: entity work.nbit_register
	generic map(
		bits => 16
	)
	port map(
		clk => clk,
		rst => rst,
		in_data => s_bus,
		out_data => sr_4,
		write_en => s_reg_we(4)
	);
reg_5: entity work.nbit_register
	generic map(
		bits => 16
	)
	port map(
		clk => clk,
		rst => rst,
		in_data => s_bus,
		out_data => sr_5,
		write_en => s_reg_we(5)
	);
reg_6: entity work.nbit_register
	generic map(
		bits => 16
	)
	port map(
		clk => clk,
		rst => rst,
		in_data => s_bus,
		out_data => sr_6,
		write_en => s_reg_we(6)
	);
reg_7: entity work.nbit_register
	generic map(
		bits => 16
	)
	port map(
		clk => clk,
		rst => rst,
		in_data => s_bus,
		out_data => sr_7,
		write_en => s_reg_we(7)
	);
reg_a: entity work.nbit_register
	generic map(
		bits => 16
	)
	port map(
		clk => clk,
		rst => rst,
		in_data => s_bus,
		out_data => s_a,
		write_en => s_acc_we
	);
reg_g: entity work.nbit_register
	generic map(
		bits => 16
	)
	port map(
		clk => clk,
		rst => rst,
		in_data => s_alu_res,
		out_data => s_g,
		write_en => s_result_we
	);
	
control_unit: entity work.control_unit
	port map(
			  clk  => clk,
           rst => rst,
           i_run => i_run,
			  i_inst => s_inst,
			  o_reg_sel => s_reg_sel,
			  o_reg_in => s_reg_in,
			  o_reg_en => s_reg_en,
			  o_acc_we => s_acc_we,
			  o_result_we => s_result_we,
			  o_alu_sel => s_alu_sel,
			  o_g_sel => s_g_sel,
			  o_data_sel => s_data_sel,
			  o_pc_clear => s_pc_clear,
			  o_pc_en => s_pc_en,
			  o_jmp_val => s_jmp_val
	);
decoder: entity work.decoder3to8
	port map(
			 input => s_reg_in,
			 i_en => s_reg_en,
			 output=> s_reg_we
	);
alu: entity work.ALU
	port map(
			i_reg_a => s_a,
			i_bus => s_bus,
			i_alu_sel => s_alu_sel,
			o_res => s_alu_res
	);
mux: entity work.multiplexer
	port map(
		  i_data => i_data,    
        i_reg_0   => sr_0,    
        i_reg_1   => sr_1,  
		  i_reg_2   => sr_2,    
        i_reg_3   => sr_3,   
		  i_reg_4   => sr_4,    
        i_reg_5   => sr_5,   
		  i_reg_6   => sr_6,    
        i_reg_7   => sr_7,
		  i_g		   => s_g,
		  i_data_sel => s_data_sel, 
		  i_reg_sel => s_reg_sel,
		  i_g_sel   => s_g_sel,
        o_bus     => s_bus
	);
	
pc: entity work.program_counter
	port map(
		clk     => clk,      
	  rst   => rst,
	  o_pc  => s_pc,
	  i_pc_clear => s_pc_clear,
	  i_pc_en => s_pc_en,
	  i_jmp_val => s_jmp_val
	);

	o_bus <= s_bus;
	o_pc <= s_pc;
   o_reg_1 <= sr_1;
	
	o_reg_sel <= s_reg_sel;
	o_data_sel <= s_data_sel;
	o_g_sel <= s_g_sel;
end Behavioral;
