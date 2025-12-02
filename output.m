function result = output(saida,custo_utr_best,custo_med_best,best,barra_utr,best_obs,best_med,best_cconj)
% Imprime resultados
fid = fopen('outfile.doc', 'w');
[m,n] = size(saida);

fprintf(fid,'    ---------------- Melhor solução do sistema -------------------------\n');
fprintf(fid,'------------------------------------------------------------------------\n');
A = saida(:,1);
B = saida(:,2);
C = saida(:,3);
D = saida(:,4);
E = saida(:,5);
F = saida(:,6);
MEAS = [A B C D E F];
fprintf(fid,'                                                                        \n');
fprintf(fid,'                                                                        \n');
fprintf(fid,'------------------------------------------------------------------------\n');
fprintf(fid,'                      Measurement Data                                  \n');
fprintf(fid,'------------------------------------------------------------------------\n');
fprintf(fid,' Meas     Loc     Type      Ztrue (pu)     Zmeas (pu)    Variance  \n');
fprintf(fid,'------------------------------------------------------------------------\n');
for i = 1 : m;
   fprintf(fid,' %3g     %3g     %3g        %8.5f       %8.5f     %8.5f \n', MEAS(i,:));
end  
fprintf(fid,'------------------------------------------------------------------------\n');


[m2,n2] = size(barra_utr);

fprintf(fid,'                                                                        \n');
fprintf(fid,'                                                                        \n');
fprintf(fid,'    --------------- Observabilidade e medida crítica-------------\n');
fprintf(fid,'                                                                        \n');
if best_obs == 0   
    fprintf(fid,'O sistema é observável\n');
    fprintf(fid,'Medidas críticas: %d\n', best_med);
    fprintf(fid,'Medidas de conjuntos críticos: %d\n', best_cconj);
    fprintf(fid,'------------------------------------------------------------------------\n\n');
else
    fprintf(fid,'O sistema não é observável\n');
    fprintf(fid,'------------------------------------------------------------------------\n\n');
end
fprintf(fid,'\n\n');
fprintf(fid,'\n\n');
fprintf(fid,'                                                                        \n');
fprintf(fid,'                                                                        \n');
fprintf(fid,'        --------------- Custo do plano de medição-------------\n');
fprintf(fid,'                                                                        \n');
fprintf(fid,'Custo das UTRS: %d\n', custo_utr_best);
fprintf(fid,'Custo de medidores: %d\n', custo_med_best);
fprintf(fid,'Melhor custo para o plano de medição: %d\n', best);
fprintf(fid,'------------------------------------------------------------------------\n\n');
fprintf(fid,'                                                                        \n');      
fprintf(fid,'Barras onde as UTRS estão localizadas: %d\n');
fprintf(fid,'                                                                        \n\n');  
for i = 1 : n2; 
        fprintf(fid,  '  %4g \n', barra_utr(i));
end
result = 1;
return