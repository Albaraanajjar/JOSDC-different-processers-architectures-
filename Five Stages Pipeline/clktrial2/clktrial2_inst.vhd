	component clktrial2 is
		port (
			clk : out std_logic   -- clk
		);
	end component clktrial2;

	u0 : component clktrial2
		port map (
			clk => CONNECTED_TO_clk  -- clk.clk
		);

