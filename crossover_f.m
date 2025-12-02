function [pop_c] = crossover_f(pop_select,numero_inicial)
b = pop_select;
[m,n] = size(b);

v = zeros(1,n);
w = zeros(1,n);
v_novo = zeros(1,n);
w_novo = zeros(1,n);
matriz_nova = b;

k =1;
for j = 2:2:m
    v(1,:) = b(j-1,:);
    w(1,:) = b(j,:);
%one-point
    c = randi(n);

    if c~=1
        for i = 1:c
            aux1 = v(i);
            aux2 = w(i);
            matriz_nova(j-1,i) = aux2;
            matriz_nova(j,i) = aux1;     
        end
    end
 k =k+1;
end

pop_c = matriz_nova;
[linha_pop,coluna_pop] = size(pop_c);



