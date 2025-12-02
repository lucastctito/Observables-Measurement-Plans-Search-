function [best_final,best_plan_final] = minimo(best,best_final,best_plan,I)

if best < best_final
    best_final = best;
    best_plan_final(1,:) = best_plan(1,:);
end

end

