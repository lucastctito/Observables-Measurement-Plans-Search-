function [plan_med] = ajuste(plan_med,num_barra,qtd_ind)

    qtd_zeros = 0;
    pop = zeros(1,num_barra);
    for j =1:qtd_ind
        for l =1:num_barra

            if plan_med(j,l) == 0
                qtd_zeros = qtd_zeros + 1;
            end
        end
        if qtd_zeros == num_barra
             num_utrs = randi(num_barra,1);
                 for i =1:num_utrs
                    barra = randi(num_barra,1);
                     if pop(barra) == 0
                        pop(barra) = 1;
                     elseif pop(barra) == 1
                        aux = barra;
                     while aux == barra
                         c = randi(num_barra,1);
                         if pop(c) == 0
                            aux = c;
                         end
                      end
                      pop(aux) = 1;
                    end
                 end
              plan_med(j,:) = pop;
          end

        qtd_zeros = 0;
        pop = zeros(1,num_barra);
    end


end

