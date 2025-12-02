function [obs_critc_armazena,cmeas_armazena,cconj_armazena,controle_indicador_cmeas] = exportar_medidas(pop_final,pop_final_not,entrada,m,numero_inicial,qtd_barras,control_indicador,control_indicador_cmeas,controle_inicial)
    
    [m0, n0] = size(entrada);
    barra_de = entrada(:,2);
    barra_para = entrada(:,3);
    
    matriz = zeros(m,2);
    matriz(:,1) = barra_de;
    matriz(:,2) = barra_para;
    matriz = matriz(:);
    num_barra =max(matriz);
    
    
    
    
    
    [m1,n1] = size(pop_final)
    ind = zeros(1,n1);
    obs_critc = zeros(1,m1);
    cmeas_1 = zeros(1,m1);
    cconj_1 = zeros(1,m1);
    medidas_armazena = zeros(1,m1);

    for i =1:m1
        i
        ind = pop_final(i,:);
        [saida,line,num,tipo,loc,nbus,nlin,nmed] = conversao_medidas(entrada,ind,m,numero_inicial);
        [m2,n2] = size(saida);
        
        [ncmeas,mconj,nconj,k,det1,cconj,cmeas]=ffteste(line, nbus, nlin, nmed,num,tipo,loc);

        if controle_inicial == 0
        
            qtd_cmeas_ip = zeros(1,num_barra);
            qtd_cmeas_fp_p = zeros(1,2*numero_inicial);
            qtd_cmeas_fp_n = zeros(1,2*numero_inicial);
            
            qtd_cconj_ip = zeros(1,num_barra); %qtd de cconj de injeção de potência ativa
            qtd_cconj_fp_p = zeros(1,2*numero_inicial); %qtd de cconj de fluxo de potência ativa na barra de
            qtd_cconj_fp_n = zeros(1,2*numero_inicial); %qtd de cconj de fluxo de potência ativa na barra para
            
            qtd_medidas_ip = zeros(1,num_barra);%qtd de medidas de injeção de potência ativa
            qtd_medidas_fp_p = zeros(1,2*numero_inicial);%qtd de medidas de fluxo de potência ativa na barra de
            qtd_medidas_fp_n = zeros(1,2*numero_inicial);%qtd de medidas de fluxo de potência ativa na barra para
            
            controle_inicial = 1;        
        end 
        
        entrada
        saida

        [matriz_ip,matriz_fp,control_indicador,controle_inicial,qtd_cconj_ip,qtd_cconj_fp_p,qtd_cconj_fp_n,qtd_medidas_ip,qtd_medidas_fp_p,qtd_medidas_fp_n] = ...
            indicadores2_medidas(numero_inicial,entrada,saida,qtd_barras,cconj,...
            controle_inicial,control_indicador,qtd_cconj_ip,qtd_cconj_fp_p,qtd_cconj_fp_n,qtd_medidas_ip,qtd_medidas_fp_p,qtd_medidas_fp_n,num_barra);
        
        [control_indicador_cmeas,matriz_fp_2,matriz_ip_2,qtd_cmeas_ip,qtd_cmeas_fp_p,qtd_cmeas_fp_n] = indicadores3_medidas(numero_inicial,entrada,saida,...
            qtd_barras,cmeas,qtd_cmeas_ip,qtd_cmeas_fp_p,qtd_cmeas_fp_n,qtd_medidas_ip,qtd_medidas_fp_p,qtd_medidas_fp_n,num_barra,control_indicador_cmeas);
        
        medidas_armazena(1,i) = m2;
        obs_critc_armazena(1,i) = k;
        cmeas_armazena(1,i) = ncmeas;
        cconj_armazena(1,i) = mconj; 
        num_conj(1,i) = nconj;
        ind = zeros(1,n1);
        
        
        
    end
    matriz_fp;
    [media_cmeas,dp_cmeas,media_cconj,dp_cconj,media_num_conj,dp_num_conj,media_per_cconj,qtd_plan_obs,qtd_plan_not_obs,N1,media_per_cmeas,dp_per_cmeas,dp_per_cconj,per_cconj,per_cmeas] ...
        = indicadores1(cmeas_armazena,cconj_armazena,medidas_armazena,num_conj,pop_final,pop_final_not);
    
    obs_critc_armazena = obs_critc_armazena';
    cmeas_armazena =  cmeas_armazena';
    cconj_armazena = cconj_armazena'; 
    num_conj = num_conj';
    per_cconj = per_cconj';
    per_cmeas = per_cmeas';    
    
 
    filename = 'Indicadores.xlsx';
    xlswrite(filename,media_cmeas,'INDICADORES','B2');
    xlswrite(filename,dp_cmeas,'INDICADORES','B3');
    xlswrite(filename,media_cconj,'INDICADORES','B4');
    xlswrite(filename,dp_cconj,'INDICADORES','B5');
    xlswrite(filename,media_num_conj,'INDICADORES','B6');
    xlswrite(filename,dp_num_conj,'INDICADORES','B7');
    xlswrite(filename,media_per_cmeas,'INDICADORES','B8');
    xlswrite(filename,dp_per_cmeas,'INDICADORES','B9');
    xlswrite(filename,media_per_cconj,'INDICADORES','B10');
    xlswrite(filename,dp_per_cconj,'INDICADORES','B11');
    xlswrite(filename,qtd_plan_obs,'INDICADORES','B12');
    xlswrite(filename,qtd_plan_not_obs,'INDICADORES','B13');
    xlswrite(filename,N1,'INDICADORES','B14');
    
    xlswrite(filename,matriz_ip,'IP - CCONJ');
    xlswrite(filename,matriz_fp,'FP - CCONJ');

    xlswrite(filename,matriz_ip_2,'IP - CMEAS');
    xlswrite(filename,matriz_fp_2,'FP - CMEAS');    
    
    filename = 'Resultado_final.xlsx';
    xlswrite(filename,pop_final,'Barras_UTR');
    xlswrite(filename,obs_critc_armazena,'Critérios','A1');
    xlswrite(filename,cmeas_armazena,'Critérios','B1');
    xlswrite(filename,cconj_armazena,'Critérios','C1');
    xlswrite(filename,num_conj,'Critérios','D1');
    xlswrite(filename,per_cconj,'Critérios','E1');
    xlswrite(filename,per_cmeas,'Critérios','F1');
    
        
end

