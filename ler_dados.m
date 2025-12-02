function [line, z, nbus, nlin, nmed]=ler_dados
%function [dados, carga, line, nbus]=ler_dados
line.num = [];
line.de = [];
line.para = [];
line.r = [];
line.x = [];
line.bsh = [];
rede= load('netdata.txt', '-ascii'); % carrega dados da rede
medidas= load('outmeas.txt', '-ascii');  %carrega dados das medidas
[nlin,col]=size(rede); % identifica o numero de ramos da rede  (nbus)
[nmed,col]=size(medidas); % identifica o numero de medidas  (nmed)
for i = 1 : nlin
    line.num(i)	= 		rede(i,1);
    line.de(i)	= 		rede(i,2);    
    line.para(i)	= 	rede(i,3);
    line.r(i)	= 		rede(i,4);
    line.x(i)	= 		rede(i,5);
    line.bsh(i)	= 		rede(i,6);
end
nbus=max(line.para);
for i = 1 : nmed
    z.num(i)	= 		medidas(i,1);
    z.loc(i)	=       medidas(i,2);
    z.tipo(i)	= 		medidas(i,3);  
    z.true(i)	=       medidas(i,4);
    z.med(i)	= 		medidas(i,5);
    z.var(i)	= 		medidas(i,6);
end
return



