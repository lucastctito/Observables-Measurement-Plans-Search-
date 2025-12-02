function [matriz_diversidade] = calculo_similaridade(planos_totais)

% Vetor de consulta (query)
query = planos_totais(1,:);


% Tamanho da matriz
[num_linhas, ~] = size(planos_totais);

% Inicializar uma matriz para armazenar as similaridades
similaridades = zeros(num_linhas, 1);
matriz_diversidade = zeros(num_linhas,7);

% Loop para calcular as similaridades iterativas
for i = 1:num_linhas
    % Calcular a, b, c, e d para a comparação entre a query e a i-ésima linha da matriz
    a = sum(query & planos_totais(i, :));
    b = sum((query == 0) & (planos_totais(i, :) == 1));
    c = sum((query == 1) & (planos_totais(i, :) == 0));
    d = sum((query == 0) & (planos_totais(i, :) == 0));
    
    % Calcular a similaridade de Jaccard
    dissimilaridade_jaccard = 1 - (a / (a + b + c));
    distancia_hamming = b + c;
    distancia_nova = (b+c)/(a+b+c+d);
    
    % Armazenar a similaridade na matriz de resultados
    matriz_diversidade(i,1) = a;
    matriz_diversidade(i,2) = b;
    matriz_diversidade(i,3) = c;
    matriz_diversidade(i,4) = d;
    matriz_diversidade(i,5) = distancia_hamming;
    matriz_diversidade(i,6) = dissimilaridade_jaccard;
    matriz_diversidade(i,7) = distancia_nova;
    
end

end

