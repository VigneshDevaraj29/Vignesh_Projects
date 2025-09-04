`timescale 1ns / 1ps
module lif_multi (
  input  wire       clk,      // 12 MHz board clock
  input  wire       rst_n,    // BTN0, active-low reset
  input  wire       btn1,     // BTN1 = start
  output wire [3:0] led,      // LED[0]=TH1 … LED[3]=TH4
  output wire       uart_tx   // USB-UART TX
);

  // 1) Synchronize BTN1 + one-shot
  reg btn1_s0, btn1_s1, btn1_prev, ramp_en;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      btn1_s0   <= 1'b0;
      btn1_s1   <= 1'b0;
      btn1_prev <= 1'b0;
      ramp_en   <= 1'b0;
    end else begin
      btn1_s0   <= btn1;
      btn1_s1   <= btn1_s0;
      btn1_prev <= btn1_s1;
      if (!ramp_en && btn1_s1 && !btn1_prev)
        ramp_en <= 1'b1;
    end
  end

  // 2) 1 ms tick generator (12 MHz → 1 kHz)
  localparam integer CLK_HZ   = 12_000_000;
  localparam integer MS_TICKS = CLK_HZ/1000;  // 12 000
  reg [13:0] ms_cnt;
  reg        tick_ms;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      ms_cnt  <= 0;
      tick_ms <= 1'b0;
    end else if (ms_cnt == MS_TICKS-1) begin
      ms_cnt  <= 0;
      tick_ms <= 1'b1;
    end else begin
      ms_cnt  <= ms_cnt + 1;
      tick_ms <= 1'b0;
    end
  end

  // 3) Slow-down divider (one ramp step per SLOW_FACTOR ms)
  localparam integer SLOW_FACTOR = 20;  // 20 ms per step
  reg [4:0]  slow_cnt;
  wire       ramp_tick = tick_ms && ramp_en && (slow_cnt == SLOW_FACTOR-1);
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      slow_cnt <= 0;
    else if (tick_ms && ramp_en)
      slow_cnt <= (slow_cnt == SLOW_FACTOR-1) ? 0 : slow_cnt + 1;
  end

  // 4) 8-bit ramp counter 0→255→0
  reg [7:0] input_current;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      input_current <= 8'd0;
    else if (ramp_tick)
      input_current <= (input_current == 8'd255) ? 8'd0 : input_current + 1;
  end

  // 5) Threshold LEDs
  localparam [7:0] TH1 = 8'd64,
                   TH2 = 8'd128,
                   TH3 = 8'd192,
                   TH4 = 8'd255;
  assign led[0] = (input_current >= TH1);
  assign led[1] = (input_current >= TH2);
  assign led[2] = (input_current >= TH3);
  assign led[3] = (input_current >= TH4);

  // 6) Capture rising edge of each LED
  reg [3:0] led_prev;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      led_prev <= 4'b0;
    else
      led_prev <= led;
  end
  wire th1_ev = led[0] && !led_prev[0];
  wire th2_ev = led[1] && !led_prev[1];
  wire th3_ev = led[2] && !led_prev[2];
  wire th4_ev = led[3] && !led_prev[3];

  // 7) UART FSM: IDLE → SPIKE → RESET → IDLE
  localparam integer SPIKE_LEN = 14;  // "SPIKE! - THx\r\n"
  localparam integer RESET_LEN = 13;  // "Resets to 0\r\n"
  localparam ST_IDLE  = 2'd0,
             ST_SPIKE = 2'd1,
             ST_RESET = 2'd2;

  reg  [1:0] state   = ST_IDLE;
  reg  [3:0] byte_cnt;
  reg  [2:0] evt;         // threshold index 1..4
  reg        send_stb;
  reg  [7:0] tx_byte;
  wire       uart_busy;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state    <= ST_IDLE;
      byte_cnt <= 0;
      evt      <= 0;
      send_stb <= 0;
    end else begin
      // clear strobe once UART captures it
      if (send_stb && uart_busy)
        send_stb <= 0;

      case (state)
        // WAIT for any threshold event
        ST_IDLE: begin
          if      (th1_ev) begin evt<=1; state<=ST_SPIKE; byte_cnt<=0; end
          else if (th2_ev) begin evt<=2; state<=ST_SPIKE; byte_cnt<=0; end
          else if (th3_ev) begin evt<=3; state<=ST_SPIKE; byte_cnt<=0; end
          else if (th4_ev) begin evt<=4; state<=ST_SPIKE; byte_cnt<=0; end
        end

        // SEND "SPIKE! - THx"
        ST_SPIKE: begin
          if (!send_stb && !uart_busy) begin
            case (byte_cnt)
              0:  tx_byte<="S";   1: tx_byte<="P";
              2:  tx_byte<="I";   3: tx_byte<="K";
              4:  tx_byte<="E";   5: tx_byte<="!";
              6:  tx_byte<=" ";   7: tx_byte<="-";
              8:  tx_byte<=" ";   9: tx_byte<="T";
              10: tx_byte<="H";   11: tx_byte<= (evt==1)?"1":(evt==2)?"2":(evt==3)?"3":"4";
              12: tx_byte<=8'h0D; // CR
              13: tx_byte<=8'h0A; // LF
            endcase
            send_stb <= 1;
          end else if (!uart_busy && send_stb) begin
            byte_cnt <= byte_cnt + 1;
          end

          if (byte_cnt == SPIKE_LEN && !uart_busy && !send_stb) begin
            state    <= (evt==4) ? ST_RESET : ST_IDLE;
            byte_cnt <= 0;
          end
        end

        // SEND "Resets to 0"
        ST_RESET: begin
          if (!send_stb && !uart_busy) begin
            case (byte_cnt)
              0:  tx_byte<="R";   1: tx_byte<="e";
              2:  tx_byte<="s";   3: tx_byte<="e";
              4:  tx_byte<="t";   5: tx_byte<="s";
              6:  tx_byte<=" ";   7: tx_byte<="t";
              8:  tx_byte<="o";   9: tx_byte<=" ";
              10: tx_byte<="0";   11: tx_byte<=8'h0D;
              12: tx_byte<=8'h0A;
            endcase
            send_stb <= 1;
          end else if (!uart_busy && send_stb) begin
            byte_cnt <= byte_cnt + 1;
          end

          if (byte_cnt == RESET_LEN && !uart_busy && !send_stb) begin
            state    <= ST_IDLE;
            byte_cnt <= 0;
          end
        end
      endcase
    end
  end

  // 8) UART-TX instance
  uart_tx #(
    .CLOCK_FREQ(CLK_HZ),
    .BAUD_RATE  (115200)
  ) uart_inst (
    .clk     (clk),
    .rst_n   (rst_n),
    .data_in (tx_byte),
    .send    (send_stb),
    .tx      (uart_tx),
    .busy    (uart_busy)
  );

endmodule
