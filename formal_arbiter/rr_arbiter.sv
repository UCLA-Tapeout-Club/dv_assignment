module rr_arbiter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [3:0] req,
    output wire [3:0] grant
);
    reg [3:0] mask;

    wire [3:0] masked_req;
    wire [3:0] masked_grant;
    wire [3:0] unmasked_grant;

    assign masked_req = req & mask;
    assign masked_grant = masked_req & ~(masked_req + 4'b1);
    assign unmasked_grant = req & (~req + 4'b1);
    assign grant = (|masked_req) ? masked_grant : (unmasked_grant | masked_grant);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mask <= 4'b0000;
        end else if (|grant) begin
            mask <= ~(grant -4'b0001);
        end
    end


    

      
  

endmodule