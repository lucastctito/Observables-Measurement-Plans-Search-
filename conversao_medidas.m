function [saida,line,num,tipo,loc,nbus,nlin,nmed] = conversao_medidas(entrada,plan_med,m,numero_inicial)
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
elemento = max(num);
tamanho_pop = num_barra + 2*elemento;
pop = plan_med;
cont = 0;

elementos = (tamanho_pop - num_barra)/2;

saida = zeros(numero_inicial,6);
k1 = 1;
for i =1:num_barra
    if pop(i) == 1
        saida(k1,1) = k1;
        saida(k1,2) = i;
        saida(k1,3) = 1;
        k1 = k1 + 1;
    end
end

pop_fp = zeros(1,2*elementos);
pop_fp_p = zeros(1,elementos);
pop_fp_n = zeros(1,elementos);
pop_fp = pop(num_barra+1:end);
a1 = 1;
a2 = 1;
for i = 1:2*elementos
    check = mod(i,2);
    if check==1
        pop_fp_p(a1) = pop_fp(i);
        a1 = a1 + 1;
    elseif check == 0
        pop_fp_n(a2) = pop_fp(i);
        a2 = a2 + 1;        
    end
end

for i =1:elementos
    if pop_fp_p(i) == 1
        saida(k1,1) = k1;
        saida(k1,2) = i;
        saida(k1,3) = 3;
        k1 = k1 + 1;            
    end
    if pop_fp_n(i) == 1
        saida(k1,1) = k1;
        saida(k1,2) = -i;
        saida(k1,3) = 3;
        k1 = k1 + 1;   
    end
end

for i =1:numero_inicial
    saida(i,4) = rand;
    saida(i,5) = rand;
    saida(i,6) = rand;
end

[nmed,col]=size(saida); % identifica o numero de medidas  (nmed)
num = saida(:,1)';
loc = saida(:,2)';
tipo = saida(:,3)';

end

