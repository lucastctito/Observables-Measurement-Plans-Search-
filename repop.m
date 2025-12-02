function [plan_med_novo] = repop(pop_elite,plan_med,entrada,m,qtd_ind,numero_inicial)

[m_plan,n_plan] = size(plan_med);
[m_elite,n_elite] = size(pop_elite)

plan_med_novo = zeros(m_plan,n_plan);

for i =1:m_elite
    plan_med_novo(i,:) = pop_elite(i,:);
end

qtd_nova = qtd_ind-m_elite;

[plan_random,num_barra] = inicial(entrada,m,qtd_nova,numero_inicial);

[m_random,n_random] = size(plan_random)

j =1;
while j<=m_random
    for i =m_elite+1:m_plan
        plan_med_novo(i,:) = plan_random(j,:);
    end
    j=j+1;
end

end

