%Select a solution (Remark 1, resolving the indeterminacy). Written by Michael Hatcher (m.c.hatcher@soton.ac.uk). 
%Any errors are my own. Last updated: 12/04/2023.

%Pick a solution (resolving indeterminacy)
sunspot = rand;

for j=1:k  
 
    if sunspot <= prob(1)
        kstar = 1;  break  %Selected solution at current t
    end
    
    if j>1 && sunspot > sum(prob(1:j-1)) && sunspot <= sum(prob(1:j))
        kstar = j;  break   %Selected solution at current t
    end 
    
end

