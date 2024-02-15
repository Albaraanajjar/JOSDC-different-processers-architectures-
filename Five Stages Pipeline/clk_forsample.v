module clk_forsample(output reg clk);

initial clk=0;

always #1 clk= ~clk;

endmodule 