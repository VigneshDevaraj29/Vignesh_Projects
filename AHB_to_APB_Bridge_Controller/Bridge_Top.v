module Bridge_Top(input Hclk, Hresetn, Hwrite, Hreadyin,
                  input [31:0] Hwdata, Haddr, Prdata,
                  input [1:0] Htrans,
                  output Pwrite, Penable, 
				  output [2:0] Pselx,
				  output [2:0] Hreadyout,
				  output [31:0] Pwdata, Paddr,
                  output [31:0] Hrdata);

						wire valid;
						wire [31:0] Hwdata1, Hwdata2, Haddr1, Haddr2;
						wire [2:0] temp_selx;
						wire [1:0] Hresp;

    AHB_Slave ahb_S(Hclk, Hresetn, Hwrite, Hreadyin, Htrans, Hresp, Hwdata, Haddr, Prdata, valid, Hwritereg, Hwritereg1, Haddr1, Haddr2, Hwdata1, Hwdata2, temp_selx, Hrdata);

    APB_Controller apb_c(Hclk, Hresetn, Hwrite, Hwritereg, valid, Haddr, Haddr1, Haddr2, Hwdata, Hwdata1, Hwdata2, Prdata, temp_selx, Penable, Pwrite, Hreadyout, Paddr, Pwdata, Pselx);
endmodule
