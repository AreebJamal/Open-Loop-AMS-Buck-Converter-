module pwm_gen(pwm_out , clk , rst , duty);
      parameter period = 100 ;
      
      input clk , rst ;
      input [7:0] duty ;
      output reg pwm_out ;

      reg [7:0]count ;
      reg [7:0]duty_reg ;
      
      always @(posedge clk , negedge rst) begin
           
      if(!rst) begin
         count <= 0 ;
         pwm_out <= 0 ;
         duty_reg <=0 ;

      end else begin
          if(count<period)
            count <= count+1 ;
          else begin
            count <=0 ;
            duty_reg <= duty ;
      
          end
             
         pwm_out <= (count<duty_reg)?1:0 ;

      end

   end

endmodule

