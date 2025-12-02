function [jaccardIndex,distanceJaccard,jaccard_vector,distance_vector,reset_pop,controle_erro] = jaccard(plan_med_gen_atual,plan_med_gen_anterior,jaccard_vector,distance_vector,controle_erro,reset_pop)
    
    [pa,~] = size(plan_med_gen_atual);
    erro = 10^-1;
    
    intersection = intersect(plan_med_gen_anterior, plan_med_gen_atual, 'rows');
    
    [ia, ~] = size(intersection);
    
    uniaoPlanos = 2*pa-ia;
           
    jaccardIndex = ia/uniaoPlanos;
    distanceJaccard = 1 - jaccardIndex;
    
    jaccard_vector = [jaccard_vector, jaccardIndex];
    
    distance_vector = [distance_vector, distanceJaccard];
    
   if numel(distance_vector) > 2
       ultimotermo = distance_vector(end);
       termoanterior = distance_vector(end-1);

       errorelativo = abs((ultimotermo-termoanterior)/ultimotermo);
       erro;

       if errorelativo < erro
           controle_erro = controle_erro + 1;
       end

       if controle_erro == 3
           reset_pop = 1;
           controle_erro = 0;
       end
   
   end
end

