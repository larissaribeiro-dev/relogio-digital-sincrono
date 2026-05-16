/******************************************************************
 * Autor: Gemini (IA do Google)
 * Data: 05 de abril de 2026
 * Descrição: Multiplexador 2 para 1 parametrizável. Recebe duas
 * entradas de dados (I0 e I1) e um sinal de seleção (S). 
 * Se S for 1, a saída Y recebe I1. Se S for 0, a saída Y recebe I0.
 * A largura do barramento é configurável via parâmetro WIDTH.
 ******************************************************************/

module mux2_1 #(parameter WIDTH = 8)(
    input  wire [WIDTH-1:0] I0,
    input  wire [WIDTH-1:0] I1, 
    input  wire S,  
    output wire [WIDTH-1:0] Y  
);
    assign Y = S ? I1 : I0;

endmodule