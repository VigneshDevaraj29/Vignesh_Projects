`timescale 1ns/1ps

module AHB_master_Interface(
    input        Hclk, Hresetn, 
    input  [2:0] Hreadyout,         
    input  [31:0] Hrdata,           
    output reg [31:0] Haddr, Hwdata,
    output reg Hwrite, Hreadyin,
    output reg [1:0] Htrans,
    output reg [2:0] Hburst, 
    output reg [2:0] Hsize   
);

integer i, j;

//------------------------------------
// Single Write Task
//------------------------------------
task single_write();
begin
    @(posedge Hclk);
    #1;
    begin
        Hwrite    = 1;
        Htrans    = 2'd2;
        Hsize     = 0;
        Hburst    = 0;
        Hreadyin  = 1;
        Haddr     = 32'h8000_0001;
    end

    @(posedge Hclk);
    #1;
    begin
        Htrans  = 2'd0;
        Hwdata  = 8'h80;
    end
end
endtask

//------------------------------------
// Single Read Task
//------------------------------------
task single_read();
begin
    @(posedge Hclk);
    begin
        Hwrite    = 0;
        Htrans    = 2'd2;
        Hsize     = 0;
        Hburst    = 0;
        Hreadyin  = 1;
        Haddr     = 32'h8000_0001;
    end

    @(posedge Hclk);
    #1;
    begin
        Htrans = 2'd0;
    end
end
endtask

//------------------------------------
// Burst Write Task
//------------------------------------
task burst_write();
begin
    @(posedge Hclk);
    #1;
    begin
        Hwrite    = 1'b1;
        Htrans    = 2'd2;
        Hsize     = 0;
        Hburst    = 3'd3;
        Hreadyin  = 1;
        Haddr     = 32'h8000_0001;
    end

    @(posedge Hclk);
    #1;
    begin
        Haddr   = Haddr + 1'b1;
        Hwdata  = {$random} % 256;
        Htrans  = 2'd3;
    end

    for (i = 0; i < 2; i = i + 1)
    begin
        @(posedge Hclk);
        #1;
        Haddr   = Haddr + 1;
        Hwdata  = {$random} % 256;
        Htrans  = 2'd3;
    end

    @(posedge Hclk);
    #1;
    begin
        Hwdata = {$random} % 256;
        Htrans = 2'd0;
    end
end
endtask

endmodule
