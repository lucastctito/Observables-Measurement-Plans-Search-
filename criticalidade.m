function [ncmeas,nconj,k] = criticalidade(line, nbus, nlin, nmed,num,tipo,loc,D,H1,H,G,U,p,np,zp,k,cmeas,rn,cconj,critmed,utr,critutr,r,hx,zutr)
% Analise de criticalidades (estrutural P-teta)
% Inicializacoes
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

[D,H1,H,G,U,p,np,zp,k]=observabilidade(line, nbus, nlin, nmed,num,tipo,loc);

R = eye(np); %matriz de covariancia das medidas (identidade)
% Calculo do estado

   
teta1 = inv(G)*H1'*R*zp.med';
teta(2:nbus) = teta1(1:nbus-1);
z2=teta(1)-teta(2); % pode tirar foi soh verificacao
% Calculo do residuo
hx = H*teta';
%jcss%jcsszp.med'
%jcsshx
np1=0;
% Armazena hx apenas para medidas ativas
for i = 1 : nmed;
   if(tipo(i) == 1)
       np1=np1+1;
       hx1(np1)=hx(i);   
   end
   if(tipo(i) == 3)
       np1=np1+1;
       hx1(np1)=hx(i);  
   end
end
%zp.med'
%hx1'
r = zp.med' - hx1';
% Calculo da matriz de covariancia dos residuos
I = R;
E = I - H1*inv(G)*H1';
%zp.med'
%jcss% Calculo do residuo 21mai2014
%jcss21mai2014 r = E*zp.med'
% Calculo do residuo normalizado
for i= 1 : np;
%    if(E(i,i) ~= 0)
    if(abs(E(i,i)) >= 0.000001)
        rn(i)=abs(r(i)/sqrt(E(i,i)));
    else
        rn(i)=0;
    end
end
% Ordenacao dos residuos normalizados (menor para o maior)
rn1(1:np,1)=zp.num; % numero da medida
rn1(1:np,2)=rn(1:np); % valor do residuo normalizado
% ordenacao decrescente
rn1(1:np,3)=-rn(1:np);
rnord = sortrows(rn1,3);
% ordenacao crescente
% rnord = sortrows(rn1,2)
% Identificacao das medidas e conjuntos criticos - Etapa 1
nconj0=0;
nconj=0;
mconj=0;
ncmeas=0;
rnref=rnord(1,2);
if(rnord(1,2) <= 0.000001)
   razrn=0; % quando residuo normalizado for igual a zero (1a medida)
   ncmeas=ncmeas+1;
   cmeas(ncmeas)=rnord(1,1);
end
for i = 2: np;
    if(rnord(i,2) > 0.000001)  
        razrn = rnord(i,2)/rnref; % razao entre dois residuos normalizados subsequentes
    else
        razrn=0; % quando residuo normalizado for igual a zero (outras medidas)
        ncmeas=ncmeas+1;        
        cmeas(ncmeas)=rnord(i,1);
%        rnord(i,2)
    end
    if(razrn >= 0.9999) % inclusao de medida no conjunto
        if(nconj0 == 0)
           mconj=mconj+1;
           nconj=nconj+1; % inicia a formaco de um novo Cset
           j=i-1; % indice para a medida cujo rN eh a primeira referencia
           cconj(mconj,1)=nconj; % 1a coluna contem o numero do conjunto
           cconj(mconj,2)=rnord(j,1); % 2a coluna contem o numero da medida
           mconj=mconj+1;
           cconj(mconj,1)=nconj; 
           cconj(mconj,2)=rnord(i,1);            
        else
           mconj=mconj+1;
           cconj(mconj,1)=nconj;
           cconj(mconj,2)=rnord(i,1);           
        end
        nconj0=1;
    else
        rnref=rnord(i,2); % toma o rN da medida atual como referencia
        nconj0=0;
    end              
end
% Identificacao das medidas e conjuntos criticos - Etapa 2
% medidas criticas
ncmeas1=ncmeas;
if(ncmeas ~= 0)
    for i = 1: ncmeas1;
         if(abs(E(cmeas(i),cmeas(i))) >= 0.00001)
             cmeas(i)=0;  % Medida nao eh critica
             ncmeas=ncmeas-1; % decrementa o numer de Cmeas
         end
    end  
end   

end

