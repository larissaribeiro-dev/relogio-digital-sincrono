/******************************************************************
 * Autor: Gemini (IA do Google)
 * Data: 05 de abril de 2026
 * Descrição: Contador BCD (0 a 9) crescente e decrescente, 
 * modelado com base no comportamento do CI CD4510B. 
 * Possui reset assíncrono (RESET), carga paralela assíncrona 
 * (PE, que carrega o valor de P em Q), controle de direção 
 * (U_D: 1=crescente, 0=decrescente) e habilitação (CIN, ativo em 
 * nível baixo). Inclui também a saída de cascateamento (COUT).
 ******************************************************************/

module CD4510B (
    input  wire CLK,           
    input  wire RESET,         
    input  wire PE,  
    input  wire U_D,        
    input  wire CIN,     
    input  wire [3:0] P,             
    output reg  [3:0] Q,             
    output wire COUT     
);

    always @(posedge CLK or posedge RESET or posedge PE) begin
        if (RESET)
            Q <= 4'd0;
        else if (PE)
            Q <= P;
        else if (!CIN) begin
            if (U_D)
                Q <= (Q >= 4'd9) ? 4'd0 : Q + 4'd1;  
            else
                Q <= (Q == 4'd0) ? 4'd9 : Q - 4'd1;  
        end
    end

    assign COUT = ~( !CIN && ((U_D  && Q == 4'd9) || (!U_D && Q == 4'd0)) );

endmodule