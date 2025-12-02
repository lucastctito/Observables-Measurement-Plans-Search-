function [pop_final_not,vetor_comparador_not,k2] = busca_not_obs(pop_not_obs,numero_inicial,pop_final_not,k2,vetor_comparador_not)
   
  numero_utr = numero_inicial;
  [linha_pop,coluna_pop] = size(pop_not_obs);
  
  for i =1:linha_pop
      soma_quadratica = 0;
      for j = 1:coluna_pop
          if pop_not_obs(i,j) == 1;
              soma_quadratica = soma_quadratica + 2^(j-1);%j^2;
          end
      end
      vetor_busca(i) = soma_quadratica;
  end
   
  [linha_vetor,coluna_vetor] = size(vetor_busca);
    
  [mm,nn] = size(vetor_comparador_not);
  
  if vetor_busca(1) == 0
      return
  end
  vetor_busca;
  
  q =0;
  for i = 1:coluna_vetor
    j = vetor_busca(i);
    if vetor_comparador_not(j) == 0
        vetor_comparador_not(j) = 1;
        pop_final_not(k2,:) = pop_not_obs(i,:);
        k2 = k2 + 1;
    end
  end
  
end

