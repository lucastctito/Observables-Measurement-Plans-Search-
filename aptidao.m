function [f,f_norma,best,best_plan,custo_exc,custo_obs_best,best_obs] = aptidao(obs_critc,vetor_medidas,vetor_utrs,qtd_ind,plan_med,best,best_plan, custo_obs_best, best_obs ,qtd_zero_inobs,soma_elementos_nao_nulos)
  
[m3,n3] = size(plan_med);

custo_utr = zeros(1,m3);
custo_medidas = zeros(1,m3);
custo_obs = zeros(1,m3);
custo_total = zeros(1,m3);
custo_exc = zeros(1,m3);
custo_colunas_zero_H = zeros(1,m3);
custo_termos_n_nulos = zeros(1,m3);



cont = 0;

for i =1:m3
    
    custo_utr(i) = vetor_utrs(i)*100;
    custo_medidas(i) = vetor_medidas(i)*4.5;
    custo_obs(i) = 10^3*obs_critc(i);
    custo_colunas_zero_H(i)=10^4*qtd_zero_inobs(i);
    custo_termos_n_nulos(i) = 10^2*(1/(soma_elementos_nao_nulos(i)));
    custo_total(i) = custo_obs(i)+custo_colunas_zero_H(i)+custo_termos_n_nulos(i);

end

f = custo_total;

for i = 1:m3
    if f(i) < best
        best = f(i);
        best_obs = obs_critc(i);     
        custo_obs_best = custo_obs(i);
        best_plan = plan_med(i,:);
    end
end
soma = 0;
for i =1:m3
    aux = custo_total(i);
    soma = soma+aux;
end

for i=1:m3
    f_norma(i) = f(i)/soma;
end


end
