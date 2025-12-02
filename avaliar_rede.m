function [k,quantidade_zeros, H] = avaliar_rede(line, nbus, nlin, nmed,num,tipo,loc)

% Analise de criticalidades (estrutural P-teta)
% Inicializacoes
warning('off','all');
zp.num = [];       
zp.tipo = [];
zp.loc = [];
zp.med = [];
zp.var = [];
zutr = [];
hx = [];
r = [];
rn = [];
H = [];
cconj = [];
np=0;
nconj = 0;
for i = 1 : nmed;
    rn(i)=0;
    cmeas(i)=0;
    cconj(i,1)=0;
    cconj(i,2)=0;
    critmed(i)=0;
    for j = 1 : nbus;
        H(i,j)=0;
        utr(j)=0;
        critutr(j)=0;        
    end
end
% Prepara o problema P-teta (somente injecoes e fluxos ativos)
for i = 1 : nmed;
   if(tipo(i) == 1)
       np=np+1;
       zp.num(np) = num(i);
       zp.tipo(np) = tipo(i);
       zp.loc(np) = loc(i);
       zp.med(np) = np; % medidas com valor inteiro sequencial
%       zp.med(np) = 1; % medidas com valor unitario (iguais)
       zp.var(np) = 1;   
   end
   if(tipo(i) == 3)
       np=np+1;
       zp.num(np) = num(i);
       zp.tipo(np) = tipo(i);
       zp.loc(np) = loc(i);
%       zp.med(np) = np; % medidas com valor inteiro sequencial
       zp.med(np) = 1;
       zp.var(np) = 1;   
   end
end
% Montagem matriz Jacobiano
for i = 1 : np;
    if(zp.tipo(i) == 1)  %medida de injecao
        ibus = zp.loc(i);
%        H(i,ibus) = H(i,ibus)+1;
        for j = 1 : nlin;
             if(line.de(j) == ibus)
                H(i,ibus) = H(i,ibus)+1; %elemento diagonal
                H(i,line.para(j))=-1;  %elemento fora da diagonal
            end
            if(line.para(j) == ibus)
                H(i,ibus) = H(i,ibus)+1; %elemento diagonal
                H(i,line.de(j))=-1;  %elemento fora da diagonal
            end
        end
    end
    if(zp.tipo(i) == 3) %medida de fluxo
        ibus = abs(zp.loc(i));
        if(zp.loc(i) > 0)
            H(i,line.de(ibus)) = 1;
            H(i,line.para(ibus)) = -1; 
        else
            H(i,line.de(ibus)) = -1;
            H(i,line.para(ibus)) = 1;            
        end
    end   
end
H1 = H(1:np,2:nbus);
% Calculo da matriz de ganho
G = H1'*H1;  %matriz de ganho  
det1 = abs(det(G)); %determinante da matriz de ganho 
[U,p] = chol(G);

        numColunas = size(H1, 2);

                % Inicializa o contador de colunas com todos os elementos iguais a zero
        quantidade_zeros = 0;

                % Itera sobre cada coluna da matriz
        for coluna = 1:numColunas
                    % Verifica se todos os elementos da coluna são zero
            if all(H1(:, coluna) == 0)
                quantidade_zeros = quantidade_zeros + 1;
            end
        end

        % Calculo da matriz de ganho
        
        if quantidade_zeros == 0
            
            G = H1'*H1;  %matriz de ganho  
            det1 = abs(det(G)); %determinante da matriz de ganho 

            [U,p] = chol(G);
            if(det1 <= 0.00001)
                k = 1;
                return
            else
                k = 0;   
            end
        else
            k = 1;
        end
 end


