function [tabelaHash,tamanhoTabela] = iniciar_hash(numElementos,fatorCarga)
    
    % Obtém informações sobre a memória do sistema
    infoMemoria = memory;
    memoriaDisponivel = infoMemoria.MemAvailableAllArrays;

    %fatorCarga = 0.4;
    
    tamanhoTabela = definirTamanhoTabela1(numElementos, fatorCarga);   
   tabelaHash = cell(1, tamanhoTabela);

    function tamanhoTabela1 = definirTamanhoTabela1(numElementos, fatorCarga)
        % Determina quanto da memória disponível você deseja alocar para a tabela hash
        tamanhoInicial = numElementos/fatorCarga; % Por exemplo, alocar 50% da memória disponível
        tamanhoTabela1 = ceil(tamanhoInicial / fatorCarga);
        tamanhoTabela1 = max(tamanhoTabela1, numElementos);
    end    

    function tamanhoTabela2 = definirTamanhoTabela2(numElementos, memoriaDisponivel, fatorCarga)
        % Determina quanto da memória disponível você deseja alocar para a tabela hash
        percentualMemoria = 0.00005; % Por exemplo, alocar 50% da memória disponível

        % Calcula o tamanho da tabela com base no fator de carga e memória disponível
        tamanhoTabela2 = floor((memoriaDisponivel * percentualMemoria) / (4 * fatorCarga * numElementos)); % Assumindo 4 bytes por elemento na tabela
    end

end

