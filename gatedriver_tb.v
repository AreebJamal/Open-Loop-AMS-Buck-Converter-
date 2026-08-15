`timescale 1ns / 1ps
module gatedriver_tb;
    reg clk , rst ;
    reg [7:0] deadtime ;
    reg [7:0] duty ;
    reg enable ;
    reg rst_fault ;
    reg fault_in ;

    wire finalpwm_high ;
    wire finalpwm_low ;

    top_gatedriver gate_dut(
    .clk(clk),
    .rst(rst),
    .deadtime_value(deadtime),
    .duty_cycle(duty),
    .finalpwm_high(finalpwm_high),
    .finalpwm_low(finalpwm_low),
    .enable(enable),
    .fault_in(fault_in),
    .rst_fault(rst_fault)
    );

    always #5 clk = ~clk;

    initial begin
    
    clk = 0 ;
    $dumpfile("dump.vcd");
    $dumpvars(0, gatedriver_tb);

    $monitor("time=%d \t rst=%b \t duty=%b \t deadtime=%b \t enable=%b \t fault_in=%b \t rst_fault=%b \t finalpwm_high=%b \t finalpwm_low=%b \t " ,$time, rst ,duty , deadtime ,enable , fault_in , rst_fault, finalpwm_high , finalpwm_low);

   /* enable=0; fault_in=0; rst_fault=0; duty=0; deadtime=0;
    rst = 0; #20;    // hold reset for 20 time units
    rst = 1;

    duty=20; deadtime=10; enable=1; #3000;
    duty=40; deadtime=10; enable=0; #3000;
    duty=60; deadtime=20; enable=1; #3000;
    duty=60; deadtime=20; enable=1; fault_in=1; #3000;
    duty=60; deadtime=20; enable=1; fault_in=0; #3000;
    duty=80; deadtime=20; enable=1; rst_fault=1; #3000;
    duty=80; deadtime=20; enable=1; rst_fault=0; #3000;
    */
   enable=0; fault_in=0; rst_fault=0; duty=0; deadtime=0;
    rst = 0; #20;    
    rst = 1;

    // Low Voltage 
    duty = 20;       
    deadtime = 10;   
    enable = 1; 
    #20000;             

    // High Voltage 
    duty = 70;       
    #25000;             

    $finish;
    end
    
    integer filepwm_high , filepwm_low ;

    initial begin
        filepwm_high = $fopen("pwm_high.txt" , "w");
        filepwm_low  = $fopen("pwm_low.txt"  , "w");

        $fdisplay(filepwm_high , "0.0000000 0");
        $fdisplay(filepwm_low  , "0.0000000 0");
    end
    
    always @(finalpwm_high) begin
        if ($time > 0) begin
            $fdisplay(filepwm_high , "%e %d" , ($time - 1)*1e-9 , finalpwm_high?0:5);
            $fdisplay(filepwm_high , "%e %d" , ($time)*1e-9 , finalpwm_high?5:0);
        end
    end

    always @(finalpwm_low) begin
        if ($time > 0) begin
            $fdisplay(filepwm_low , "%e %d" , ($time - 1)*1e-9 , finalpwm_low?0:5);
            $fdisplay(filepwm_low , "%e %d" , ($time)*1e-9 , finalpwm_low?5:0);
        end
    end
// iverilog -o output.sim gatedriver_tb.v top_gatedriver.v pwm_gen.v deadtime.v
    
endmodule
