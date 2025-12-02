function [pop_final,vetor_comparador,k1] = funcao_busca(pop_busca,numero_inicial,pop_final,k1,vetor_comparador)
   
  numero_utr = numero_inicial;
  [linha_pop,coluna_pop] = size(pop_busca);
  
  for i =1:linha_pop
      soma_quadratica = 0;
      for j = 1:coluna_pop
          if pop_busca(i,j) == 1;
              soma_quadratica = soma_quadratica + 2^(j-1);%j^2;
          end
      end
      vetor_busca(i) = soma_quadratica;
  end
   
  [linha_vetor,coluna_vetor] = size(vetor_busca);

  [mm2,nn2] = size(vetor_comparador);
  
  if vetor_busca(1) == 0
      return
  end

  for i = 1:coluna_vetor
      
    j = vetor_busca(i);
    
    if vetor_comparador(j) == 0
        vetor_comparador(j) = 1;
        pop_final(k1,:) = pop_busca(i,:);
        k1 = k1 + 1;
    end
  end
  
end

