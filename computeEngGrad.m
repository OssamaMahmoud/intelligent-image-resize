
function eng = computeEngGrad(im,F)
    imG = ( im(:,:,1) + im(:,:,2) + im(:,:,3) ) ./ 3;
    
    eng = sqrt( applyFilter(imG,F).^2 + applyFilter(imG, F').^2);
    
end
