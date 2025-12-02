function [pop_tournament] = selecao_torneio(plan_med,f)
    
    [popSize,n] = size(plan_med);
    tournamentSize = 5;
    
    pop_tournament = zeros(popSize,n);
    fitness = f;
    
    % Seleção por torneio
    selectedIndices = zeros(popSize, 1);
    for i = 1:popSize
        tournamentIndices = randi(popSize, tournamentSize, 1);
        [~, winnerIndex] = min(fitness(tournamentIndices));
        selectedIndices(i) = tournamentIndices(winnerIndex);
    end
    
   for i = 1:popSize
        index = selectedIndices(i);
        pop_tournament(i,:) = plan_med(index,:);
   end
 
end

