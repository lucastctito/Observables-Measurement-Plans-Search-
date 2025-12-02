function [qtd_zero_inobs] = qtd_zeros_H(H,m1)

    qtd_zero_inobs = zeros(1,m1);

    for i = 1:m1
        % Verifica o número de colunas na matriz
        numColunas = size(H, 2);

        % Inicializa o contador de colunas com todos os elementos iguais a zero
        quantidade = 0;

        % Itera sobre cada coluna da matriz
        for coluna = 1:numColunas
            % Verifica se todos os elementos da coluna são zero
            if all(H(:, coluna) == 0)
                quantidade = quantidade + 1;
            end
        end
        
        qtd_zero_inobs(i) = quantidade;
    end
end

