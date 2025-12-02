clear all;
clc;

entrada = load('netdata.txt');
[m,n] = size(entrada);

plano = [1     0     1     0     0     1   0     0     0     0     1     1     0     1]
[vetor_medidas,vetor_utrs,obs_critc,cmeas_1,cconj_1,H,G,saida,barra_utr] = quantidade(plano,entrada,m);

saida;

H;

H_inobs = H;
vetor_barra_inobs = zeros(1,14);

[linha_h_inobs, coluna_h_inobs] = size(H_inobs);

for j = 1:coluna_h_inobs
    soma = 0;
    for i = 1:linha_h_inobs
         soma = soma + abs(H_inobs(i,j));
         vetor_barra_inobs(1,j) = soma;
    end
end
barra_utr;
vetor_barra_inobs;

[m1,n1] = size(barra_utr)

plano_temp = plano;

for i =1:14
    plano_temp = plano;
    if vetor_barra_inobs(1,i) == 0
        temp = i
        [z,m] = max(vetor_barra_inobs)
        plano_temp(1,m)
        plano_temp(1,m) = 0;
        plano_temp(1,m)
        plano_temp(1,temp) = 1
        [vetor_medidas,vetor_utrs,obs_critc,cmeas_1,cconj_1,H,G,saida,barra_utr] = quantidade(plano_temp,entrada,m);      
    end   
end

a = [1 0 1;
     0 1 1;
     1 1 0];
 
b = [1 0 1;
    1 0 0;
    0 1 1];

diff =xor(a,b);
d = sum(diff)

m = 3;
n =3;

for i = 1:m
    for j = 1:m
        
        temp_a = a(j,:)
        temp_b = b(i,:)
   
        diff = xor(temp_a,temp_b);
        d = sum(diff)
    end
end





















