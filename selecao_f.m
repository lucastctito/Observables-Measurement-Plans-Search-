function [select] = selecao_f(f_norma,plan_med)
[m,n] = size(f_norma);
intervalo = zeros(n,1)';
intervalo(1) = f_norma(1);

%Seleção
%Roleta
for i=1:n
    if i<n
        intervalo(i+1) = intervalo(i) + f_norma(i+1);
    end
end
j = 1;
for i=1:n
    aleatorio = rand;
    if aleatorio < intervalo(1)
        select(j,:) = plan_med(1,:);
    else
        for i=2:n
            if (aleatorio >=intervalo(i-1)) & (aleatorio<intervalo(i))
                select(j,:) = plan_med(i,:);
            end
        end
    end
    j = j + 1;
end

end

