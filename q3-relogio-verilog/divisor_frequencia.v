/******************************************************************
 * Autor: Gemini (IA do Google)
 * Data: 05 de abril de 2026
 * Descrição: Divisor de frequência. Recebe um sinal de clock de 
 * entrada de 50 MHz e gera um sinal de clock de saída 
 * de 1 Hz (duty cycle de 50%).
 ******************************************************************/
 
 
module divisor_frequencia #(parameter MAX = 24999999) (
    input clk_50mhz,
    input reset,
    output reg clk_1hz
);
    reg [24:0] contador;

    always @(posedge clk_50mhz or posedge reset) begin
        if (reset) begin
            contador <= 0;
            clk_1hz <= 0;
        end else if (contador == MAX) begin
            contador <= 0;
            clk_1hz <= ~clk_1hz;
        end else begin
            contador <= contador + 1'b1;
        end
    end
endmodule