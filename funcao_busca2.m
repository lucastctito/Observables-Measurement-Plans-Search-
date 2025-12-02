function [pop_final,matriz_comparadora,k1] = funcao_busca2(numero_inicial,div,qtd_barras,pop_busca,pop_final,matriz_comparadora,segmentos,k1)

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
%tamanho_vetor
%matriz_comparadora = zeros(1,tamanho_vetor);
%for i = 1:segmentos
    %matriz_comparadora(i,:) = zeros(1,tamanho_vetor);
%end

[linha_pop,coluna_pop] = size(pop_busca);

indice = 1;
for i =1:linha_pop
    soma_quadratica= zeros(1,segmentos);
    for j = 1:coluna_pop
        if j <= div
            if pop_busca(i,j) == 1
                soma_quadratica(indice) = soma_quadratica(indice) + 2^(j-1);
            end
        elseif j > div
            if pop_busca(i,j) == 1
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
        j1 = matriz_busca(ii,i);
        j2 = matriz_busca(ii+1,i);
        if (matriz_comparadora(ii,j1)) == 0 && (matriz_comparadora(ii+1,j2)) == 0
            disp('1');
            matriz_comparadora(ii,j1) = 1;
            matriz_comparadora(ii+1,j2) = 1;
            pop_final(k1,:) = pop_busca(i,:);
            k1 = k1 + 1;
        elseif (matriz_comparadora(ii,j1)) == 1 && (matriz_comparadora(ii+1,j2)) == 0
            disp('2');
            matriz_comparadora(ii+1,j2) = 1;
            pop_final(k1,:) = pop_busca(i,:);
            k1 = k1 + 1;            
        elseif (matriz_comparadora(ii,j1)) == 0 && (matriz_comparadora(ii+1,j2)) == 1
            disp('3');
            matriz_comparadora(ii,j1) = 1;
            pop_final(k1,:) = pop_busca(i,:);
            k1 = k1 + 1;
        end
    end
end

end

