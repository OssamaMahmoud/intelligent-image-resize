function [seam,c] = bestSeamV(M,P)

    Msize = size(M);
    [c, leastInd] = min(M(Msize(1),:));
    
    r = Msize(1);
    seam = zeros(Msize(1),1);
    seam(r) = leastInd;
    while(r> 1)
        leastInd = P(r, leastInd);

        seam(r-1) = leastInd ;
        r = r - 1;

        
    end
    
    %seam = wrev(seam);

    
