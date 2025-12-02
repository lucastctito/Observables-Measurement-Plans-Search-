function [matriz_clusters_desejados] = cluster_hierarquico_qualquer(planos_totais,numero_inicial,UMs_trocadas,diferenca_maxima_aceitavel,planos_desejados)

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

% Inicializa a matriz para os vetores do maior cluster
matriz_clusters_desejados = [];
num_elementos_por_cluster = 3;

% Inicializa um contador para enumerar os clusters
contador_clusters = 0;

% Inicializa variáveis para armazenar o cluster mais próximo e a diferença mínima
cluster_encontrado = false;
menor_diferenca = Inf; % Inicializa como infinito para encontrar o menor valor
indice_cluster_mais_proximo = [];

% Percorre todos os clusters
for i = 1:num_clusters
    % Encontra os índices dos vetores para o cluster atual
    indices_cluster_atual = find(clusters == i);
    qtd_elementos_cluster = numel(indices_cluster_atual);

    % Verifica se o tamanho do cluster atual é igual ao número desejado de planos
    if qtd_elementos_cluster == planos_desejados
        % Incrementa o contador de clusters
        contador_clusters = contador_clusters + 1;

        % Adiciona os vetores do cluster atual à matriz de clusters
        matriz_clusters_desejados = [matriz_clusters_desejados; ...
            [indices_cluster_atual, ...
            ones(length(indices_cluster_atual), 1) * contador_clusters, ...
            ones(length(indices_cluster_atual), 1) * i, ...
            matriz(indices_cluster_atual, :)]];
        
        % Marca que o cluster desejado foi encontrado
        cluster_encontrado = true;
        break; % Interrompe o loop, pois já encontramos o cluster desejado
    else
        % Calcula a diferença entre o tamanho do cluster atual e o número desejado
        diferenca = abs(qtd_elementos_cluster - planos_desejados);

        % Verifica se essa diferença é aceitável e a menor encontrada até agora
        if diferenca <= diferenca_maxima_aceitavel && diferenca < menor_diferenca
            menor_diferenca = diferenca;
            indice_cluster_mais_proximo = i;
        end
    end
end

% Se o cluster desejado não for encontrado, usa o mais próximo dentro da diferença aceitável
if ~cluster_encontrado
    if ~isempty(indice_cluster_mais_proximo)
        % Encontra os índices dos vetores para o cluster mais próximo
        indices_cluster_mais_proximo = find(clusters == indice_cluster_mais_proximo);

        % Incrementa o contador de clusters
        contador_clusters = contador_clusters + 1;

        % Adiciona os vetores do cluster mais próximo à matriz de clusters
        matriz_clusters_desejados = [matriz_clusters_desejados; ...
            [indices_cluster_mais_proximo, ...
            ones(length(indices_cluster_mais_proximo), 1) * contador_clusters, ...
            ones(length(indices_cluster_mais_proximo), 1) * indice_cluster_mais_proximo, ...
            matriz(indices_cluster_mais_proximo, :)]];
        
        disp('Cluster com a quantidade mais próxima de planos encontrado dentro da diferença aceitável.');
    else
        disp('Nenhum cluster encontrado com a quantidade desejada ou dentro da diferença aceitável.');
        matriz_clusters_desejados = []; % Retorna uma matriz vazia se nenhum cluster for encontrado
    end
else
    disp('Cluster com a quantidade exata de planos encontrado.');
end

end

