	component clktrial1 is
		port (
			clk : out std_logic   -- clk
		);
	end component clktrial1;

	u0 : component clktrial1
		port map (
			clk => CONNECTED_TO_clk  -- clk.clk
		);

