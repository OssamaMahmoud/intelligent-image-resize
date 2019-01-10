
function eng = computeEngColor(im,W)
    eng = im(:,:,1).*W(3) + im(:,:,2).*W(2) + im(:,:,3).*W(3);

end
