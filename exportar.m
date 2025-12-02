function [matriz_barra_utrs,obs_critc_armazena,cmeas_armazena,cconj_armazena] = exportar(pop_final,pop_final_not,entrada,m,numero_inicial,qtd_barras,control_indicador,controle_inicial)
    
    [m0, n0] = size(entrada);
    [m1,n1] = size(pop_final);
    [m3,n3] = size(pop_final_not);
    ind = zeros(1,n1);
    obs_critc = zeros(1,m1);
    cmeas_1 = zeros(1,m1);
    cconj_1 = zeros(1,m1);
    medidas_armazena = zeros(1,m1);
    matriz_barra_utrs = zeros(1,numero_inicial);
    matriz_barra_utrs_nob = zeros(1, numero_inicial);

        
    for i=1:m3
        ind = pop_final_not(i,:);
        [saida,barra_utr,line,num,tipo,loc,nbus,nlin,nmed] = conversao(entrada,ind,m);
        [m2,n2] = size(saida);
        
       matriz_barra_utrs_nob(i,:) = barra_utr(1,:);
    end

    for i =1:m1
        ind = pop_final(i,:);
        [saida,barra_utr,line,num,tipo,loc,nbus,nlin,nmed] = conversao(entrada,ind,m);
        [m2,n2] = size(saida);
        
        matriz_barra_utrs(i,:) = barra_utr(1,:);
        [ncmeas,mconj,nconj,k,det1,cconj]=ffteste(line, nbus, nlin, nmed,num,tipo,loc);

        if controle_inicial == 0
        
            qtd_cconj_ip = zeros(1,qtd_barras); %qtd de cconj de injeção de potência ativa
            qtd_cconj_fp_p = zeros(1,2*(m2-numero_inicial)); %qtd de cconj de fluxo de potência ativa na barra de
            qtd_cconj_fp_n = zeros(1,2*(m2-numero_inicial)); %qtd de cconj de fluxo de potência ativa na barra para
            qtd_medidas_ip = zeros(1,qtd_barras);%qtd de medidas de injeção de potência ativa
            qtd_medidas_fp_p = zeros(1,2*(m2-numero_inicial));%qtd de medidas de fluxo de potência ativa na barra de
            qtd_medidas_fp_n = zeros(1,2*(m2-numero_inicial));%qtd de medidas de fluxo de potência ativa na barra para
            
            controle_inicial = 1;        
        end 

        cconj;
        [matriz_ip,matriz_fp,control_indicador,controle_inicial,qtd_cconj_ip,qtd_cconj_fp_p,qtd_cconj_fp_n,qtd_medidas_ip,qtd_medidas_fp_p,qtd_medidas_fp_n] = ...
            indicadores2(numero_inicial,entrada,saida,qtd_barras,cconj,...
            controle_inicial,control_indicador,qtd_cconj_ip,qtd_cconj_fp_p,qtd_cconj_fp_n,qtd_medidas_ip,qtd_medidas_fp_p,qtd_medidas_fp_n);

        
        medidas_armazena(1,i) = m2;
        obs_critc_armazena(1,i) = k;
        cmeas_armazena(1,i) = ncmeas;
        cconj_armazena(1,i) = mconj; 
        num_conj(1,i) = nconj;
        ind = zeros(1,n1);
        
        
        
    end

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
    
    xlswrite(filename,matriz_ip,'IP');
    xlswrite(filename,matriz_fp,'FP');
    
    filename = 'Resultado_final.xlsx';
    xlswrite(filename,matriz_barra_utrs,'Barras_UTR');
    xlswrite(filename,matriz_barra_utrs_nob,'Barras_UTR_NOB');
    xlswrite(filename,obs_critc_armazena,'Critérios','A1');
    xlswrite(filename,cmeas_armazena,'Critérios','B1');
    xlswrite(filename,cconj_armazena,'Critérios','C1');
    xlswrite(filename,num_conj,'Critérios','D1');
    xlswrite(filename,per_cconj,'Critérios','E1');
    xlswrite(filename,per_cmeas,'Critérios','F1');
    
    
        
end

