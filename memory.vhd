LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY memory IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC := '1';
		data		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		wren		: IN STD_LOGIC;
		q		: OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
	);
END memory;

ARCHITECTURE SYN OF memory IS
	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (9 DOWNTO 0);

BEGIN
	q    <= sub_wire0;

	-- Instanciranje Altera altsyncram komponente
	altsyncram_component : altsyncram
	GENERIC MAP (
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		intended_device_family => "MAX 10",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 16, -- Dubina memorije (iz MIF fajla: DEPTH = 16)
		operation_mode => "SINGLE_PORT",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "CLOCK0",
		power_up_uninitialized => "FALSE",
		read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ",
		widthad_a => 4, -- Širina adrese (log2(16) = 4 bita)
		width_a => 10, -- Širina podataka (iz MIF fajla: WIDTH = 10)
		width_byteena_a => 1,
		init_file => "memory.mif" -- Referenca na MIF fajl
	)
	PORT MAP (
		address_a => address(3 DOWNTO 0), -- Koristimo samo 4 bita adrese
		clock0 => clock,
		data_a => data,
		wren_a => wren,
		q_a => sub_wire0
	);

END SYN;
