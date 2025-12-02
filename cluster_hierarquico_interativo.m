function [matriz_cluster_selecionado] = cluster_hierarquico_interativo(planos_totais, numero_inicial, UMs_trocadas)

matriz = planos_totais;
[num_linhas, ~] = size(matriz);

% Calcular a matriz de distâncias
distancia_max = 2 * numero_inicial + 2;
distancia = zeros(num_linhas, num_linhas);

for i = 1:num_linhas
    for j = 1:num_linhas
        query = matriz(i,:);
        b = sum((query == 0) & (matriz(j, :) == 1));
        c = sum((query == 1) & (matriz(j, :) == 0));
        distancia_hamming = 1 - (b + c) / distancia_max;
        distancia_hamming = b + c;  % distância de Hamming direta
    end
end

for i = 1:num_linhas
    distancia(i, i) = 0;
end



% Realizar o agrupamento hierárquico
Z = linkage(squareform(distancia), 'complete');
altura_corte = (1 - (UMs_trocadas * 2) / distancia_max) + ...
               0.05 * (1 - (UMs_trocadas * 2) / distancia_max);

clusters = cluster(Z, 'cutoff', altura_corte, 'criterion', 'distance');

% Identificar os clusters e suas quantidades
num_clusters = max(clusters);
disp('Clusters encontrados e suas respectivas quantidades de elementos:');
for i = 1:num_clusters
    indices_cluster = find(clusters == i);
    fprintf('Cluster %d: %d elementos\n', i, numel(indices_cluster));
end

% Solicitar entrada do usuário
cluster_selecionado = input('Digite o número do cluster que deseja selecionar: ');

% Validar entrada do usuário
if cluster_selecionado < 1 || cluster_selecionado > num_clusters
    disp('Número de cluster inválido.');
    matriz_cluster_selecionado = [];
    return;
end

% Retornar os vetores do cluster selecionado
indices_cluster_selecionado = find(clusters == cluster_selecionado);
matriz_cluster_selecionado = matriz(indices_cluster_selecionado, :);

% Exibir o cluster selecionado
disp('Cluster selecionado e seus vetores:');
disp(matriz_cluster_selecionado);

end