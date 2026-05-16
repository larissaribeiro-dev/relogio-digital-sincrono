//-----------------------------------------------------------
// Módulo: relogio
// Descrição: Relógio digital de 24 horas com display de 4
//            dígitos em 7 segmentos e multiplexação automática
//            entre horas/minutos e minutos/segundos
// Autor: Claude (Anthropic)
// Data: 05/04/2026
// Linguagem: Verilog 2001
//-----------------------------------------------------------

module relogio (
    input  wire clk_50mhz, 
    input  wire RST_G,      
    output wire [6:0] seg1,
    output wire [6:0] seg2,
    output wire [6:0] seg3,
    output wire [6:0] seg4
);
    
    wire CLK;
	 wire rst_ativo = ~RST_G;
    
    divisor_frequencia div_clk (
        .clk_50mhz (clk_50mhz),
        .reset     (rst_ativo),
        .clk_1hz   (CLK)
    );
    
    // ==========================================
    // Inicio bloco de contadores
    // ==========================================
    wire [3:0] SU;          
    wire [3:0] SD;         
    wire C_US;     
    wire RST_DS;     
    
    CD4510B U_Sec (
        .CLK   (CLK),
        .RESET (rst_ativo),
        .PE    (1'b0),
        .U_D   (1'b1),
        .CIN   (1'b0),       
        .P     (4'b0000),
        .Q     (SU),
        .COUT  (C_US)
    );
 
    wire R60_S  = SD[1] & SD[2];
    assign RST_DS = rst_ativo | R60_S;
    
    CD4510B D_Sec (
        .CLK   (CLK),
        .RESET (RST_DS),
        .PE    (1'b0),
        .U_D   (1'b1),
        .CIN   (C_US),
        .P     (4'b0000),
        .Q     (SD),
        .COUT  ()            
    );
        
    wire SU9   = SU[0] & SU[3];
    wire SD5   = SD[0] & SD[2];
    wire SEC59 = SU9 & SD5;
    wire CIN_M = ~SEC59;   
 
    wire [3:0] MU;
    wire [3:0] MD;
    wire C_UM;
    wire RST_DM;
 
    CD4510B U_Min (
        .CLK   (CLK),
        .RESET (rst_ativo),
        .PE    (1'b0),
        .U_D   (1'b1),
        .CIN   (CIN_M),
        .P     (4'b0000),
        .Q     (MU),
        .COUT  (C_UM)
    );
 
    wire R60_M  = MD[1] & MD[2];
    assign RST_DM = rst_ativo | R60_M;
 
    CD4510B D_Min (
        .CLK   (CLK),
        .RESET (RST_DM),
        .PE    (1'b0),
        .U_D   (1'b1),
        .CIN   (C_UM),
        .P     (4'b0000),
        .Q     (MD),
        .COUT  ()         
    );
 
    wire MU9   = MU[0] & MU[3];
    wire MD5   = MD[0] & MD[2];
    wire MIN59 = MU9 & MD5;
 
    wire [3:0] HU;
    wire [3:0] HD;
    wire C_UH;
    wire RST_H;
 
    wire HR_EN = SEC59 & MIN59;
    wire CIN_H = ~HR_EN;
    
    CD4510B U_Hr (
        .CLK   (CLK),
        .RESET (RST_H),
        .PE    (1'b0),
        .U_D   (1'b1),
        .CIN   (CIN_H),
        .P     (4'b0000),
        .Q     (HU),
        .COUT  (C_UH)
    );
 
    CD4510B D_Hr (
        .CLK   (CLK),
        .RESET (RST_H),
        .PE    (1'b0),
        .U_D   (1'b1),
        .CIN   (C_UH),
        .P     (4'b0000),
        .Q     (HD),
        .COUT  ()          
    );
 
    wire R24_H  = HD[1] & HU[2];
    assign RST_H = rst_ativo | R24_H;
    
    // ==========================================
    // Fim bloco de contadores
    // ==========================================


    // ==========================================
    // Inicio bloco de Sel e multiplexadores
    // ==========================================
    wire [6:0] cnt_q;  
    wire reset_4024;
	 
	
    // 1. Detecta o número 15 (Binário 1111) -> Todos os 4 bits em '1'
    wire chegou_no_15 = cnt_q[0] & cnt_q[1] & cnt_q[2] & cnt_q[3];
    
    // O contador rápido agora zera se você apertar o botão OU se chegar no 15
    wire reset_contador = rst_ativo | chegou_no_15;

    // 2. Detecta o número 14 (Binário 1110) -> Bits 1, 2 e 3 em '1', e Bit 0 em '0'
    wire enable_14 = ~cnt_q[0] & cnt_q[1] & cnt_q[2] & cnt_q[3];
 
    CD4024B U_4024 (
        .CP (CLK),
        .R  (reset_contador),         
        .Q1 (cnt_q[0]),
        .Q2 (cnt_q[1]),
        .Q3 (cnt_q[2]),
        .Q4 (cnt_q[3]),
        .Q5 (cnt_q[4]),
        .Q6 (cnt_q[5]),
        .Q7 (cnt_q[6])
    );
 	 
    wire SEL, SEL_N;
    
    ffjk FF_SEL (
        .clk   (CLK),
        .clear (RST_G),      
        .J     (enable_14),
        .K     (enable_14),
        .Q     (SEL),
        .NQ    (SEL_N)
    );
    
    wire [3:0] disp1, disp2, disp3, disp4;
 
    mux2_1 #(.WIDTH(4)) MUX1 (.I0(HD), .I1(MD), .S(SEL), .Y(disp1));
    mux2_1 #(.WIDTH(4)) MUX2 (.I0(HU), .I1(MU), .S(SEL), .Y(disp2));
    mux2_1 #(.WIDTH(4)) MUX3 (.I0(MD), .I1(SD), .S(SEL), .Y(disp3));
    mux2_1 #(.WIDTH(4)) MUX4 (.I0(MU), .I1(SU), .S(SEL), .Y(disp4));
    
    // ==========================================
    // Fim bloco de Sel e multiplexadores
    // ==========================================

 
    // ==========================================
    // Inicio bloco de decodificadores
    // ==========================================
    decodificador_7seg Dec1 (
        .A(disp1[3]), .B(disp1[2]), .C(disp1[1]), .D(disp1[0]),
        .Seg_a(seg1[0]), .Seg_b(seg1[1]), .Seg_c(seg1[2]),
        .Seg_d(seg1[3]), .Seg_e(seg1[4]), .Seg_f(seg1[5]),
        .Seg_g(seg1[6])
    );
 
    decodificador_7seg Dec2 (
        .A(disp2[3]), .B(disp2[2]), .C(disp2[1]), .D(disp2[0]),
        .Seg_a(seg2[0]), .Seg_b(seg2[1]), .Seg_c(seg2[2]),
        .Seg_d(seg2[3]), .Seg_e(seg2[4]), .Seg_f(seg2[5]),
        .Seg_g(seg2[6])
    );
 
    decodificador_7seg Dec3 (
        .A(disp3[3]), .B(disp3[2]), .C(disp3[1]), .D(disp3[0]),
        .Seg_a(seg3[0]), .Seg_b(seg3[1]), .Seg_c(seg3[2]),
        .Seg_d(seg3[3]), .Seg_e(seg3[4]), .Seg_f(seg3[5]),
        .Seg_g(seg3[6])
    );
 
    decodificador_7seg Dec4 (
        .A(disp4[3]), .B(disp4[2]), .C(disp4[1]), .D(disp4[0]),
        .Seg_a(seg4[0]), .Seg_b(seg4[1]), .Seg_c(seg4[2]),
        .Seg_d(seg4[3]), .Seg_e(seg4[4]), .Seg_f(seg4[5]),
        .Seg_g(seg4[6])
    );
 
endmodule