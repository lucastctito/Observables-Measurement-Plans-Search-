function [plan_med,num_barra] = inicial(entrada,m,qtd_ind,numero_inicial)
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

pop = zeros(1,num_barra);
plan_med = zeros(qtd_ind,num_barra);
i = 1;
k =1;
num_utrs = numero_inicial;
for j = 1:qtd_ind
    for i =1:num_utrs
        barra = randi(num_barra,1);
        if pop(barra) == 0
            pop(barra) = 1;
        elseif pop(barra) == 1
            aux = barra;
            while aux == barra
                c = randi(num_barra,1);
                if pop(c) == 0
                    aux = c;
                end
            end
            pop(aux) = 1;
        end
    end
    plan_med(j,:) = pop;
    pop = zeros(1,num_barra);
end

end

