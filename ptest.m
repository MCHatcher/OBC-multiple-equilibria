function [r]=ptest(M)

% Written by Michael Tsatsomeros
% (https://www.math.wsu.edu/faculty/tsat/matlab.html)
% Return r=1 if `M' is a real P-matrix (r=0 otherwise).  

n=length(M);
if M(1,1)<=0
     r=0;
elseif n==1
     r=1;   
else
     for ii=2:n
           d(ii,1)=M(ii,1)/M(1,1);
           for jj=2:n
              b(ii-1,jj-1)=M(ii,jj);
              c(ii-1,jj-1)=M(ii,jj)-d(ii,1)*M(1,jj);
           end
     end  
     r1=ptest(b);
     r2=ptest(c);
     r=r1*r2;
end

