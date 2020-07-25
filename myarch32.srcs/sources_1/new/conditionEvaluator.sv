module conditionEvaluator(
    input [3:0] condition,
    input [3:0] flags,
    output instructionEnabled
);

assign instructionEnabled = 
    (condition == 'b0000)? 1 : // No condition
    (condition == 'b0001)? flags[3] : // (=)
    (condition == 'b0010)? ~flags[3] : // (!=)

    (condition == 'b1001)? flags[2] : // (u<)
    (condition == 'b1000)? ~flags[2] : // (u>=)
    (condition == 'b1010)? flags[3] | flags[2] : // (u<=)
    (condition == 'b0111)? ~(flags[3] | flags[2]) : // (u>)

    (condition == 'b0101)? flags[1] : // (s<)
    (condition == 'b0100)? ~flags[1] : // (s>=)
    (condition == 'b0110)? flags[3] | flags[1] : // (s<=)
    (condition == 'b0011)? ~(flags[3] | flags[1]) : // (s>)
    0;

endmodule
