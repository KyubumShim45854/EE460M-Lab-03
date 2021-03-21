`timescale 1ns / 1ps
//100MHz-> 100 000 000
//Div 2 ->  50 000 000
module clkDivSecond(
    input clk,reset,// start,
    input [7:0]div,
    output slow_clk
    );
    
    reg [63:0] count; //10111110101111000010000000
    reg outSig =1;
    assign slow_clk=outSig;   
    initial  count = 0;
    
    always @ (posedge clk) begin
       if(div)begin
           if (reset) begin 
            count<=0;
            outSig=1;
           end  
           //26'b10111110101111000010000000
          /* else */ // removed
          if(count>=((50_000_000)/(div)))begin
           //else if(count>=((5000000)/div))begin
                outSig=outSig^1;
                count=0;
            end
            else count=(count+1);
        end
        else outSig=0;
    end
endmodule