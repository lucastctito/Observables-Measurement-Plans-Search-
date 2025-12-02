function [local_utr] = codificacao(barra_utr,num_barra)

   [m1,n1] = size(barra_utr);
   local_utr = zeros(1,num_barra);
   i = 1;
   
   if n1 == 1
       aux = barra_utr(n1);
       local_utr(aux) = 1;
   else
       while i <= n1
            aux = barra_utr(i);
            local_utr(aux) = 1;
            i = i + 1;
       end
   end
end
