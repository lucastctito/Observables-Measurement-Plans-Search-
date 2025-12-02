function [matriz_clusters_max] = cluster_hierarquico_maximo(planos_totais,numero_inicial,UMs_trocadas,clusters_desejado,planos_desejados)

matriz = planos_totais;

[num_linhas, ~] = size(matriz);
distancia = [];
matriz_nova = [];

num_linhas = size(matriz, 1);
distancia = zeros(num_linhas, num_linhas);
matriz_nova = zeros(num_linhas * num_linhas, size(matriz, 2)); % pré-alocação

distancia_max = 2*numero_inicial + 2;

for i = 1:num_linhas
    for j = 1:num_linhas
        query = matriz(i,:);
        b = sum((query == 0) & (matriz(j, :) == 1));
        c = sum((query == 1) & (matriz(j, :) == 0));
        distancia_hamming = 1 - (b + c)/distancia_max;
        %distancia_hamming = b + c;
        %distancia_hamming = 1 - (distancia_hamming-media)/desviopadrao;
        distancia(i, j) = distancia_hamming;
        matriz_nova((i-1)*num_linhas+j, :) = matriz(j,:);
    end
end

for i =1:num_linhas
    distancia(i,i) = 0;
end

% Calcular as ligações hierárquicas usando a distância de Hamming
Z = linkage(squareform(distancia), 'complete'); % 'average' é o método de ligação

distancia_hamming = (1 - (UMs_trocadas*2)/distancia_max);
distancia_hamming = (1 - (UMs_trocadas*2)/distancia_max) + 0.05*distancia_hamming;

altura_corte = distancia_hamming;

% Use a função cluster para obter os clusters para a altura de corte especificada
clusters = cluster(Z, 'cutoff', altura_corte, 'criterion', 'distance');

% Visualize o dendrograma com o corte
% Plotar o dendrograma
%figure
%dendrogram(Z, 0, 'ColorThreshold', 10); % Ajuste o limite de cor conforme necessário
%hold on;
%line([0,max(get(gca,'XLim'))],[altura_corte,altura_corte],'Color','r','LineStyle','--');
%xlabel('Índices dos pares');
%ylabel('Distância de Hamming');
%title('Dendrograma de Clustering Hierárquico');

[num_vetores, dimensao] = size(matriz);
nova_matriz_vetores = []; % Inicializa a nova matriz de vetores vazia

num_clusters = max(clusters);

clusters_e_vetores = cell(1, num_clusters);
cont_cluster = 0;

for i = 1:num_clusters
    % Encontre os índices dos vetores binários no cluster atual
    indices_cluster_atual = find(clusters == i);
    % Verifique se o tamanho do cluster é maior que 1
    if numel(indices_cluster_atual) > 1
        
        cont_cluster = cont_cluster + 1;
        
        % Se o tamanho do cluster for maior que 1, salve os vetores na célula
        vetores_cluster_atual = matriz(indices_cluster_atual, :);
        % Armazene os vetores do cluster atual na célula junto com o número do cluster
        clusters_e_vetores{i} = struct('cluster', i, 'vetores', vetores_cluster_atual);
        
        % Adicione os vetores do cluster atual à nova matriz de vetores
        nova_matriz_vetores = [nova_matriz_vetores; vetores_cluster_atual];
        
        % Imprime as informações do cluster
        %fprintf('Cluster %d - Vetores (Índices): ', i);
        %disp(indices_cluster_atual);
        %fprintf('Cluster %d - Vetores Binários:\n', i);
        %disp(vetores_cluster_atual);
    end
end

% Inicializa uma variável para armazenar o tamanho do maior cluster e seu índice
tamanho_maior_cluster = 0;
indice_maior_cluster = 0;

% Analisa os clusters para encontrar o de maior tamanho
for i = 1:num_clusters
    indices_cluster_atual = find(clusters == i);
    tamanho_atual = numel(indices_cluster_atual);
    if tamanho_atual > tamanho_maior_cluster
        tamanho_maior_cluster = tamanho_atual;
        indice_maior_cluster = i;
    end
end

% Inicializa a matriz para os vetores do maior cluster
matriz_clusters_max = [];

% Inicializa um contador para enumerar os clusters
contador_clusters = 0;

% Verifica se realmente encontramos um cluster maior que 0
if indice_maior_cluster > 0
    % Encontra os índices dos vetores que pertencem ao maior cluster
    indices_maior_cluster = find(clusters == indice_maior_cluster);
    
    % Incrementa o contador de clusters
    contador_clusters = contador_clusters + 1;
    
    % Adiciona os vetores do maior cluster à matriz de clusters
    matriz_clusters_max = [matriz_clusters_max; [indices_maior_cluster, ones(length(indices_maior_cluster), 1) * contador_clusters, ones(length(indices_maior_cluster), 1) * indice_maior_cluster, matriz(indices_maior_cluster, :)]];
end

[qtd_max_encontrado,~] = size(matriz_clusters_max);

% Verifica se há outros clusters com o mesmo tamanho máximo
if planos_desejados <= qtd_max_encontrado
    % Verifica se há outros clusters com o mesmo tamanho máximo
    for i = 1:num_clusters
        if contador_clusters ~= clusters_desejado
            if i ~= indice_maior_cluster % Evita processar o maior cluster novamente
                % Encontra os índices dos vetores para o cluster atual
                indices_cluster_atual = find(clusters == i);
                % Verifica se o tamanho do cluster atual é igual ao tamanho máximo
                if numel(indices_cluster_atual) == tamanho_maior_cluster
                    % Incrementa o contador de clusters
                    contador_clusters = contador_clusters + 1;
                    % Adiciona os vetores do cluster atual à matriz de clusters
                    matriz_clusters_max = [matriz_clusters_max; [indices_cluster_atual, ones(length(indices_cluster_atual), 1) * contador_clusters, ones(length(indices_cluster_atual), 1) * i,  matriz(indices_cluster_atual, :)]];
                end
            end
        else
            break;
        end
    end
else
    return;
end

end

