`timescale 1ns / 1ps

module Sensor_top(
    input clk,
    input sensor_in,
    output wire [6:0] seg,
    output wire [3:0] an
    );
    
    reg rst_0; 
    reg rst_1; 
    wire [6:0] seg_fire, seg_safe;
    wire [3:0] an_fire, an_safe;
    reg [6:0] seg_mux;
    reg [3:0] an_mux;
    
    Seven_Seg_SAFE SAFE(rst_0, clk, seg_safe, an_safe);
    Seven_Seg_FIRE FIRE(rst_1, clk, seg_fire, an_fire);
    
    always @ (posedge clk) begin
if (sensor_in == 1'b1) begin // Display Done
        rst_1 <= 1'b1;
        seg_mux = seg_fire;
        an_mux = an_fire;
    end
    else begin // Display INSU
        rst_0 <= 1'b1;
        seg_mux = seg_safe;
        an_mux = an_safe;
    end
   end

assign seg = seg_mux;
assign an = an_mux;


  
endmodule
