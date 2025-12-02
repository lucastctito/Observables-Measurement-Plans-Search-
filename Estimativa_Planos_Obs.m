clear all;
clc;

numero_inicial = 6;
qtd_ind = 100;
entrada = load('netdata.txt');
[m,n] = size(entrada);
combinacoes = combntns(14, numero_inicial);

[plan_med,num_barra] = inicial(entrada,m,qtd_ind,numero_inicial);
[vetor_medidas,vetor_utrs,obs_critc,cmeas_1,cconj_1,qtd_zero_inobs,soma_elementos_nao_nulos] = quantidade(plan_med,entrada,m);

[m_obs,~] = size(obs_critc')
qtd_plan_obs =0;

for i=1:qtd_ind
    if obs_critc(i) == 0
        qtd_plan_obs = qtd_plan_obs + 1;
    end
end

qtd_plan_obs

Proportion_historical = qtd_plan_obs/qtd_ind;
dados = obs_critc;

% Estimativas iniciais baseadas na média e variância dos dados
media_inicial = mean(dados)
variancia_inicial = var(dados)

% Suposições iniciais para os parâmetros alfa e beta
alpha_suposto = media_inicial * (media_inicial * (1 - media_inicial) / variancia_inicial - 1)
beta_suposto = (1 - media_inicial) * (media_inicial * (1 - media_inicial) / variancia_inicial - 1)


% Função de log-verossimilhança
log_verossimilhanca = @(params) -sum((params(1) - 1) * log(dados) + (params(2) - 1) * log(1 - dados) - betaln(params(1), params(2)));

% Condições iniciais para alpha e beta
initial_guess = [abs(alpha_suposto), abs(beta_suposto)];

% Otimização da log-verossimilhança
options = optimset('fminsearch');
result = fminsearch(log_verossimilhanca, initial_guess, options);

alpha_estimado = result(1)
beta_estimado = result(2)

% Parâmetros da distribuição Beta a priori
alpha_a_priori = alpha_estimado; % ajuste conforme necessário
beta_a_priori = beta_estimado;  % ajuste conforme necessário

% Função de densidade de probabilidade (pdf) da distribuição Beta
pdf_beta = @(p) betapdf(p, alpha_a_priori, beta_a_priori);


% Estatísticas da distribuição Beta a priori
media_a_priori = alpha_a_priori / (alpha_a_priori + beta_a_priori);
variancia_a_priori = (alpha_a_priori * beta_a_priori) / ...
    ((alpha_a_priori + beta_a_priori)^2 * (alpha_a_priori + beta_a_priori + 1));

disp(['Média a priori: ', num2str(media_a_priori)]);
disp(['Variância a priori: ', num2str(variancia_a_priori)]);

dados_observados = dados
% Atualização Bayesiana com os dados observados
alpha_posteriori = alpha_a_priori + sum(dados_observados);
beta_posteriori = beta_a_priori + (length(dados_observados) - sum(dados_observados));

% Cálculo de estatísticas da distribuição a posteriori
media_posteriori = alpha_posteriori / (alpha_posteriori + beta_posteriori);
variancia_posteriori = (alpha_posteriori * beta_posteriori) / ...
    ((alpha_posteriori + beta_posteriori)^2 * (alpha_posteriori + beta_posteriori + 1));

% Visualização da distribuição a posteriori
p_values_posteriori = linspace(0, 1, 100);
pdf_posteriori = betapdf(p_values_posteriori, alpha_posteriori, beta_posteriori);
%plot(p_values_posteriori, pdf_posteriori, 'LineWidth', 2);
%title('Distribuição a Posteriori da Probabilidade de Observação');
%xlabel('Probabilidade de Observação');
%ylabel('Densidade de Probabilidade');

disp(['Média a posteriori: ', num2str(media_posteriori)]);
disp(['Variância a posteriori: ', num2str(variancia_posteriori)]);

% Extrapolação para estimar o número total de planos de medição que garantem supervisão
total_planos = combinacoes; % ajuste conforme necessária
estimativa_total_ngarantem_supervisao = round(total_planos * media_posteriori)

estimativa_total_garantem_supervisao = total_planos - estimativa_total_ngarantem_supervisao

%disp(['Estimativa do número total de planos que garantem supervisão: ', num2str(estimativa_total_garantem_supervisao)]);




