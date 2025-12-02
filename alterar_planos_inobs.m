function [outputArg1,outputArg2] = alterar_planos_inobs(inputArg1,inputArg2)

    if parada1 ~= parada_antiga
       parada_antiga = parada1
       parada2 = 0;
    else
        parada2 = parada2 + 1
    end

    if mod(ite,5) == 0
        [m_obs,n_obs] = size(pop_final);
        v = zeros(1,n_obs);
        
        P_obs = qtd_planos_obs/qtd_planos;
        pop_final;
        for i =1:m_obs
           for j = 1:n_obs
               soma_pos_barra = 0;
               if pop_final(i,j) == 1
                  soma_pos_barra = soma_pos_barra+1;
               end
               v(j) = v(j) + soma_pos_barra;
               P_UTRi_obs(j) = v(j)/m_obs;
           end
        end
        
        comb_barra_fixa = nchoosek(n_obs-1, numero_inicial-1);
        comb_UTRs = nchoosek(n_obs,numero_inicial);
        P_UTRi = comb_barra_fixa/comb_UTRs;
        
        for i =1:n_obs
            P_obs_UTRi(i) = (P_UTRi_obs(i)*P_obs)/P_UTRi;
        end
        
        P_obs_UTRi;      
    end     

end

