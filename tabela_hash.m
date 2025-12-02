clear all;
clc;

% Número de elementos
numElementos = 359;
function tabelaHash = tabela_hash(fatorCarga,infoMemoria,numElementos,tamanhoTabela,tabelaHash)

% Obtém informações sobre a memória do sistema
infoMemoria = memory;
memoriaDisponivel = infoMemoria.MemAvailableAllArrays;

% Fator de carga desejado
fatorCarga = 0.6;

% Define o tamanho da tabela
tamanhoTabela = definirTamanhoTabela1(numElementos, fatorCarga)
%tamanhoTabela = definirTamanhoTabela2(numElementos, memoriaDisponivel, fatorCarga)

% Cria a tabela hash com o tamanho definido
tabelaHash = zeros(1, tamanhoTabela);

numBinario = bi2de(vetor);


 numBinario
 tamanhoTabela
 % Mapeia o hash para o intervalo [1, tamanhoTabela]
 indiceTabela = mod(numBinario, tamanhoTabela) + 1
 
 controle_hash = 0;
while controle_hash ~=1
    
    if tabelaHash(indiceTabela) == 0
        tabelaHash(indiceTabela) = numBinario;
        controle_hash = 1;
    else
        if tabelaHash(indiceTabela) == numBinario
            controle_hash = 1;
            return;
        else
            tentativa = 1;
            maxTentativas = 0
            novoIndice = funcaoColisaoLinearMulti(indiceOriginal, tentativa, tamanhoTabela, maxTentativas,tabelaHash);
            indiceTabela = novoIndice;
        end
    end
 
end

 aux = tabelaHash(indiceTabela);
 function vetorBinario = converter_base(aux)
 
    numeroBinario = dec2bin(aux)

    numeroBinarioString = dec2bin(numeroBinario); 
    vetorBinario = zeros(1, length(numeroBinarioString));

    for i = 1:length(numeroBinarioString)
        vetorBinario(i) = str2num(numeroBinarioString(i));
    end
    
 end

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

function novoIndice = funcaoColisaoLinearMulti(indiceOriginal, tentativa, tamanhoTabela, maxTentativas,tabelaHash)
    % Função de colisão linear com múltiplas tentativas
    while maxTentativas ~= 1
        novoIndice = mod(indiceOriginal + tentativa + i - 2, tamanhoTabela) + 1;
        % Verifica se a posição está vazia
        % Se sim, retorna o novo índice
        if tabelaHash(novoIndice) == 0
            maxTentativas = 1;
            return;
        end
    end
    % Se atingir o número máximo de tentativas, retorna -1 (nenhum índice encontrado)
    novoIndice = -1;
end

end
