clear all;
clc;

%Entrada do arquivo com as informações da rede 
entrada = load('netdata4.txt');
[m,n] = size(entrada);
%Parâmetros iniciais do AG
qtd_ind = 10;
ite = 1;
best = 10^10;
custo_cmeas_best = 0;
custo_obs_best = 0;
custo_nconj_best = 0;
best_med = 0;
best_obs = 0;
best_cconj = 0;
control_indicador = 0;
controle_inicial = 0;

numero_inicial = 6

plan_med = [1 0 0 1 1 1 1 1 0 0 0 0 0 0]

[saida,line,num,tipo,loc,nbus,nlin,nmed] = conversao_medidas(entrada,plan_med,m,numero_inicial);

saida

[ncmeas,mconj,nconj,k,det1,cconj,cmeas]=ffteste(line, nbus, nlin, nmed,num,tipo,loc)