function [pop_ajuste] = ajuste_barras(pop_ajuste,numero_inicial)

[linha_pop,coluna_pop] = size(pop_ajuste);

numero_utr = numero_inicial;
num_barra = coluna_pop;

  for i = 1:linha_pop
      k = 0;
      controle_while = 0;
      cont = 0;
      controle = 1;
      for j =1:coluna_pop
         if pop_ajuste(i,j) == 1
             cont = cont + 1;
         end
      end
      cont;
      if cont < numero_utr
          num_falta = numero_utr - cont;
          while k ~=num_falta
            barra = randi(num_barra,1);
            if pop_ajuste(i,barra) ~= 1
                pop_ajuste(i,barra) = 1;
                k = k+1;
            end
          end
      elseif cont > numero_utr
          num_excesso = cont - numero_utr;
          controle_linha = i;
          for j = 1:coluna_pop
              if pop_ajuste(i,j) == 1
                  vetor_controle(controle) = j;
                  controle = controle + 1;
              end
          end
          vetor_controle_novo = zeros(1,cont);
          vetor_controle;
          for i2 = 1:cont
              vetor_controle_novo(i2) = vetor_controle(i2);
          end
          vetor_controle = vetor_controle_novo;
          controle = controle;
          [linha_excesso,coluna_excesso] = size(vetor_controle);

          while controle_while ~= num_excesso
              excluir = randi(coluna_excesso,1);
              if vetor_controle(excluir) ~=0
                  arm = vetor_controle(excluir);
                  vetor_controle(excluir) = 0;
                  pop_ajuste(i,arm) = 0;
                  controle_while = controle_while + 1;
              end
          end
          
      end

      pop(i,:) = pop_ajuste(i,:);
  end
end

