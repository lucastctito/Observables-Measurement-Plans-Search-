function inicializar_variaveis(filename)
    % Abre o arquivo
    fid = fopen(filename, 'r');
    
    % Verifica se o arquivo foi aberto corretamente
    if fid == -1
        error('Erro ao abrir o arquivo.');
    end
    
    % Lê todas as linhas do arquivo
    lines = textscan(fid, '%s', 'Delimiter', '\n');
    lines = lines{1}; % Converter de célula para array
    
    % Fecha o arquivo
    fclose(fid);
    
    % Inicializa as variáveis
    for i = 1:numel(lines)
        line = lines{i};
        parts = strsplit(line, '='); % Divide a linha em duas partes pelo sinal de igual
        var_name = strtrim(parts{1}); % Remove espaços em branco
        var_value = str2num(strtrim(parts{2})); % Converte o valor para número
        
        % Atribui o valor à variável
        assignin('base', var_name, var_value);
    end
    
    disp('Variáveis inicializadas com sucesso.');
end

