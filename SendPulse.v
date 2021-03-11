`timescale 1ns / 1ps
module SendPulse(
    input [1:0] mode,
    input clk, reset, start,
    output lightOut,
    output [15:0]stepCount
    //Max Step Count: 7 Seg can only accept up to FFFF
    );
    reg [7:0] beat=0;
    reg [7:0] pulse [13:0];
    reg [8:0]sec;
    wire secondClk;
    clkDivSecond secClock(clk, reset,1, secondClk);
    wire lightClk;
    //No issue with Div by 0
    clkDivSecond ltClock(clk, reset, beat,lightClk);
    
    assign lightOut=lightClk;
    
    reg [15:0] count=0;
    assign stepCount=count;
    
    //Change mode when mode changes
always @(mode) begin
   case(mode)
//Walk
       2'b00: pulse[0]=32;
//Jog
      2'b01: pulse[0]=64;
//Run
       2'b10: pulse[0]=128;
//Hybrid
       2'b11: begin
        pulse[0]=0;
        pulse[1]=20;
        pulse[2]=33;
        pulse[3]=66;
        pulse[4]=27;
        pulse[5]=70;
        pulse[6]=30;
        pulse[7]=19;
        pulse[8]=30;
        pulse[9]=33;
        pulse[10]=69;
        pulse[11]=34;
        pulse[12]=124;
        pulse[13]=0;
        end
     endcase
 end

//No issue with Div by 0        
always @(posedge secondClk) begin
    if(!start) begin sec=0; beat=0; sec=0; end
    else if(reset) sec=0;
    else begin
            sec=sec+1;
        if(pulse[0]==0) begin        
            if ((sec>=1)&&(sec<=9)) beat=pulse[sec];
            else if((sec>=10)&&(sec<=73)) beat=pulse[10];
            else if((sec>=74)&&(sec<=79)) beat=pulse[11];
            else if((sec>=80)&&(sec<=144)) beat=pulse[12];
            else beat=0;
        end
        else beat=pulse[0];
    end   
end

//Light pulse when start is high
always@(posedge lightClk) begin
    if (!start||reset) count=0;
    else begin 
        count=count+1;
    end
end
    
    
endmodule