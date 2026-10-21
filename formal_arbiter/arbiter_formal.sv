
module arbiter_formal (
    input wire clk
);

    //anyseq is special to Yosys, just lets Yosys know that req can be anything
    (* anyseq *) reg [3:0] req;

    reg rst_n = 1'b0;

    always_ff @(posedge clk) begin
        rst_n <= 1'b1;
    end

    wire [3:0] grant;

    rr_arbiter dut (
        .clk(clk),
        .rst_n(rst_n),
        .req(req),
        .grant(grant)
    );

    
    //Property A: Mutual exclusion
    always @(posedge clk) begin
        if (rst_n) begin
            //TODO: write an assert to detect mutual exclusion
        end
    end

    
    //Property B: Grant validity
    always @(posedge clk) begin
        if (rst_n) begin
            //TODO: write an assert to detect grant validity
            assert ((grant & ~req) == 4'b0000);
        end
    end

    
    //Property C: Bounded fairness
    always @(posedge clk) begin
        if (!rst_n) begin
            //TODO: add code to detect bounded fairness
        end
    end

endmodule
