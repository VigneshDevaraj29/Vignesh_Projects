module ComfortControl (
    input clk,
    input reset,
    input [6:0] temp_sens,
    input [8:0] lume_sens,
    input motion_sens,
    output reg heater,
    output reg ac,
    output reg bright_light,
    output reg dim_light,
    output reg normal_light
);

    parameter 	TEMP_RESET = 2'b00, 
				TEMP_HEAT = 2'b01, 
				TEMP_COOL = 2'b10, 
				TEMP_NORMAL = 2'b11;
    
	parameter 	LUME_RESET = 2'b00, 
				LUME_BRIGHT = 2'b01, 
				LUME_DIM = 2'b10, 
				LUME_NORMAL = 2'b11;

    reg [1:0] temp_state, next_temp_state;
    reg [1:0] lume_state, next_lume_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            temp_state <= TEMP_RESET;
        else
            temp_state <= next_temp_state;
    end

    always @(*) begin
        case (temp_state)
            TEMP_RESET:
                if (motion_sens)
                    next_temp_state = (temp_sens < 15) ? TEMP_HEAT :
                                      (temp_sens > 28) ? TEMP_COOL : TEMP_NORMAL;
                else
                    next_temp_state = TEMP_RESET;
            TEMP_HEAT:
                next_temp_state = (temp_sens >= 15) ?
                                  ((temp_sens > 28) ? TEMP_COOL : TEMP_NORMAL) : TEMP_HEAT;
            TEMP_COOL:
                next_temp_state = (temp_sens <= 28) ?
                                  ((temp_sens < 15) ? TEMP_HEAT : TEMP_NORMAL) : TEMP_COOL;
            TEMP_NORMAL:
                next_temp_state = (temp_sens < 15) ? TEMP_HEAT :
                                  (temp_sens > 28) ? TEMP_COOL : TEMP_NORMAL;
            default:
                next_temp_state = TEMP_RESET;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            heater <= 0;
            ac <= 0;
        end else begin
            case (temp_state)
                TEMP_HEAT: begin
                    heater <= 1;
                    ac <= 0;
                end
                TEMP_COOL: begin
                    heater <= 0;
                    ac <= 1;
                end
                TEMP_NORMAL: begin
                    heater <= 0;
                    ac <= 0;
                end
            endcase
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            lume_state <= LUME_RESET;
        else
            lume_state <= next_lume_state;
    end

    always @(*) begin
        case (lume_state)
            LUME_RESET:
                if (motion_sens)
                    next_lume_state = (lume_sens < 200) ? LUME_BRIGHT :
                                      (lume_sens > 250) ? LUME_DIM : LUME_NORMAL;
                else
                    next_lume_state = LUME_RESET;
            LUME_BRIGHT:
                next_lume_state = (lume_sens >= 200) ?
                                  ((lume_sens > 250) ? LUME_DIM : LUME_NORMAL) : LUME_BRIGHT;
            LUME_DIM:
                next_lume_state = (lume_sens <= 250) ?
                                  ((lume_sens < 200) ? LUME_BRIGHT : LUME_NORMAL) : LUME_DIM;
            LUME_NORMAL:
                next_lume_state = (lume_sens < 200) ? LUME_BRIGHT :
                                  (lume_sens > 250) ? LUME_DIM : LUME_NORMAL;
            default:
                next_lume_state = LUME_RESET;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bright_light <= 0;
            dim_light <= 0;
            normal_light <= 0;
        end else begin
            case (lume_state)
                LUME_BRIGHT: begin
                    bright_light <= 1;
                    dim_light <= 0;
                    normal_light <= 0;
                end
                LUME_DIM: begin
                    bright_light <= 0;
                    dim_light <= 1;
                    normal_light <= 0;
                end
                LUME_NORMAL: begin
                    bright_light <= 0;
                    dim_light <= 0;
                    normal_light <= 1;
                end
            endcase
        end
    end

endmodule