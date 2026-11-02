//-----------------------------------------------------------
// Módulo: ffjk
// Descrição: Flip-Flop JK com reset assíncrono ativo em baixo
// Autor: Claude (Anthropic)
// Data: 05/04/2026
// Linguagem: Verilog 2001
//-----------------------------------------------------------


module ffjk (
    input  wire J,
    input  wire K,
    input  wire clk,
    input  wire clear,    
    output reg  Q,
    output wire NQ        
);
    assign NQ = ~Q;

    always @(posedge clk or negedge clear) begin
        if (!clear)
            Q <= 1'b0;
        else
            case ({J, K})
                2'b00: Q <= Q;
                2'b01: Q <= 1'b0;
                2'b10: Q <= 1'b1;
                2'b11: Q <= ~Q;
            endcase
    end
endmodule