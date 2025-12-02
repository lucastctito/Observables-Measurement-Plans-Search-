clear all;
clc;

%Entrada do arquivo com as informações da rede 
entrada = load('netdata.txt');
[m,n] = size(entrada);

inicializar_variaveis('Setup.txt');

%Parâmetros iniciais do AG
ite = 1;
best = 10^10;
custo_obs_best = 0;
best_med = 0;
best_obs = 0;
best_cconj = 0;
control_indicador = 0;
controle_inicial = 0;
jaccard_vector = [];
distance_vector = [];
vetor_estimativa = [];
soma_reset = 0;
maior_cluster = 0;
qtd_planos = 0;

vetor_estimativa_plan_obs = [];
n_estimativa_media=1;
controle_estimativa = 0;
alpha_a_priori = 0;
beta_a_priori = 0;

qtd_barras = 14;
while n_estimativa_media <=limite_estimativa 
    [plan_med] = inicial(entrada,m,qtd_estimativa,numero_inicial);
    [obs_critc] = quantidade_estimativa(plan_med,entrada,m);
    [~,n1] = size(plan_med);
    %[estimativa_total_garantem_supervisao] = estimar_planos_obs(numero_inicial,qtd_ind,n1,obs_critc);
    [estimativa_total_garantem_supervisao,controle_estimativa,alpha_a_priori, beta_a_priori,alpha_posteriori,beta_posteriori] = estimar_planos_obs_versao2(numero_inicial,qtd_ind,n1,obs_critc,controle_estimativa,alpha_a_priori,beta_a_priori,qtd_barras);
    if n_estimativa_media == 1
        alpha_a_priori1 = alpha_a_priori;
        beta_a_priori1 = beta_a_priori;
    end
    vetor_estimativa_plan_obs = [vetor_estimativa_plan_obs, estimativa_total_garantem_supervisao];
    n_estimativa_media = n_estimativa_media + 1;     
end
alpha_posteriori = alpha_a_priori;
beta_posteriori = beta_a_priori;

% Intervalo de valores para a variável aleatória
x = linspace(0, 1, 100);

% Distribuição Beta a priori
y_a_priori = betapdf(x, alpha_a_priori1, beta_a_priori1);

% Distribuição Beta a posteriori
y_posteriori = betapdf(x, alpha_posteriori, beta_posteriori);

% Plotando as distribuições
figure;
hold on;
plot(x, y_a_priori, 'b-', 'LineWidth', 2, 'DisplayName', 'A Priori');
plot(x, y_posteriori, 'r-', 'LineWidth', 2, 'DisplayName', 'A Posteriori');
hold off;

% Configurações do gráfico
xlabel('x');
ylabel('Density');
title('Distribuição Beta Conjugada');
legend('show');
grid on;