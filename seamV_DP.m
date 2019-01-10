
function [M,P] = seamV_DP(E)

Esize = size(E); 
M = zeros(Esize);
P = zeros(Esize);
M(1,:) = E(1,:);
%put zero at start
P(1,:) = -1;
for r = 2:Esize(1)
    for c = 1:Esize(2)
        %boundary check 
        if(c == 1)
            opt1 = intmax;
            opt3 = M(r-1, c+1);
        elseif(c == Esize(2))
            opt3 = intmax;
            opt1 = M(r-1,c-1);
        else
            opt1 = M(r-1,c-1);
            opt3 = M(r-1, c+1);
        end
            opt2 = M(r -1, c);

        if (opt1 <= opt2 && opt1 <= opt3)
            M(r,c)= E(r,c) + M(r-1,c-1);
            P(r,c)=c-1;
        
        elseif (opt2 <= opt1 && opt2 <= opt3)
            M(r,c)= E(r,c) + M(r-1,c);
            P(r,c)= c;
 
        else
            M(r,c)= E(r,c) + M(r-1,c+1);
            P(r,c)= c+1;
        end
        
    end
end