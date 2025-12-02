function [plan_med,num_barra,tamanho_pop] = inicial_medidas(entrada,m,qtd_ind,numero_inicial)

barra_de = entrada(:,2);
barra_para = entrada(:,3);
num = entrada(:,1)';
r_pu = entrada(:,4);
x_pu = entrada(:,5);
s = entrada(:,6);

matriz = zeros(m,2);
matriz(:,1) = barra_de;
matriz(:,2) = barra_para;
matriz = matriz(:);
num_barra =max(matriz);
elemento = max(num);
tamanho_pop = num_barra + 2*elemento;


pop = zeros(1,tamanho_pop);
plan_med = zeros(qtd_ind,tamanho_pop);
i = 1;
k =1;
num_elementos = numero_inicial;
for j = 1:qtd_ind
    for i =1:num_elementos
        barra = randi(tamanho_pop,1);
        if pop(barra) == 0
            pop(barra) = 1;
        elseif pop(barra) == 1
            aux = barra;
            while aux == barra
                c = randi(tamanho_pop,1);
                if pop(c) == 0
                    aux = c;
                end
            end
            pop(aux) = 1;
        end
    end
    plan_med(j,:) = pop;
    pop = zeros(1,tamanho_pop);
end

end

