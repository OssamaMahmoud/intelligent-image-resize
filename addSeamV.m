function imOut = addSeamV(im,seam)
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
    
    colOut = zeros(1, size(colIm,2) + size(index,1));
    i = 1;
    j = 1;
    while i <= length(colIm)
        colOut(j) = colIm(i);
        if(ismember(i, index))
            j = j + 1;
            colOut(j) = colOut(j-1);

        end
        i = i + 1;
        j = j + 1;
    end
        
    imSize = size(imSw);
    imOut = reshape(colOut', imSize(1)+1, imSize(2), imSize(3) ) ;
    imOut = permute(imOut, [2 1 3]);
    
    
