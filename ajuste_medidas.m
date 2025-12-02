function [plan_med] = ajuste_medidas(plan_med,tamanho_pop,qtd_ind,num_barra,numero_inicial)

 elementos = num_barra+1;
 qtd_zeros = 0;
 cont= 0;
 pop = zeros(1,tamanho_pop);
 pop_novo = zeros(1,tamanho_pop);
 num_elementos = numero_inicial;
 
 for i = 1:qtd_ind
     qtd_zeros_fp = 0;
     qtd_zeros_ip = 0;
     pop =  plan_med(i,:);
     for j =1:num_barra
         if plan_med(i,j) == 0
             qtd_zeros_fp = qtd_zeros_fp + 1;
             qtd_zeros_ip = qtd_zeros_ip + 1;
         end
     end
                
     if qtd_zeros_ip == num_barra || qtd_zeros_fp == 2*elementos
         controle = 0;
     else
         controle = 1;
     end
     
     if qtd_zeros_ip == num_barra
         while controle == 0
            for k =1:num_elementos
                barra = randi(tamanho_pop,1);
                if pop_novo(barra) == 0
                    pop_novo(barra) = 1;
                elseif pop_novo(barra) == 1
                    aux = barra;
                    while aux == barra
                        c = randi(tamanho_pop,1);
                        if pop_novo(c) == 0
                            aux = c;
                        end
                    end
                    pop_novo(aux) = 1;
                end
            end
            for j =1:num_barra
                if plan_med(i,j) == 0
                    qtd_zeros_fp = qtd_zeros_fp + 1;
                    qtd_zeros_ip = qtd_zeros_ip + 1;
                end
            end 
            
            if qtd_zeros_ip == num_barra || qtd_zeros_fp == 2*elementos
                controle = 0;
            else
                controle = 1;
            end
         end
         plan_med(i,:) = pop_novo;
     end
 
     pop_novo = zeros(1,tamanho_pop);
 end
end

