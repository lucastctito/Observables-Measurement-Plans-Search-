function [hamming_dist] = hamming_distance(plan_med)
     
    matrix = plan_med;

    [num_rows, ~] = size(matrix);
    
    % Inicialize a matriz de distâncias de Hamming
    hamming_dist= zeros(num_rows, num_rows);
    
    % Calcule a distância de Hamming para cada par de linhas
    % Calcule a distância de Hamming para cada par de linhas
    for i = 1:num_rows
        for j = i+1:num_rows
            % Calcule a distância de Hamming diretamente comparando os elementos
            hamming_dist(i, j) = sum(xor(matrix(i, :), matrix(j, :)));
            hamming_dist(j, i) = hamming_dist(i, j); % A matriz é simétrica
        end
    end
end

