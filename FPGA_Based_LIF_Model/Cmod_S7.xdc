## Cmod S7-25 Rev B - top-level XDC for lif_multi project

## 12 MHz System Clock
set_property -dict { PACKAGE_PIN M9  IOSTANDARD LVCMOS33 } [get_ports { clk }];        # IO_L13P_T2_MRCC_14 Sch=gclk
create_clock -add -name sys_clk_pin -period 83.33 [get_ports { clk }];

## Push-Buttons
set_property -dict { PACKAGE_PIN D2  IOSTANDARD LVCMOS33 } [get_ports { rst_n }];      # IO_L6P_T0_34 Sch=btn0 (active-low)
set_property -dict { PACKAGE_PIN D1  IOSTANDARD LVCMOS33 } [get_ports { btn1 }];      # IO_L6N_T0_VREF_34 Sch=btn1

## Four User LEDs
set_property -dict { PACKAGE_PIN E2  IOSTANDARD LVCMOS33 } [get_ports { led[0] }];    # IO_L8P_T1_34  Sch=led0
set_property -dict { PACKAGE_PIN K1  IOSTANDARD LVCMOS33 } [get_ports { led[1] }];    # IO_L16P_T2_34 Sch=led1
set_property -dict { PACKAGE_PIN J1  IOSTANDARD LVCMOS33 } [get_ports { led[2] }];    # IO_L16N_T2_34 Sch=led2
set_property -dict { PACKAGE_PIN E1  IOSTANDARD LVCMOS33 } [get_ports { led[3] }];    # IO_L8N_T1_34  Sch=led3

## USB-UART Bridge (FT231X)
set_property -dict { PACKAGE_PIN L12 IOSTANDARD LVCMOS33 } [get_ports { uart_tx }];   # IO_L6N_T0_D08_VREF_14 Sch=uart_tx
set_property -dict { PACKAGE_PIN K15 IOSTANDARD LVCMOS33 } [get_ports { uart_rx }];   # IO_L5N_T0_D07_14 Sch=uart_rx

## Bitstream Configuration
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
## Cmod S7-25 Rev B - top-level XDC for lif_multi project

## 12 MHz System Clock
set_property -dict { PACKAGE_PIN M9  IOSTANDARD LVCMOS33 } [get_ports { clk }];        # IO_L13P_T2_MRCC_14 Sch=gclk
create_clock -add -name sys_clk_pin -period 83.33 [get_ports { clk }];

## Push-Buttons
set_property -dict { PACKAGE_PIN D1  IOSTANDARD LVCMOS33 } [get_ports { rst_n }];      # IO_L6P_T0_34 Sch=btn0 (active-low)
set_property -dict { PACKAGE_PIN D2  IOSTANDARD LVCMOS33 } [get_ports { btn1 }];      # IO_L6N_T0_VREF_34 Sch=btn1

## Four User LEDs
set_property -dict { PACKAGE_PIN E2  IOSTANDARD LVCMOS33 } [get_ports { led[0] }];    # IO_L8P_T1_34  Sch=led0
set_property -dict { PACKAGE_PIN K1  IOSTANDARD LVCMOS33 } [get_ports { led[1] }];    # IO_L16P_T2_34 Sch=led1
set_property -dict { PACKAGE_PIN J1  IOSTANDARD LVCMOS33 } [get_ports { led[2] }];    # IO_L16N_T2_34 Sch=led2
set_property -dict { PACKAGE_PIN E1  IOSTANDARD LVCMOS33 } [get_ports { led[3] }];    # IO_L8N_T1_34  Sch=led3

## USB-UART Bridge (FT231X)
set_property -dict { PACKAGE_PIN L12 IOSTANDARD LVCMOS33 } [get_ports { uart_tx }];   # IO_L6N_T0_D08_VREF_14 Sch=uart_tx
set_property -dict { PACKAGE_PIN K15 IOSTANDARD LVCMOS33 } [get_ports { uart_rx }];   # IO_L5N_T0_D07_14 Sch=uart_rx

## Bitstream Configuration
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
