clear all;
clc;

% Exemplo de matriz
matriz = [1, 2, 3; 4, 5, 6; 7, 8, 9];

% Salvar a matriz em um arquivo CSV
csvwrite('matriz.csv', matriz);