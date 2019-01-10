
function [seam,im,c] = reduceWidth(im,E)
    [M, P] = seamV_DP(E);
    [seam, c] = bestSeamV(M, P);
    im = removeSeamV(im, seam);
    
end

