function [ outIm ] = applyFilter( im, F )
%UNTITLED Summary of this function goes here

%find size of F and k(deviation from centre), and apply to sum function
%1/(F.h * F.w) * SUM from -k to +k do OR we could just iteratively go
%through our filter and multiply by each F(u, v) for 


    im = im2double(im);
    %find k 
    
    halfK1 = floor(size(F, 1)/2);
    halfK2 = floor(size(F, 2)/2);
    
    %resize im to have padding on the sides,by a value of k
    imR = padarray(im, [halfK1, halfK2]);
    outIm = zeros(size(imR));
    %we are gonna set each pixel of im by the 
    %result of the sum of H(u,v)imR(u + x, v + y);
    rBorder = halfK1 + 1;
    tBorder = halfK2 + 1;
    lBorder =  size(imR,1) - halfK1;
    bBorder =  size(imR,2) - halfK2;
    for x = rBorder: 1 : lBorder  
        for y = tBorder: 1 : bBorder  
            %subselect part to correlate on
            cur = imR( x - halfK1 : x + halfK1,  y - halfK2 : y+halfK2 );
            outIm(x,y) = sum(sum(cur .* F));
        end
    end
    outIm = outIm(rBorder: lBorder, tBorder: bBorder ) ;
    
    %s = 2.4648e+04
    %horizontal edge detection 

    
end

