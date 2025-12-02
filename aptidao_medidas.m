function [f,f_norma,best,best_plan,custo_obs_best,custo_cmeas_best,custo_nconj_best,best_med,best_obs,best_cconj] = aptidao_medidas(numero_inicial,obs_critc,vetor_medidas,qtd_ind,plan_med,best,best_plan,cmeas_1,cconj_1,custo_obs_best,custo_cmeas_best,custo_nconj_best,best_med, best_obs, best_cconj)
   
%custo_medidas = zeros(1,qtd_ind);
custo_obs = zeros(1,qtd_ind);
custo_total = zeros(1,qtd_ind);
custo_cmeas = zeros(1,qtd_ind);
custo_nconj = zeros(1,qtd_ind);


[m3,n3] = size(plan_med);

cont = 0;
%for i =1:qtd_ind
    %vetor(1,:) = plan_med(i,:);
    %for j = 1:n3
        %if vetor(1,j) == 1
            %cont = cont + 1;
        %end
        %if cont > numero_inicial
            %vetor_exc(i) = cont;
        %end
    %end
    %cont = 0;
%end

for i =1:qtd_ind
    %custo_exc(i) = vetor_exc(i) * 10^8;
    %custo_medidas(i) = vetor_medidas(i)*4.5;
    custo_obs(i) = 10^4*obs_critc(i);
    custo_cmeas(i) = 10^3*cmeas_1(i);
    custo_nconj(i) = 10^2*cconj_1(i);
    
    custo_total(i) = custo_obs(i)+custo_cmeas(i)+custo_nconj(i);
end

f = custo_total;

for i = 1:qtd_ind
    if f(i) < best
        best = f(i);
        best_med = cmeas_1(i);
        best_obs = obs_critc(i);
        best_cconj = cconj_1(i);
     
        custo_obs_best = custo_obs(i);
        custo_cmeas_best = custo_cmeas(i);
        custo_nconj_best = custo_nconj(i);
        best_plan = plan_med(i,:);
    end
end
soma = 0;
for i =1:qtd_ind
    aux = custo_total(i);
    soma = soma+aux;
end

for i=1:qtd_ind
    f_norma(i) = f(i)/soma;
end

end
