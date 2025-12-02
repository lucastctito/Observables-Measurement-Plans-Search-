function [vetor_medidas,vetor_utrs,obs_critc, saida,barra_utr,qtd_zero_inobs,soma_elementos_nao_nulos,tabelaHash] = quantidade(plan_med,entrada,m,tabelaHash,tamanhoTabela)
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
    
        %[ncmeas,mconj,nconj,k,det1,cconj,cmeas,H,G]=ffteste(line, nbus, nlin, nmed,num,tipo,loc);
        [k,quantidade_zeros, H] = avaliar_rede(line, nbus, nlin, nmed,num,tipo,loc);
        
        if k == 0
           tabelaHash = Hash(tabelaHash, ind,tamanhoTabela);
        end
        
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
        qtd_zero_inobs(1,i) = quantidade_zeros;
        
        soma = 0;
        for j = 1:m2
            if saida(j,3) == 1
                soma = soma + 1;
                vetor_utrs(1,i) = soma;
            end
        end
        vetor_medidas(1,i) = m2;
        ind = zeros(1,n1);
             
    end

    
    vetor_barra = abs(vetor_barra);
    [obs_m,~] = size(vetor_barra);
    
    soma_elementos_nao_nulos = zeros(1,obs_m);
   
    for i = 1:obs_m

        soma_elementos_nao_nulos(i) = sum(abs(nonzeros(H)));
    end
    
end
