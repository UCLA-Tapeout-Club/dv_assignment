module sync_1 (
    input logic clk_a,
    input logic clk_b,
    input logic rst_n,
    input logic data_in,
    output logic data_out
);

logic data_stage1;

always_ff @(posedge clk_a or negedge rst_n)begin
    if (!rst_n) begin
        data_stage1 <= 1'b0;
    end else begin
        data_stage1 <= data_in;
    end
end

always_ff @(posedge clk_b or negedge rst_n)begin
    if (!rst_n) begin
        data_out <= 1'b0;
    end else begin
        data_out <= data_stage1;
    end
end

endmodule