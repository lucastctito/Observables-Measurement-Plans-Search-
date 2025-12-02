function [estimativa_total_garantem_supervisao] = estimar_planos_obs(numero_inicial,qtd_ind,n1,obs_critc)

[m_obs,~] = size(obs_critc');
qtd_plan_obs =0;
qtd_barras = n1;

dados = obs_critc;

% Estimativas iniciais baseadas na média e variância dos dados
media_inicial = mean(dados);
variancia_inicial = var(dados);

% Suposições iniciais para os parâmetros alfa e beta iniciais
alpha_suposto = media_inicial * (media_inicial * (1 - media_inicial) / variancia_inicial - 1);
beta_suposto = (1 - media_inicial) * (media_inicial * (1 - media_inicial) / variancia_inicial - 1);

% Função de log-verossimilhança
log_verossimilhanca = @(params) -sum((params(1) - 1) * log(dados) + (params(2) - 1) * log(1 - dados) - betaln(params(1), params(2)));

% Condições iniciais para alpha e beta
initial_guess = [abs(alpha_suposto), abs(beta_suposto)];

% Otimização da log-verossimilhança
options = optimset('Display', 'off');
result = fminsearch(log_verossimilhanca, initial_guess, options);

alpha_estimado = result(1);
beta_estimado = result(2);

% Parâmetros da distribuição Beta a priori
alpha_a_priori = alpha_estimado; % ajuste conforme necessário
beta_a_priori = beta_estimado;  % ajuste conforme necessário

% Estatísticas da distribuição Beta a priori
media_a_priori = alpha_a_priori / (alpha_a_priori + beta_a_priori);
variancia_a_priori = (alpha_a_priori * beta_a_priori) / ...
    ((alpha_a_priori + beta_a_priori)^2 * (alpha_a_priori + beta_a_priori + 1));

dados_observados = dados;
% Atualização Bayesiana com os dados observados
alpha_posteriori = alpha_a_priori + sum(dados_observados);
beta_posteriori = beta_a_priori + (length(dados_observados) - sum(dados_observados));

% Cálculo de estatísticas da distribuição a posteriori
media_posteriori = alpha_posteriori / (alpha_posteriori + beta_posteriori);
variancia_posteriori = (alpha_posteriori * beta_posteriori) / ...
    ((alpha_posteriori + beta_posteriori)^2 * (alpha_posteriori + beta_posteriori + 1));


% Extrapolação para estimar o número total de planos de medição que garantem supervisão
total_planos = combntns(14, numero_inicial);; % ajuste conforme necessário
estimativa_total_ngarantem_supervisao = total_planos * media_posteriori;
estimativa_total_garantem_supervisao = total_planos - round(estimativa_total_ngarantem_supervisao);


end

