function [vetor_medidas,obs_critc,cmeas_1,cconj_1] = quantidade_medidas(plan_med,entrada,m,numero_inicial)
    [m1,n1] = size(plan_med);
    ind = zeros(1,n1);
    obs_critc = zeros(1,m1);
    cmeas_1 = zeros(1,m1);
    cconj_1 = zeros(1,m1);
    vetor_medidas = zeros(1,m1);
    vetor_utrs = zeros(1,m1);
    cont = 0;
    
    for i = 1:m1
        ind = plan_med(i,:);
        [saida,line,num,tipo,loc,nbus,nlin,nmed] = conversao_medidas(entrada,ind,m,numero_inicial);
        [m2,n2] = size(saida);
        saida;
        [ncmeas,mconj,nconj,k,det1,cconj,cmeas]=ffteste(line, nbus, nlin, nmed,num,tipo,loc);
        
        [m2,n2] = size(saida);
        
        obs_critc(1,i) = k;
        cmeas_1(1,i) = ncmeas;
        cconj_1(1,i) = mconj;
  
        vetor_medidas(1,i) = m2;
        ind = zeros(1,n1);
    end

end
