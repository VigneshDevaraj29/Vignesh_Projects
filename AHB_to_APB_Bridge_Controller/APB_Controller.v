module APB_Controller 
(					
    input  valid, Hwritereg, Hclk, Hresetn, Hwrite,
    input [31:0] Haddr1, Haddr2, Hwdata1, Hwdata2, Haddr, Hwdata, Prdata,
    input  [2:0] temp_selx,
    output reg Pwrite, Penable, 
    output reg [2:0] Pselx,
	output reg [2:0] Hreadyout,
    output reg [31:0] Pwdata, Paddr

 );
    // State encoding
    parameter ST_IDLE     = 3'b000,
              ST_WAIT     = 3'b001,
              ST_WRITE    = 3'b010,
              ST_WRITEP   = 3'b011,
              ST_WENABLEP = 3'b100,
              ST_WENABLE  = 3'b101,
              ST_READ     = 3'b110,
              ST_RENABLE  = 3'b111;

    reg [2:0] present_state, next_state;

    // Present state (sequential)
    always @(posedge Hclk) begin
        if (!Hresetn)
            present_state <= ST_IDLE;
        else
            present_state <= next_state;
    end

    // Next state (combinational)
    always @(*) begin
        case (present_state)
            ST_IDLE: begin
                if (valid && Hwrite)
                    next_state = ST_WAIT;
                else if (valid && !Hwrite)
                    next_state = ST_READ;
                else
                    next_state = ST_IDLE;
            end

            ST_WAIT: begin
                if (valid)
                    next_state = ST_WRITEP;
                else
                    next_state = ST_WRITE;
            end

            ST_WRITEP:   next_state = ST_WENABLEP;
            ST_WRITE:    next_state = (valid) ? ST_WENABLEP : ST_WENABLE;

            ST_WENABLEP: begin
                if (valid && Hwritereg)
                    next_state = ST_WRITEP;
                else if (!Hwritereg)
                    next_state = ST_READ;
                else if (!valid)
                    next_state = ST_WRITE;
                else
                    next_state = ST_WENABLEP;
            end

            ST_WENABLE: begin
                if (valid && !Hwrite)
                    next_state = ST_READ;
                else if (!valid)
                    next_state = ST_IDLE;
                else
                    next_state = ST_WENABLE;
            end

            ST_READ:     next_state = ST_RENABLE;

            ST_RENABLE: begin
                if (valid && !Hwrite)
                    next_state = ST_READ;
                else if (valid && Hwrite)
                    next_state = ST_WAIT;
                else if (!valid)
                    next_state = ST_IDLE;
                else
                    next_state = ST_RENABLE;
            end

            default: next_state = ST_IDLE;
        endcase
    end

        // Temporary output logic (combinational)
    reg        Penable_temp, Pwrite_temp, Hreadyout_temp;
    reg [2:0]  Pselx_temp;
    reg [31:0] Paddr_temp, Pwdata_temp;

    always @(*) begin
        
        case (present_state)
		ST_IDLE: 
			begin
				if(valid && !Hwrite)
					begin
						Paddr_temp=Haddr;
						Pwrite_temp=Hwrite;
						Pselx_temp=temp_selx;
						Penable_temp=0;
						Hreadyout_temp=0;
					end
				else if(valid && Hwrite)
					begin
						Pselx_temp=0;
						Penable_temp=0;
						Hreadyout_temp=1;
					end
				else
					begin
						Pselx_temp=0;
						Penable_temp=0;
						Hreadyout_temp=1;
					end
			end
		
		ST_READ: 
			begin
                Penable_temp   = 1;
                Hreadyout_temp = 1;
            end
		
		ST_RENABLE: 
			begin
				if(valid && !Hwrite)
					begin
						Paddr_temp=Haddr;
						Pwrite_temp=Hwrite;
						Pselx_temp=temp_selx;
						Penable_temp=0;
						Hreadyout_temp=0;
					end
				else if(valid && Hwrite)
					begin
						Pselx_temp=0;
						Penable_temp=0;
						Hreadyout_temp=1;
					end
				else
					begin
						Pselx_temp=0;
						Penable_temp=0;
						Hreadyout_temp=1;
					end
			end
		
		ST_WAIT:
			begin
				if(valid)
					begin
						Paddr_temp=Haddr1;
						Pwdata_temp=Hwdata;
						Pwrite_temp=Hwrite;
						Pselx_temp=temp_selx;
						Penable_temp=0;
						Hreadyout_temp=0;
					end
				else
					begin
						Paddr_temp=Haddr;
						Pwdata_temp=Hwdata;
						Pwrite_temp=Hwrite;
						Hreadyout_temp=0;
					end
			end	
		ST_WRITE: 
			begin
				Penable_temp   = 1;
				Hreadyout_temp = 1;
			end
		ST_WENABLE: 
			begin
				if (valid && !Hwrite) begin
					Pselx_temp       = 0;
					Penable_temp     = 0;
					Hreadyout_temp   = 1;
				end else if (valid && Hwrite) begin
					Paddr_temp       = Haddr1;
					Pwrite_temp      = Hwritereg;
					Pselx_temp       = temp_selx;
					Penable_temp     = 0;
					Hreadyout_temp   = 0;
				end else begin
					Pselx_temp=0;
					Penable_temp=0;
					Hreadyout_temp=1;
				end
			end
		

		ST_WRITEP: 
			begin
				Penable_temp   = 1;
				Hreadyout_temp = 1;
			end

	   
		
		ST_WENABLEP: 
			begin
				Paddr_temp     = Haddr1;
				Pwdata_temp    = Hwdata;
				Pwrite_temp    = Hwrite;
				Pselx_temp     = temp_selx;
				Penable_temp   = 0;
				Hreadyout_temp = 0;
			end

        endcase
    end


    // Output logic (sequential)
    always @(posedge Hclk) begin
        if (!Hresetn) begin
            Pselx     <= 0;
            Penable   <= 0;
            Pwrite    <= 0;
            Hreadyout <= 1;
            Paddr     <= 0;
            Pwdata    <= 0;
        end 
		else 
			begin
				Pselx     <= Pselx_temp;
				Penable   <= Penable_temp;
				Pwrite    <= Pwrite_temp;
				Hreadyout <= Hreadyout_temp;
				Paddr     <= Paddr_temp;
				Pwdata    <= Pwdata_temp;
			end
    end
endmodule
