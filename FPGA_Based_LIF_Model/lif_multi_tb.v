`timescale 1ns/1ps
module lif_multi_tb;
  // Inputs to DUT
  reg  clk, rst_n, btn1;
  // Outputs from DUT
  wire [3:0] led;
  wire       uart_tx;

  // Instantiate DUT
  lif_multi dut (
    .clk     (clk),
    .rst_n   (rst_n),
    .btn1    (btn1),
    .led     (led),
    .uart_tx (uart_tx)
  );

  // 12 MHz clock → period ≈ 83.333 ns
  initial clk = 0;
  always #41.667 clk = ~clk;

  // Test sequence
  initial begin
    // 1) Hold reset low for 500 ns
    rst_n = 0; btn1 = 0;
    #500;

    // 2) Release reset, wait 10 µs
    rst_n = 1;
    #10_000;

    // 3) Pulse BTN1 for one clock
    btn1 = 1; #83.333; btn1 = 0;

    // 4) Let ramp run for 50 ms
    #50_000_000;

    // 5) Finish sim
    $finish;
  end
endmodule
