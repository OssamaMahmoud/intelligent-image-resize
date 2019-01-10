% reduces height of the image by one pixel using seam carving

function [seam,im,c] = increaseHeight(im,E)
    im4T = trans(im);
    [seam, im4Out, c] = increaseWidth(im4T,E');
    im = trans(im4Out);

end

function im4Out = trans(im4)
    im4Out(:,:,1) = im4(:,:,1)';
    im4Out(:,:,2) = im4(:,:,2)';
    im4Out(:,:,3) = im4(:,:,3)';
    im4Out(:,:,4) = im4(:,:,4)';

end