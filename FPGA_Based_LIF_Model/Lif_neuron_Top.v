`timescale 1ns / 1ps
module Lif_neuron_Top (
    input  wire        clk,      // e.g. 100 MHz board clock
    input  wire        rst_n,    // BTN0, active-low reset
    input  wire        btn1,     // BTN1 start button
    output wire [3:0]  led       // LED[0]=TH1, … LED[3]=TH4
);


  reg btn1_sync0, btn1_sync1, btn1_prev, ramp_en;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      btn1_sync0 <= 1'b0;
      btn1_sync1 <= 1'b0;
      btn1_prev  <= 1'b0;
      ramp_en    <= 1'b0;
    end else begin
      // simple 2-stage synchronizer
      btn1_sync0 <= btn1;
      btn1_sync1 <= btn1_sync0;
      // edge detect
      btn1_prev <= btn1_sync1;
      // on first rising edge, arm ramp_en and never turn it off until reset
      if (!ramp_en &&  btn1_sync1 && !btn1_prev)
        ramp_en <= 1'b1;
    end
  end


  localparam integer CLK_FREQ_HZ = 100_000_000;
  localparam integer TICKS_PER_MS = CLK_FREQ_HZ/1000;
  reg [26:0] ms_cnt;
  reg        tick_1k;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ms_cnt <= 0;
      tick_1k<= 1'b0;
    end else if (ms_cnt == TICKS_PER_MS-1) begin
      ms_cnt  <= 0;
      tick_1k <= 1'b1;
    end else begin
      ms_cnt  <= ms_cnt + 1;
      tick_1k <= 1'b0;
    end
  end

  //==========================================================================
  // 3) Ramp generator and threshold LEDs
  //==========================================================================
  // -- you can tune these thresholds & width as needed
  localparam [7:0] TH1 = 8'd64;
  localparam [7:0] TH2 = 8'd128;
  localparam [7:0] TH3 = 8'd192;
  localparam [7:0] TH4 = 8'd255;

  reg [7:0] input_current;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      input_current <= 8'd0;
    end else if (tick_1k && ramp_en) begin
      if (input_current >= TH4)
        input_current <= 8'd0;      // wrap around at TH4
      else
        input_current <= input_current + 1;
    end
  end

  // LEDs light once the ramp crosses each threshold
  assign led[0] = (input_current >= TH1);
  assign led[1] = (input_current >= TH2);
  assign led[2] = (input_current >= TH3);
  assign led[3] = (input_current >= TH4);

endmodule
