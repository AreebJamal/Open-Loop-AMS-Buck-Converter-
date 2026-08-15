`timescale 1ns / 1ps
module pwm_tb;
    reg clk , rst ; 
    reg [7:0]duty ;
    wire pwm_out ;

    pwm_gen pwm_dut(
    .clk(clk),
    .rst(rst),
    .duty(duty),
    .pwm_out(pwm_out)
);

    always #5 clk = ~clk;

    initial begin
    
    clk = 0 ;
    $dumpfile("dump.vcd");
    $dumpvars(0, pwm_tb);

    $monitor("time=%d \t duty=%b \t rst=%b \t pwm_out=%b \t " ,$time,duty, rst ,pwm_out);
    
    rst = 0; #20;    // hold reset for 20 time units
    rst = 1;          // release reset, module starts running

    //duty=0;#2565;
    duty=20;#1010;
    duty=40;#1010;
    duty=60;#1010;
    duty=80;#1010;

    #20;

    $finish;
    
    end

endmodule


