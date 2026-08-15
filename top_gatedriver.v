module top_gatedriver(finalpwm_high , finalpwm_low , clk , rst , deadtime_value , duty_cycle , enable , fault_in , rst_fault );
    input clk , rst ;
    input [7:0]deadtime_value ;
    input [7:0]duty_cycle ;

    input enable , fault_in , rst_fault ;

    output finalpwm_low ;
    output finalpwm_high ;

    wire finalmaster_pwm ;
    wire wirepwm_high ;
    wire wirepwm_low ;

    reg fault_state ;

    always @(posedge clk , negedge rst) begin
        if(!rst) begin
            fault_state <= 1'b0 ;  
        end
        else if (rst_fault==1'b1) begin
            fault_state <= 1'b0 ;
        end         
        else if (fault_in==1'b1) begin
            fault_state <= 1'b1 ;
        end
    end   


    pwm_gen  master_pwm_gen (
        .clk(clk),
        .rst(rst),
        .duty(duty_cycle),
        .pwm_out(finalmaster_pwm)
    );

    deadtime deadtime_gen (
        .clk(clk),
        .rst(rst),
        .deadtime(deadtime_value),
        .master_pwm(finalmaster_pwm),
        .pwm_high(wirepwm_high),
        .pwm_low(wirepwm_low)
    );

    assign finalpwm_high = wirepwm_high & enable & (~fault_state) ;
    assign finalpwm_low  = wirepwm_low  & enable & (~fault_state) ;


endmodule 

