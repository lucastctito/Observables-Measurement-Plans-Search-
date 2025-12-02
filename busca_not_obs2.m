function [pop_final_not,matriz_comparadora_not,k2] = busca_not_obs2(numero_inicial,div,qtd_barras,pop_not_obs,pop_final_not,matriz_comparadora_not,segmentos,k2)

sistema_segmentado = zeros(1,div);

for i =1:segmentos
    sistema_segmentado(i,:) = zeros(1,div);
end

tamanho_vetor = 0;
expoente = div;

for i =1:numero_inicial
    expoente = expoente-1;
    tamanho_vetor = tamanho_vetor + 2^(expoente);
end

[linha_pop,coluna_pop] = size(pop_not_obs);

indice = 1;
for i =1:linha_pop
    soma_quadratica= zeros(1,segmentos);
    for j = 1:coluna_pop
        if j <= div
            if pop_not_obs(i,j) == 1
                soma_quadratica(indice) = soma_quadratica(indice) + 2^(j-1);
            end
        elseif j > div
            if pop_not_obs(i,j) == 1
                soma_quadratica(segmentos) = soma_quadratica(segmentos) + 2^((j-div)-1);
            end
        end
    end

    for k =1:segmentos
        matriz_busca(k,i) = soma_quadratica(k);
    end   
    indice = 1;
end


[linha_matriz,coluna_matriz] = size(matriz_busca);

for i =1:segmentos
    if matriz_busca(i) == 0
        return
    end
end

for ii = 1:segmentos-1
    for i = 1:coluna_matriz
        aa = ii;
        bb = ii+1;
        j1 = matriz_busca(ii,i);
        j2 = matriz_busca(ii+1,i);
        if j2 == 0
            j2 = randi(tamanho_vetor);
        elseif j1 == 0
            j1 = randi(tamanho_vetor);
        end
        if (matriz_comparadora_not(ii,j1)) == 0 && (matriz_comparadora_not(ii+1,j2)) == 0
            matriz_comparadora_not(ii,j1) = 1;
            matriz_comparadora_not(ii+1,j2) = 1;
            pop_final_not(k2,:) = pop_not_obs(i,:);
            k2 = k2 + 1;
        elseif (matriz_comparadora_not(ii,j1)) == 1 && (matriz_comparadora_not(ii+1,j2)) == 0
            matriz_comparadora_not(ii+1,j2) = 1;
            pop_final_not(k2,:) = pop_not_obs(i,:);
            k2 = k2 + 1;            
        elseif (matriz_comparadora_not(ii,j1)) == 0 && (matriz_comparadora_not(ii+1,j2)) == 1
            matriz_comparadora_not(ii,j1) = 1;
            pop_final_not(k2,:) = pop_not_obs(i,:);
            k2 = k2 + 1;
        end
    end
end

end