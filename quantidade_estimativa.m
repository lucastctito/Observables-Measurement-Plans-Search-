function [obs_critc] = quantidade(plan_med,entrada,m)
    [m1,n1] = size(plan_med);
    ind = zeros(1,n1);
    obs_critc = zeros(1,m1);
    cmeas_1 = zeros(1,m1);
    cconj_1 = zeros(1,m1);
    vetor_medidas = zeros(1,m1);
    vetor_utrs = zeros(1,m1);
    vetor_barra = zeros(m1,14);
    qtd_zero_inobs = zeros(1,m1);
    
    for i = 1:m1

        ind = plan_med(i,:);
        [saida,barra_utr,line,num,tipo,loc,nbus,nlin,nmed] = conversao(entrada,ind,m);
        [m2,~] = size(saida);
    
        [ncmeas,mconj,nconj,k,det1,cconj,cmeas,H,G]=ffteste(line, nbus, nlin, nmed,num,tipo,loc);
        %[k,qtd_zero_inobs, H] = avaliar_rede(line, nbus, nlin, nmed,num,tipo,loc,m1);
        
        [linha_h_obs,coluna_h_obs] = size(H);
        [m1,n1] = size(vetor_barra);
        
        for j = 1:coluna_h_obs
            soma = 0;
            for l = 1:linha_h_obs
                soma = soma + H(l,j);
                vetor_barra(i,j) = soma;
            end
        end
               
        obs_critc(1,i) = k;
    end

    
end
