function [pop_busca,pop_not_obs] = armazenar_observavel(plan_med,obs_critc,pop_busca,pop_not_obs,link_comunicacao)

k1 = 1;
k2 = 1;
[m,n] = size(obs_critc);
[linha,coluna] = size(plan_med);
[i1,j1] = size(pop_not_obs);
for i =1:n
    cont_zero = 0;
    if obs_critc(i) == 0 
        pop_busca(k1,:) = plan_med(i,:);
        k1 = k1 + 1;
    elseif obs_critc(i) == 1 
        pop_not_obs(k2,:) = plan_med(i,:);
        k2 = k2 + 1;
    end
end

end

