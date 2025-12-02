function [saida,barra_utr,line,num,tipo,loc,nbus,nlin,nmed] = conversao(entrada,plan_med,m)
line.num = [];
line.de = [];
line.para = [];
line.r = [];
line.x = [];
line.bsh = [];

[nlin,col] = size(entrada); % identifica o numero de ramos da rede  (nbus)
for i = 1 : nlin
    line.num(i)	= 		entrada(i,1);
    line.de(i)	= 		entrada(i,2);    
    line.para(i)	= 	entrada(i,3);
    line.r(i)	= 		entrada(i,4);
    line.x(i)	= 		entrada(i,5);
    line.bsh(i)	= 		entrada(i,6);
end
nbus=max(line.para);
%Criação da matriz de medidas
barra_de = entrada(:,2);
barra_para = entrada(:,3);
num = entrada(:,1)';
r_pu = entrada(:,4);
x_pu = entrada(:,5);
s = entrada(:,6);

saida = zeros(1,6);
matriz = zeros(nlin,2);
matriz(:,1) = barra_de;
matriz(:,2) = barra_para;
matriz = matriz(:);
num_barra =max(matriz); %Número de barras
pop = plan_med;
cont = 0;

for i=1:num_barra
    if pop(i) == 1
        cont = cont + 1;
    end
end

barra_utr = zeros(1,cont);
k = 1;

for i =1:num_barra
    if pop(i) == 1
       barra_utr(k) = i;
       k = k + 1;
    end 
end

for i = 1:num_barra    
    if pop(i) == 1
        saida(1,1) = 1;
        saida (1,2) = i;
        saida(1,3) = 1;
        break
    end
end

aux = 0;
k = 1;
for i =1:cont
    aux = barra_utr(i);
    if aux == barra_utr(i)
        saida = [saida;zeros(1,6)];
        saida(k+1,1) = saida(k,1) + 1;
        saida(k+1,2) = barra_utr(i);
        saida(k+1,3) = 1;
        saida(k+1,4) = rand;
        saida(k+1,5) = rand;
        saida(k+1,6) = rand;
        k = k + 1;
    end
    for j =1:nlin
        if aux == barra_de(j)
            saida = [saida;zeros(1,6)];
            saida(k+1,1) = saida(k,1) + 1;
            saida(k+1,2) = num(j);
            saida(k+1,3) = 3;
            saida(k+1,4) = rand;
            saida(k+1,5) = rand;
            saida(k+1,6) = rand;
            k = k + 1;
        elseif aux == barra_para(j)
            saida = [saida;zeros(1,6)];
            saida(k+1,1) = saida(k,1) + 1;
            saida(k+1,2) = -num(j);
            saida(k+1,3) = 3;
            saida(k+1,4) = rand;
            saida(k+1,5) = rand;
            saida(k+1,6) = rand;
            k = k + 1;
        end
    end
end
saida(1,:) = [];
[m1,n1] = size(saida);
for i =1:m1
    saida(i,1) = saida(i,1) - 1;
end

%Ordenação da matriz de medidas
saida = sortrows(saida,3);

for i =1:m1
    saida(i,1) = i;
end
[nmed,col]=size(saida); % identifica o numero de medidas  (nmed)
num = saida(:,1)';
loc = saida(:,2)';
tipo = saida(:,3)';

end

