function [pop_code] = mutacao_f(pop_select)
pop_code = pop_select;
[m,n] = size(pop_code);

for i=1:m
    for j =1:n
        c1 = rand;
        if c1 < 0.1 
            if pop_code(i,j) == 1
                pop_code(i,j) = 0;
            else
                pop_code(i,j) = 1;
            end
        end
    end
end

end

