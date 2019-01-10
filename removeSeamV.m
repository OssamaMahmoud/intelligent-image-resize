function imOut = removeSeamV(im,seam)
    %must delete one in every row 
    %if we convert the image to a column vector 
    % and remove i + n*rowInd from each column 
    imSize = size(im);
    %n is the number of rows 
    N = linspace(0, imSize(1)*imSize(3)-1, imSize(1)*imSize(3))' ;  %  should be a col vector from 0 to n rows
    % repeat seam 4 times 
    index = repmat(seam, 4, 1) ;
    index = index + N.*imSize(2)   ;  %  index = i + n*rowIndexes
    %represent image as column 
    %permute rowa with col
    imSw = permute(im, [2 1 3]);
    colIm = reshape(imSw, 1, [])   ;
    colIm(index) = [] ;
    imSize = size(imSw);
    imOut = reshape(colIm', imSize(1)-1, imSize(2), imSize(3) ) ;
    imOut = permute(imOut, [2 1 3]);
    
    
    
    
    
    
    
    
end
