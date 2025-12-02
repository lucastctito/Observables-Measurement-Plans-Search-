function [plan_med2] = ajuste_2()

qtd_ind2 = 1;
num_barra = 14;

pop = zeros(1,num_barra);
plan_med2 = zeros(qtd_ind2,num_barra);
i = 1;
k =1;

for j = 1:qtd_ind2
    num_utrs = randi(num_barra,1);
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
    plan_med2(j,:) = pop;
    pop = zeros(1,num_barra);
end
zeros(1,num_barra);

    
plan_med2;

end