function [controle_check] = confere(pop_ajuste)

[m,n] = size(pop_ajuste);
controle_check = 12;

for i =1:m
    soma = 0;
    for j=1:n
        if pop_ajuste(i,j) == 1
            soma = soma + 1;
        end
    end
    
    if soma > 5
        disp('Possui mais UTRS q o permitido');
        controle_check = i;
        return
    elseif soma <5
        disp('Possui menos UTR do que é permitido');
        controle_check = 0;
        return
    end
end

disp('Tudo normal');


