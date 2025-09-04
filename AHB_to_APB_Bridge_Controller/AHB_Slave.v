module AHB_Slave (
    Hclk, Hresetn, Hwrite, Hreadyin, Htrans, Hresp, Hwdata, Haddr, Prdata, valid, Hwritereg, Hwritereg1, Haddr1, Haddr2, Hwdata1, Hwdata2, temp_selx, Hrdata
);

input Hclk, Hresetn, Hwrite, Hreadyin;
input [1:0] Htrans;
input [31:0] Haddr, Hwdata, Prdata;
output [1:0] Hresp;
output [31:0] Hrdata;
output reg valid, Hwritereg, Hwritereg1;
output reg [31:0] Haddr1, Haddr2, Hwdata1, Hwdata2;
output reg [2:0] temp_selx;

//--------------------------------------------
// Pipeline Logic for the Address
//--------------------------------------------
always @(posedge Hclk) begin
    if (!Hresetn) begin
        Haddr1 <= 0;
        Haddr2 <= 0;
    end else begin
        Haddr1 <= Haddr;
        Haddr2 <= Haddr1;
    end
end

//--------------------------------------------
// Pipeline Logic for the Data
//--------------------------------------------
always @(posedge Hclk) begin
    if (!Hresetn) begin
        Hwdata1 <= 0;
        Hwdata2 <= 0;
    end else begin
        Hwdata1 <= Hwdata;
        Hwdata2 <= Hwdata1;
    end
end

//--------------------------------------------
// Pipeline Logic for the Write Signal
//--------------------------------------------
always @(posedge Hclk) begin
    if (!Hresetn) begin
        Hwritereg <= 0;
        Hwritereg1 <= 0;
    end else begin
        Hwritereg <= Hwrite;
        Hwritereg1 <= Hwritereg;
    end
end

//--------------------------------------------
// Select the Peripheral
//--------------------------------------------
always @(*) begin
    if (Haddr >= 32'h8000_0000 && Haddr < 32'h8400_0000)
        temp_selx = 3'b001;
    else if (Haddr >= 32'h8400_0000 && Haddr < 32'h8800_0000)
        temp_selx = 3'b010;
    else if (Haddr >= 32'h8800_0000 && Haddr < 32'h8C00_0000)
        temp_selx = 3'b100;
    else
        temp_selx = 3'b000;
end

//--------------------------------------------
// Logic for the valid signal
//--------------------------------------------
always @(*) begin
    if ((Haddr >= 32'h8000_0000 && Haddr < 32'h8C00_0000) &&
        (Hreadyin == 1) &&
        (Htrans == 2'b10 || Htrans == 2'b11))
        valid = 1'b1;
    else
        valid = 1'b0;
end

assign Hresp = 2'd0;
assign Hrdata = Prdata;

endmodule
