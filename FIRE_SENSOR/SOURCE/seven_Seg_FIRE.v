`timescale 1ns / 1ps

module Seven_Seg_FIRE(
    input rst_0, // Reset signal for the first digit
    input clk,   // Clock signal
    output reg [6:0] seg,
    output reg [3:0] an
);

reg [1:0] state;
reg [1:0] anode_select;
reg [16:0] anode_timer;
reg [3:0] min_1s  = 4'h0;
reg [3:0] min_10s = 4'h0;
reg [3:0] hr_1s   = 4'h0;
reg [3:0] hr_10s  = 4'h0;
    
always @(negedge clk) begin
    if(rst_0 == 1'b0) begin
        anode_select <= 0;
        anode_timer <= 0; 
    end
    else
        if(anode_timer == 99_999) begin
            anode_timer <= 0;
            anode_select <=  anode_select + 1;
        end
        else
            anode_timer <=  anode_timer + 1;
end

always @(anode_select) begin
    case(anode_select) 
        2'b00 : an = 4'b0111;
        2'b01 : an = 4'b1011;
        2'b10 : an = 4'b1101;
        2'b11 : an = 4'b1110;
    endcase
end

    always @(*)begin
    if(rst_0 == 1'b0) begin
       seg = 7'b1111111;
    end
    else
        case(anode_select)
            2'b00 : begin       // HOURS TENS DIGIT
                        case(hr_10s)
                            4'h0 : seg = 7'b0111000;
                        endcase
                    end
                    
            2'b01 : begin       // HOURS ONES DIGIT
                        case(hr_1s)
                            4'h0 : seg = 7'b1001111;
                        endcase
                    end
                    
            2'b10 : begin       // MINUTES TENS DIGIT
                        case(min_10s)
                            4'h0 : seg = 7'b0001000;
                        endcase
                    end
                    
            2'b11 : begin       // MINUTES ONES DIGIT
                        case(min_1s)
                            4'h0 : seg = 7'b0110000;
                        endcase
                    end
        endcase
end
endmodule
