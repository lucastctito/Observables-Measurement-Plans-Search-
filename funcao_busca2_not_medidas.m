function [pop_final_not,matriz_comparadora_not,k2] = funcao_busca2_not_medidas(numero_inicial,div,qtd_barras,pop_not_obs,pop_final_not,matriz_comparadora_not,segmentos,k2)

sistema_segmentado = zeros(1,div);

for i =1:segmentos
    sistema_segmentado(i,:) = zeros(1,div);
end


[linha_pop,coluna_pop] = size(pop_not_obs);

indice = 1;
controle = 1;

pop_segmentado = zeros(1,div);


for i =1:linha_pop
    soma_quadratica= zeros(1,segmentos);
    controle = 1;
    inicio = 1;
    criterio1 = div;
    criterio2 = segmentos;
    kk = 1;
    a = segmentos;
    while controle <= segmentos
        pop_segmentado = zeros(1,div);
        parada = coluna_pop - criterio1*(criterio2-1);
        for j = inicio:parada
            pop_segmentado(i,j) = pop_not_obs(i,j);
        end
          
        for j =inicio:parada
            if pop_segmentado(i,j) == 1
                controle_a = j - div*(segmentos - a);
                soma_quadratica(kk) = soma_quadratica(kk) + 2^(controle_a-1);
            end
        end
        
        a = a - 1;
        inicio = inicio + div;
        criterio2 = criterio2 - 1;
        kk = kk +1;
        controle = controle + 1;
    end
  
    for k =1:segmentos
        matriz_busca(k,i) = soma_quadratica(k);
    end

end

maior1 = max(matriz_busca);
maior2 = max(maior1);

[linha_matriz,coluna_matriz] = size(matriz_busca);

for i =1:segmentos
    if matriz_busca(i) == 0
        return
    end
end


for i = 1:coluna_matriz
    cont = 0;
    for j = 1:segmentos
        pos = matriz_busca(j,i);
        
        if pos ==0
            pos = randi(maior2);
        end
        
        if matriz_comparadora_not(j,pos) == 1
            cont = cont + 1;
        end
    end
    
    for j = 1:segmentos
        pos = matriz_busca(j,i);
        
        if pos ==0
            pos = randi(maior2);
        end
        
        if cont < segmentos
            matriz_comparadora_not(j,pos) = 1;
        end
    end
    
    if cont<segmentos
        pop_final_not(k2,:) = pop_not_obs(i,:);
        k2 = k2 + 1;          
    end
end




























end

