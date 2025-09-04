`timescale 1ns/1ps

module Top_tb;

  // ----------------------------
  // Clock & Reset
  // ----------------------------
  reg Hclk, Hresetn;

  // ----------------------------
  // AHB-side signals
  // ----------------------------
  wire [31:0] Hrdata;
  reg  [31:0] Haddr, Hwdata;
  reg  [1:0]  Htrans;
  reg         Hwrite, Hreadyin;
  wire [2:0]  Hreadyout;

  // ----------------------------
  // APB-side signals
  // ----------------------------
  wire        Pwrite, Penable;
  wire [2:0]  Pselx;
  wire [31:0] Paddr, Pwdata;
  reg  [31:0] Prdata;         // TB drives this for reads

  // ----------------------------
  // TB locals (declare BEFORE use)
  // ----------------------------
  reg [31:0] rd;              // <— moved out of initial block

  // ==========================================================
  // DUT Instance
  // ==========================================================
  Bridge_Top bridge (
    .Hclk      (Hclk),
    .Hresetn   (Hresetn),
    .Hwrite    (Hwrite),
    .Hreadyin  (Hreadyin),
    .Hwdata    (Hwdata),
    .Haddr     (Haddr),
    .Prdata    (Prdata),
    .Htrans    (Htrans),
    .Pwrite    (Pwrite),
    .Penable   (Penable),
    .Pselx     (Pselx),
    .Hreadyout (Hreadyout),
    .Pwdata    (Pwdata),
    .Paddr     (Paddr),
    .Hrdata    (Hrdata)
  );

  // ==========================================================
  // Clock generation
  // ==========================================================
  initial begin
    Hclk = 1'b0;
    forever #10 Hclk = ~Hclk; // 50 MHz
  end

  // ==========================================================
  // Reset task
  // ==========================================================
  task reset;
    integer k;
    begin
      Hresetn = 1'b0;
      for (k=0; k<4; k=k+1) @(negedge Hclk);
      Hresetn = 1'b1;
      @(negedge Hclk);
    end
  endtask

  // ==========================================================
  // Default tie-offs
  // ==========================================================
  initial begin
    Hreadyin = 1'b1;        // always ready
    Haddr    = 32'h0;
    Hwdata   = 32'h0;
    Hwrite   = 1'b0;
    Htrans   = 2'b00;       // IDLE
    Prdata   = 32'h0;       // set for reads
  end

  // ==========================================================
  // Simple AHB single-beat write
  // ==========================================================
  task ahb_single_write(input [31:0] addr, input [31:0] data);
  begin
    @(negedge Hclk);
    Haddr  <= addr;
    Hwdata <= data;
    Hwrite <= 1'b1;
    Htrans <= 2'b10;       // NONSEQ

    @(negedge Hclk);       // data phase
    Htrans <= 2'b00;       // back to IDLE
    Hwrite <= 1'b0;

    wait (Hreadyout !== 3'bxxx);
  end
  endtask

  // ==========================================================
  // Simple AHB single-beat read
  // ==========================================================
  task ahb_single_read(input [31:0] addr, output [31:0] rdata);
  begin
    @(negedge Hclk);
    Haddr  <= addr;
    Hwrite <= 1'b0;
    Htrans <= 2'b10;          // NONSEQ

    Prdata <= 32'hA5A5_5A5A;  // emulate APB return

    @(negedge Hclk);
    Htrans <= 2'b00;          // IDLE

    wait (Hreadyout !== 3'bxxx);
    rdata = Hrdata;
  end
  endtask

  // ==========================================================
  // Waves (VCD; ModelSim can still record if enabled)
  // ==========================================================
  initial begin
    $dumpfile("bridge_top_tb.vcd");
    $dumpvars(0, Top_tb);
  end

  // Optional console monitor
  initial begin
    $display(" time | Hresetn Hreadyout Hwrite Htrans | PSEL PEN PWRITE | Haddr        Pwdata        Prdata");
    forever begin
      @(posedge Hclk);
      $display("%5t |   %0b      %03b      %0b     %0d   |  %03b   %0b    %0b   | %08h  %08h  %08h",
        $time, Hresetn, Hreadyout, Hwrite, Htrans, Pselx, Penable, Pwrite, Haddr, Pwdata, Prdata);
    end
  end

  // ==========================================================
  // Stimulus
  // ==========================================================
  initial begin
    reset();

    repeat (3) @(negedge Hclk);

    // Single write
    ahb_single_write(32'h0000_0000, 32'hDEAD_BEEF);
    repeat (6) @(negedge Hclk);

    // Single read
    ahb_single_read(32'h0000_0000, rd);
    $display("[TB] Readback HRDATA = 0x%08h @ %0t", rd, $time);

    repeat (8) @(negedge Hclk);
    $display("\n[TB] Done at %0t\n", $time);
    $finish;
  end

endmodule
