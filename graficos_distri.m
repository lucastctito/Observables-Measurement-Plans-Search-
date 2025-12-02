function graficos_distri(alpha_a_priori,beta_a_priori,alpha_posteriori,beta_posteriori,media_posteriori)
% Defina o nível de confiança desejado (por exemplo, 95%)
confianca = 0.95;

% Calcule os quantis da distribuição Beta posteriori
quantil_inferior = betainv((1 - confianca) / 2, alpha_posteriori, beta_posteriori)
quantil_superior = betainv(1 - (1 - confianca) / 2, alpha_posteriori, beta_posteriori)

% Crie um vetor de valores para o eixo x
x = linspace(0.98, 1, 1000);

% Calcule as PDFs das distribuições Beta a priori e posteriori
%pdf_priori = betapdf(x, alpha_a_priori, beta_a_priori);  % Adicionado
pdf_posteriori = betapdf(x, alpha_posteriori, beta_posteriori);

% Crie o gráfico das PDFs
figure;
%plot(x, pdf_priori, 'g', 'LineWidth', 2, 'DisplayName', 'Priori');  % Adicionado
%hold on;
plot(x, pdf_posteriori, 'b', 'LineWidth', 2, 'DisplayName', 'Posteriori');
hold on
plot([quantil_inferior, quantil_inferior], [0, betapdf(quantil_inferior, alpha_posteriori, beta_posteriori)], 'r--', 'LineWidth', 2, 'DisplayName', 'Quantil Inferior');
hold on
plot([quantil_superior, quantil_superior], [0, betapdf(quantil_superior, alpha_posteriori, beta_posteriori)], 'r--', 'LineWidth', 2, 'DisplayName', 'Quantil Superior');
hold on
scatter(media_posteriori, betapdf(media_posteriori, alpha_posteriori, beta_posteriori), 100, 'k', 'filled', 'DisplayName', 'Ponto Específico');
hold on
plot([media_posteriori, media_posteriori], [1e-5, betapdf(media_posteriori, alpha_posteriori, beta_posteriori)], 'k--', 'LineWidth', 1, 'DisplayName', 'Linha Tracejada');
% Ajuste dinâmico da escala dos eixos
%axis(0.8, 1, 0, max(pdf_posteriori)*1.1);

title('Distribuição Beta Priori e Posteriori com Intervalo de Confiança');
% ...
end

