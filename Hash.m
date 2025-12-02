function [tabelaHash] = Hash(tabelaHash, ind,tamanhoTabela)

    % Inicializa o vetor e converte em uma string binária
    binaryString = num2str(ind);  % ou 'sprintf('%0*b', numBits, ind)' se precisar de padding
    
    % Converte para número binário
    numBinario = bi2de(ind);

    % Mapeia o hash para o intervalo [1, tamanhoTabela]
    indiceTabela = mod(numBinario, tamanhoTabela) + 1;
    
    % Controle para inserir na tabela hash
    controle_hash = 0;
    while controle_hash ~= 1
        if isempty(tabelaHash{indiceTabela})  % Verifica se a célula está vazia
            tabelaHash{indiceTabela} = binaryString;  % Armazena a string binária
            controle_hash = 1;  % Quebra o loop, pois já foi inserido
        else
            %disp('Já existe uma string neste índice.');
            controle_hash = 1;  % Ação de controle, quebra o loop
        end
    end

    function novoIndice = funcaoColisaoLinearMulti(indiceOriginal, tentativa, tamanhoTabela, maxTentativas,tabelaHash)
        % Função de colisão linear com múltiplas tentativas
        i = 1;
        while maxTentativas ~= 1
            i
            novoIndice = mod(indiceOriginal + i - 1, tamanhoTabela) + 1;
            % Verifica se a posição está vazia
            % Se sim, retorna o novo índice
            if tabelaHash(novoIndice) == 0
                maxTentativas = 1;
                return;
            end
            i = i + 1;
            
            if i > tamanhoTabela
                maxTentativas = 1;
            end
            
        end
        % Se atingir o número máximo de tentativas, retorna -1 (nenhum índice encontrado)
        novoIndice = -1;
    end
end

