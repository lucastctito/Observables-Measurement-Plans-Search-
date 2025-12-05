clear all;
clc;

%Entrada do arquivo com as informações da rede 
entrada = load('netdata118.txt');
[m,n] = size(entrada);

inicializar_variaveis('Setup.txt');

%Parâmetros iniciais do AG
ite = 1;
best = 10^10;
custo_obs_best = 0;
best_med = 0;
best_obs = 0;
best_cconj = 0;
control_indicador = 0;
controle_inicial = 0;
jaccard_vector = [];
distance_vector = [];
vetor_estimativa = [];
soma_reset = 0;
maior_cluster = 0;
qtd_planos = 0;

vetor_estimativa_plan_obs = [];
n_estimativa_media=1;
controle_estimativa = 0;
alpha_a_priori = 0;
beta_a_priori = 0;


while n_estimativa_media <=limite_estimativa 
    [plan_med] = inicial(entrada,m,qtd_estimativa,numero_inicial);
    [obs_critc] = quantidade_estimativa(plan_med,entrada,m);
    [~,n1] = size(plan_med);
    %[estimativa_total_garantem_supervisao] = estimar_planos_obs(numero_inicial,qtd_ind,n1,obs_critc);
    [estimativa_total_garantem_supervisao,controle_estimativa,alpha_a_priori, beta_a_priori,alpha_posteriori,beta_posteriori] = estimar_planos_obs_versao2(numero_inicial,qtd_ind,n1,obs_critc,controle_estimativa,alpha_a_priori,beta_a_priori,qtd_barras);
    vetor_estimativa_plan_obs = [vetor_estimativa_plan_obs, estimativa_total_garantem_supervisao];
    n_estimativa_media = n_estimativa_media + 1;     
end

% Identificar índices dos valores NaN
indices_nan = isnan(vetor_estimativa_plan_obs);

% Remover valores NaN do vetor
vetor_estimativa_plan_obs = vetor_estimativa_plan_obs(~indices_nan);
[aa,bb] = size(vetor_estimativa_plan_obs);
estimativa_plan_obs_media = estimativa_total_garantem_supervisao

%Somente será executado se não for possível estimar a quantidade de planos
if isnan(estimativa_plan_obs_media)
    estimativa_plan_obs_media = estimativa_plan_obs_set;  %
end

[tabelaHash,tamanhoTabela] = iniciar_hash(estimativa_plan_obs_media,fatorCarga);

criterio_parada = 1;

vetor_tempo_final = [];
vetor_ite_final = [];
vetor_qtd_planos_obs = [];

while criterio_parada <=limite_teste_AG 
    
    ite = 1;
    best = 10^10;
    custo_cmeas_best = 0;
    custo_obs_best = 0;
    custo_nconj_best = 0;
    best_med = 0;
    best_obs = 0;
    best_cconj = 0;
    control_indicador = 0;
    controle_inicial = 0;
    jaccard_vector = [];
    distance_vector = [];
    vetor_estimativa = [];
    soma_reset = 0;

    %segmentos = 2;
    %Inicialização dos planos de medição do AG
    [plan_med,num_barra] = inicial(entrada,m,qtd_ind,numero_inicial);
    pop0 = plan_med;
    [m1,n1] = size(plan_med);
    qtd_barras = n1;

    %Contadores dos planos de medição
    k1 = 1;
    k2 = 1;
    k3 = 1;

    best_plan = zeros(1,n1);
    pop = zeros(1,num_barra);
    %Testar a aptidão da população inicializada
    [vetor_medidas,vetor_utrs,obs_critc, saida,barra_utr,qtd_zero_inobs,soma_elementos_nao_nulos] = quantidade(plan_med,entrada,m,tabelaHash,tamanhoTabela);

    [f,f_norma,best,best_plan,custo_exc,custo_obs_best,best_obs] = aptidao(obs_critc,vetor_medidas,vetor_utrs,qtd_ind,plan_med...
        ,best,best_plan, custo_obs_best, best_obs ,qtd_zero_inobs,soma_elementos_nao_nulos);
    
    [saida,barra_utr,line,num,tipo,loc,nbus,nlin,nmed] = conversao(entrada,best_plan,m);
    saida;

    parada1 = 1;
    parada2 = 0;
    parada3 = 0;
    criterio_parada_cluster = 0;
    criterio_parada_geral = 0 ;
    criterio_parada_final = 0;
    
    pp = plan_med;
    vetor_estimativa;
    %comb = 2002;
    parada_antiga = 0;
        
    controle_erro = 0;
    reset_pop = 0;

    ite = 1;

    qtd_ind_inicial = qtd_ind;
    tic
    
    criterio_parada = estimativa_plan_obs_media;
    
    if def_parada == 1
        
        tic
        %while criterio_parada_cluster == 0 
        while parada1 <= tamanho_conjunto

            qtd_ind = qtd_ind_inicial;
            plan_med_gen_anterior = plan_med;

            [pop_elite] = elitismo(plan_med,f,f_norma,taxa_elitismo);
            [m_elite,~] =size(pop_elite);

            linhas_para_excluir = randperm(size(plan_med, 1), m_elite);
            % Excluir as linhas escolhidas
            plan_med(linhas_para_excluir, :) = [];

            f(linhas_para_excluir) = [];
            f_norma(linhas_para_excluir) = [];

            [qtd_ind,~] = size(plan_med);

            %pop_select = selecao_f(f_norma,plan_med);
            pop_tournament = selecao_torneio(plan_med,f);

            pop_select = pop_tournament;


            [pop_ajuste] = ajuste_barras(pop_select,numero_inicial);
            pop_select = pop_ajuste;    
            c = rand;

            if c> limite_inferior_cruzamento  && c< limite_superior_cruzamento 
                pop_select = crossover_f(pop_select,numero_inicial);
                [pop_ajuste] = ajuste_barras(pop_select,numero_inicial);
                pop_select = pop_ajuste; 
            end

            pop2 = pop_select;
            if c > limite_inferior_mutacao  && c< limite_superior_mutacao
                pop_select = mutacao_f(pop_select);
                [pop_ajuste] = ajuste_barras(pop_select,numero_inicial);
                pop_select = pop_ajuste; 
            end

            c = rand;
            if c >limite_inferior_mutacao && c<limite_superior_mutacao
                pop_select = mutacao_f(pop_select);
                [pop_ajuste] = ajuste_barras(pop_select,numero_inicial);
                pop_select = pop_ajuste;       
            end
            pop_select;


            plan_med = pop_select;
            plan_med = ajuste(plan_med,num_barra,qtd_ind);

            populacao = [pop_elite; plan_med];
            plan_med = populacao;    
            plan_med_gen_atual = plan_med;

            [jaccardIndex,distanceJaccard,jaccard_vector,distance_vector,reset_pop,controle_erro] = jaccard(plan_med_gen_atual,plan_med_gen_anterior,jaccard_vector,distance_vector,controle_erro,reset_pop);

            if reset_pop ==1;
                [plan_med,num_barra] = inicial(entrada,m,qtd_ind_repop ,numero_inicial);
                reset_pop = 0;
                soma_reset = soma_reset + 1;
            end

            [vetor_medidas,vetor_utrs,obs_critc, saida,barra_utr,qtd_zero_inobs,soma_elementos_nao_nulos,tabelaHash] = quantidade(plan_med,entrada,m,tabelaHash,tamanhoTabela);

             quantidade_nao_nulos = sum(~cellfun(@isempty, tabelaHash));

            [f,f_norma,best,best_plan,custo_exc,custo_obs_best,best_obs] = aptidao(obs_critc,vetor_medidas,vetor_utrs,qtd_ind,plan_med...
                ,best,best_plan, custo_obs_best, best_obs ,qtd_zero_inobs,soma_elementos_nao_nulos);

            ite = ite + 1       
            parada1 = quantidade_nao_nulos

        toc;
        end
             

        % Calcule o progresso em porcentagem
        progresso_percentual = (parada1 / criterio_parada) * 100;
        %Transforma os planos obtidos até o momento da Tabela Hash em
        %uma matriz binária
        % Obtenha as strings binárias em 'planos_armazenados' e filtre as não vazias
        planos_armazenados = tabelaHash(~cellfun('isempty', tabelaHash));
        normalVector = string(planos_armazenados);

        % Inicializar a matriz binária
        numRows = length(normalVector);
        numCols = length(strsplit(normalVector(1), ' ')); % Dividir a primeira string para obter o número de colunas
        binaryMatrix = zeros(numRows, numCols);

        % Preencher a matriz binária
        for i = 1:numRows
            % Dividir a string em números individuais (1 ou 0) e converter para vetor de números
            numArray = str2num(normalVector(i)); % Converte a string em um vetor numérico
            binaryMatrix(i, :) = numArray; % Atribui o vetor à linha correspondente
        end

        planos_totais = binaryMatrix;
        csvwrite("Base de dados.csv",planos_totais)
        
        if controle_qtd_cluster  == 1
            [matriz_clusters_max] = cluster_hierarquico_maximo(planos_totais,numero_inicial,UMs_trocadas,clusters_desejado,planos_desejados);
        elseif controle_qtd_cluster == 2              
            [matriz_clusters_max]=cluster_hierarquico_qualquer(planos_totais,numero_inicial,UMs_trocadas,diferenca_maxima_aceitavel,planos_desejados)            
        elseif controle_qtd_cluster == 3
            [matriz_clusters_max] = cluster_hierarquico_minimo(planos_totais,numero_inicial,UMs_trocadas,clusters_desejado);
        elseif controle_qtd_cluster == 4
            [matriz_clusters_max] = cluster_hierarquico_interativo_teste(planos_totais, numero_inicial, UMs_trocadas)
        end

        if ~isempty(matriz_clusters_max)    
            [qtd_planos,~] = size(matriz_clusters_max);
            maior_cluster = max(matriz_clusters_max(:,2))
        end       
    else
        tic
    
        while criterio_parada_cluster == 0 
        
            qtd_ind = qtd_ind_inicial;
            plan_med_gen_anterior = plan_med;

            [pop_elite] = elitismo(plan_med,f,f_norma,taxa_elitismo);
            [m_elite,~] =size(pop_elite);

            linhas_para_excluir = randperm(size(plan_med, 1), m_elite);
            % Excluir as linhas escolhidas
            plan_med(linhas_para_excluir, :) = [];

            f(linhas_para_excluir) = [];
            f_norma(linhas_para_excluir) = [];

            [qtd_ind,~] = size(plan_med);

            %pop_select = selecao_f(f_norma,plan_med);
            pop_tournament = selecao_torneio(plan_med,f);

            pop_select = pop_tournament;


            [pop_ajuste] = ajuste_barras(pop_select,numero_inicial);
            pop_select = pop_ajuste;    
            c = rand;

            if c> limite_inferior_cruzamento  && c< limite_superior_cruzamento 
                pop_select = crossover_f(pop_select,numero_inicial);
                [pop_ajuste] = ajuste_barras(pop_select,numero_inicial);
                pop_select = pop_ajuste; 
            end

            pop2 = pop_select;
            if c > limite_inferior_mutacao  && c< limite_superior_mutacao
                pop_select = mutacao_f(pop_select);
                [pop_ajuste] = ajuste_barras(pop_select,numero_inicial);
                pop_select = pop_ajuste; 
            end

            c = rand;
            if c >limite_inferior_mutacao && c<limite_superior_mutacao
                pop_select = mutacao_f(pop_select);
                [pop_ajuste] = ajuste_barras(pop_select,numero_inicial);
                pop_select = pop_ajuste;       
            end
            pop_select;


            plan_med = pop_select;
            plan_med = ajuste(plan_med,num_barra,qtd_ind);

            populacao = [pop_elite; plan_med];
            plan_med = populacao;    
            plan_med_gen_atual = plan_med;

            [jaccardIndex,distanceJaccard,jaccard_vector,distance_vector,reset_pop,controle_erro] = jaccard(plan_med_gen_atual,plan_med_gen_anterior,jaccard_vector,distance_vector,controle_erro,reset_pop);

            if reset_pop ==1;
                [plan_med,num_barra] = inicial(entrada,m,qtd_ind_repop ,numero_inicial);
                reset_pop = 0;
                soma_reset = soma_reset + 1;
            end

            [vetor_medidas,vetor_utrs,obs_critc, saida,barra_utr,qtd_zero_inobs,soma_elementos_nao_nulos,tabelaHash] = quantidade(plan_med,entrada,m,tabelaHash,tamanhoTabela);

             quantidade_nao_nulos = sum(~cellfun(@isempty, tabelaHash));

            [f,f_norma,best,best_plan,custo_exc,custo_obs_best,best_obs] = aptidao(obs_critc,vetor_medidas,vetor_utrs,qtd_ind,plan_med...
                ,best,best_plan, custo_obs_best, best_obs ,qtd_zero_inobs,soma_elementos_nao_nulos);

            ite = ite + 1       
            parada1 = quantidade_nao_nulos

            if mod(ite, verificar_gera) == 0

                % Calcule o progresso em porcentagem
                progresso_percentual = (parada1 / criterio_parada) * 100;
                %Transforma os planos obtidos até o momento da Tabela Hash em
                %uma matriz binária
                % Obtenha as strings binárias em 'planos_armazenados' e filtre as não vazias
                planos_armazenados = tabelaHash(~cellfun('isempty', tabelaHash));
                normalVector = string(planos_armazenados);

                % Inicializar a matriz binária
                numRows = length(normalVector);
                numCols = length(strsplit(normalVector(1), ' ')); % Dividir a primeira string para obter o número de colunas
                binaryMatrix = zeros(numRows, numCols);

                % Preencher a matriz binária
                for i = 1:numRows
                    % Dividir a string em números individuais (1 ou 0) e converter para vetor de números
                    numArray = str2num(normalVector(i)); % Converte a string em um vetor numérico
                    binaryMatrix(i, :) = numArray; % Atribui o vetor à linha correspondente
                end

                planos_totais = binaryMatrix;
                csvwrite("Base de dados.csv",planos_totais)
                
                if controle_qtd_cluster  == 1
                    [matriz_clusters_max] = cluster_hierarquico_maximo(planos_totais,numero_inicial,UMs_trocadas,clusters_desejado,planos_desejados);
                elseif controle_qtd_cluster == 2              
                    [matriz_clusters_max]=cluster_hierarquico_qualquer(planos_totais,numero_inicial,UMs_trocadas,diferenca_maxima_aceitavel,planos_desejados)            
                elseif controle_qtd_cluster == 3
                    [matriz_clusters_max] = cluster_hierarquico_minimo(planos_totais,numero_inicial,UMs_trocadas,clusters_desejado);
                elseif controle_qtd_cluster == 4
                    [matriz_clusters_max] = cluster_hierarquico_interativo_teste(planos_totais, numero_inicial, UMs_trocadas)
                end

                if ~isempty(matriz_clusters_max)    
                    [qtd_planos,~] = size(matriz_clusters_max);
                    maior_cluster = max(matriz_clusters_max(:,2))
                end
                parada_cluster1 = 0;
                if clusters_desejado == maior_cluster
                    parada_cluster1 = 1;
                end

                parada_cluter2 = 0;
                if planos_desejados == qtd_planos
                    parada_cluter2 = 1;
                end

                criterio_parada_cluster = or(parada_cluster1,parada_cluter2);

                if criterio_parada_cluster == 0
                    parada3 = parada3 + 1;
                end

                if parada3 == limite_parada3
                    criterio_parada_cluster = 1;
                end

            end  

            if parada1 ~= parada_antiga
                parada_antiga = parada1;
                parada2 = 0;
            else
                parada2 = parada2 + 1;
            end        

            parada_total_planos = 0;
            if parada1 == estimativa_plan_obs_media 
                parada_total_planos = 1;
            end

            parada_convergencia = 0;
            if parada2 == limite_parada2 
                parada_convergencia = 1;
            end

            criterio_parada_geral = and(parada_total_planos,parada_convergencia);
            criterio_parada_final = or(criterio_parada_geral,criterio_parada_cluster);

        end
            toc;
        
    end
    tempo_final = toc;
    ite_final = ite;
    qtd_planos_obs = parada1;
    
    
    
    vetor_tempo_final = [vetor_tempo_final, tempo_final];
    vetor_ite_final = [vetor_ite_final, ite_final];
    vetor_qtd_planos_obs = [vetor_qtd_planos_obs, qtd_planos_obs];
    
    criterio_parada = criterio_parada + 1
end

% Obtenha as strings binárias em 'planos_armazenados' e filtre as não vazias
planos_armazenados = tabelaHash(~cellfun('isempty', tabelaHash));
normalVector = string(planos_armazenados);

% Inicializar a matriz binária
numRows = length(normalVector);
numCols = length(strsplit(normalVector(1), ' ')); % Dividir a primeira string para obter o número de colunas
binaryMatrix = zeros(numRows, numCols);

% Preencher a matriz binária
for i = 1:numRows
    % Dividir a string em números individuais (1 ou 0) e converter para vetor de números
    numArray = str2num(normalVector(i)); % Converte a string em um vetor numérico
    binaryMatrix(i, :) = numArray; % Atribui o vetor à linha correspondente
end
planos_armazenados = binaryMatrix;

matriz_clusters_max

matriz = matriz_clusters_max;

matriz_clusters_max(:, 1:3) = []; 

vetoresBinarios = matriz_clusters_max;

% Solicitar ao usuário o nome do arquivo
nome_arquivo = input('Digite o nome do arquivo para salvar (incluindo .csv): ', 's');

% Salvar a matriz no arquivo CSV com o nome fornecido pelo usuário
csvwrite(nome_arquivo, matriz);

%disp(['Matriz salva em ', nome_arquivo]);

% Número de vetores
numVetores = size(vetoresBinarios, 1);

% Inicializar a matriz de dissimilaridade
matrizDissimilaridade = zeros(numVetores);

% Calcular a distância de Hamming entre os vetores
for i = 1:numVetores
    for j = i+1:numVetores
        % Distância de Hamming é a soma das diferenças entre os vetores
        distanciaHamming = sum(vetoresBinarios(i,:) ~= vetoresBinarios(j,:));
        matrizDissimilaridade(i,j) = distanciaHamming;
        matrizDissimilaridade(j,i) = distanciaHamming; % Matriz é simétrica
    end
end
matrizDissimilaridade
%Cálculo dos indicadores
%quantidade_nao_nulos = nnz(tabelaHash);
%media_tempo = mean(vetor_tempo_final);
%var_tempo = var(vetor_tempo_final);
%media_ite = mean(vetor_ite_final);
%var_ite = var(vetor_ite_final);
%media_plan_obs = mean(vetor_qtd_planos_obs);
%var_plan_obs = var(vetor_qtd_planos_obs);




