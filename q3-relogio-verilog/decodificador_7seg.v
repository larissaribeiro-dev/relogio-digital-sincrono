/******************************************************************
 * Autor: Gemini (IA do Google)
 * Data: 05 de abril de 2026
 * Descrição: Decodificador de binário (4 bits) para display de 
 * 7 segmentos. Recebe uma entrada de 4 bits (A, B, C, D) e 
 * gera os sinais correspondentes para acionar os segmentos 
 * de 'a' a 'g' do display através de portas lógicas.
 ******************************************************************/



module decodificador_7seg (
    input wire A,
    input wire B,
    input wire C,
    input wire D,
    output wire Seg_a,
    output wire Seg_b,
    output wire Seg_c,
    output wire Seg_d,
    output wire Seg_e,
    output wire Seg_f,
    output wire Seg_g
);

    wire not_A = ~A;
    wire not_B = ~B;
    wire not_C = ~C;
    wire not_D = ~D;

    wire and_B_D       = B & D;
    wire and_notB_notD = not_B & not_D;
    wire and_C_D       = C & D;
    wire and_notC_notD = not_C & not_D;
    wire and_C_notD    = C & not_D;
    wire and_B_notC    = B & not_C;
    wire and_B_notD    = B & not_D;
    wire and_notB_C    = not_B & C;
    wire and_B_notC_D  = B & not_C & D;

    wire or_parcial_Seg_d = A | and_C_notD | and_notB_notD | and_notB_C;

    
    assign Seg_a = ~(and_B_D | and_notB_notD | A | C);
    assign Seg_b = ~(and_C_D | and_notC_notD | not_B);
    assign Seg_c = ~(B | not_C | D);
    assign Seg_d = ~(or_parcial_Seg_d | and_B_notC_D);
    assign Seg_e = ~(and_notB_notD | and_C_notD);
    assign Seg_f = ~(A | and_B_notD | and_B_notC | and_notC_notD);
    assign Seg_g = ~(and_notB_C | A | and_B_notC | and_C_notD);

endmodule