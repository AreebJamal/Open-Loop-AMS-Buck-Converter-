module deadtime(pwm_high , pwm_low , clk , rst , master_pwm , deadtime);
       input clk , rst , master_pwm ;
       input [7:0]deadtime ;
       output reg pwm_high , pwm_low ;

       localparam state_low_on = 2'b00 ;
       localparam state_deadtime_rise = 2'b01 ;
       localparam state_high_on = 2'b10 ;
       localparam state_deadtime_fall = 2'b11 ;

       reg [1:0]current_state ;
       reg [7:0]count ;

       always @(posedge clk , negedge rst) begin
        if (!rst) begin
            pwm_low <=0 ;
            pwm_high <=0;
            count <=0 ;
            current_state <= state_low_on ;
        end 
        else begin
           if(current_state==state_low_on) begin
                pwm_low <= 1;
                pwm_high <=0;
                count <=0;
                if (master_pwm) begin
                    current_state <= state_deadtime_rise ;
                end    
            end
            
            if(current_state==state_deadtime_rise) begin
                pwm_low <=0;
                pwm_high <=0;
                if(count<deadtime) begin
                    count <= count+1 ;
                end
                else
                    current_state<=state_high_on ;
            end

            if(current_state==state_high_on) begin
                pwm_low <=0;
                pwm_high <=1;
                count <=0 ;
                if (!master_pwm) begin
                    current_state <= state_deadtime_fall ;
                end  
                
            end
            if (current_state == state_deadtime_fall) begin
                pwm_low <=0;
                pwm_high <=0;
                if(count<deadtime) begin
                    count <= count+1 ;
                end
                else
                    current_state<=state_low_on ;

            end 
        end
            
    end

endmodule

