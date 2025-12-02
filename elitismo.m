function [pop_elite] = elitismo(plan_med,f,f_norma,taxa_elitismo )


[m_plan,n_plan] = size(plan_med);
pop_elite = zeros(1,n_plan);


A = [plan_med f'];
[m,n] = size(A);
A = sortrows(A, n);


%taxa_elitismo = 0.1;

A_elite = A(1:round(taxa_elitismo*m_plan), :);

%plan_med_sorted = A(:, 1:n-1);

pop_elite = A(1:round(taxa_elitismo*m_plan), 1:n-1);
%pop_elite = plan_med_sorted


end



