
function eng = computeEng(im4,F,W,maskWeight)
    eng = computeEngGrad(im4(:, :, 1 : 3), F)+computeEngColor(im4(:, :, 1 : 3), W)+maskWeight*im4(:, :, 4);
end
