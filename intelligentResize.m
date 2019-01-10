%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Performs an intelligent image resize based on a map of important pixels 
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUT: 
%        im: a colour image to resize
%        v: the number of vertical seams to insert or delete
%        h:the number of horizontal seams to insert or delete
%        W:the weight vector W for the color energy
%        mask:the mask image with its weight maskWeight.
%        
%        The sign of v and h signal insertion/removal of seams. 
%        Positive sign means seam insertion, negative seam removal. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% OUTPUT:   totalCost: the total cost or the number of seams removed
%           imOut the output of the resizing 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [totalCost,imOut] = intelligentResize(im,v,h,W, mask,maskWeight)
    im4 = cat(3, im, mask);
    F = [-1 0 1];
    totalCost = 0;
    while( h ~= 0 || v ~= 0)
        E = computeEng(im4, F, W, maskWeight);
        
        if(h > 0)
            [~, im4, c] = increaseHeight(im4, E);
            totalCost = totalCost + c;
            h = h - 1;
        elseif(h < 0)
            [~, im4, c]  = reduceHeight(im4, E);              
            totalCost = totalCost + c;
            
            h = h + 1;
        end
        
        E = computeEng(im4, F, W, maskWeight);
        if(v > 0)
            [~, im4, c] = increaseWidth(im4,E); 
             totalCost = totalCost + c;
             v = v - 1;
        elseif(v < 0)
            [~, im4, c] = reduceWidth(im4,E); 
             totalCost = totalCost + c;
             v = v + 1;
        end
        
    end
    imOut = im4(:, :, 1 : 3);
end

