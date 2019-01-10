%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Performs foreground/background segmentation based on a graph cut
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUT: 
%        im: input image  in double format 
%        scribbleMask: 
%               scribbleMask(i,j) = 2 means pixel(i,j) is a foreground seed
%               scribbleMask(i,j) = 1 means pixel(i,j) is a background seed
%               scribbleMask(i,j) = 0 means pixel(i,j) is not a seed
%        lambda: parameter for graph cuts
%        numClusters: parameter for kmeans
%        inftCost: parameter for infinity cost constraints
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% OUTPUT:   segm is the segmentation mask of the  same size as input image im
%           segm(i,j) = 1 means pixel (i,j) is the foreground
%           segm(i,j) = 0 means pixel (i,j) is the background
%
%           eng_finish: the energy of the computed segmentation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [segm,eng_finish]  = segmentGC(im,scribbleMask,lambda,numClusters,inftyCost)

    [row,col,d] = size(im);

    %First we index image from 1 to n, we could column wise or row wise
    %imL = 1 + (0:row*col-1);
    %imL = reshape(imL, row, col);
    scribbleRow = reshape(scribbleMask.',1,[]);
    dataF = zeros(1, row*col);
    dataB = zeros(1, row*col);

    if (numClusters > 0)
        R = im(:,:,1);
        G = im(:,:,2);
        B = im(:,:,3);

        kmean = kmeans([R(:) G(:) B(:)], numClusters);
        kmeanImg = reshape(kmean, row, col);
        kmean = reshape(kmeanImg.',1,[]);

        %gets all forground kmean image
        fkImg = kmeanImg(scribbleMask == 2);
        bkImg = kmeanImg(scribbleMask == 1);
        
        histF =  ( hist(fkImg, numClusters) + 1 ) ./ (size(fkImg, 1) + numClusters);
        histB =  ( hist(bkImg, numClusters) + 1 ) ./ (size(bkImg, 1) + numClusters);
        costF = -log(histF);
        costB = -log(histB);
        dataF = costF(kmean);
        dataB = costB(kmean);
    end        
        
    %use im and scribble mask to create Db and Df
    im = ( im(:,:,1) + im(:,:,2) + im(:,:,3) ) ./ 3;
    dataF(scribbleRow == 1) = inftyCost;
    dataB(scribbleRow == 2) = inftyCost;

    %now calculate W, based on the stuffs imL, values of im
    sigmaSq = 2*neighbourDiffMean(im);
    rowsW = ( (col-1)*row + (row-1)*col ) *2;
    %rowsW = (col-1) * (row -1) * 4;
    W = zeros(rowsW, 3); 
    i = 1;
    for r = 1:row
        for c = 1:col
            indP = (r-1)*col + c;
            indQ = (r-1)*col + c +1;
            indPd = (r)*col + c;
            if(c == col && r == row)
                
            elseif(c == col)
                %only calculates pD not Q
                P = im(r,c); %gives us the index of the p
                Pd = im(r+1,c) ;
                Wpq = lambda * exp(-1*(P - Pd).^2 / sigmaSq);
           
                W(i, :) = [indP, indPd, Wpq];
                W(i+1, :) = [indPd, indP, Wpq];
            
                i = i + 2;

            elseif(r == row)
                %only calculate Q not pD

                P = im(r,c); %gives us the index of the p
                Q = im(r,c+1) ;
                Wpq =  lambda * exp(-1*(P - Q).^2 / sigmaSq);
            
                W(i, :) = [indP, indQ, Wpq];
                W(i+1, :) = [indQ, indP, Wpq];
                i = i + 2;
            else
                P = im(r,c); 
                Q = im(r,c+1) ;
                Pd = im(r+1,c) ;
                Wpq =  lambda * exp(-1*(P - Q).^2 / sigmaSq);


                W(i, :) = [indP, indQ, Wpq];
                W(i+1, :) = [indQ, indP, Wpq];

                Wpq = lambda * exp(-1*(P - Pd).^2 / sigmaSq);

                W(i+2, :) = [indP, indPd, Wpq];
                W(i+3, :) = [indPd, indP, Wpq];

                i = i + 4;
            end

        end
    end
    

[labels,~,eng_finish] = solveMinCut(dataB,dataF,W);
%segm = ones(row,col);  % return the whole image as the foreground 
segm = reshape(labels, col, row).';

end

function avg = neighbourDiffMean(im)
    sum = 0;
    [row, col, d] = size(im);
    i = 0;
    for r = 1:row
        for c = 1:col
            if(c == col && r == row)

            elseif(c == col)
                %only calculates pD not Q
                P = im(r,c); %gives us the index of the p
                Pd = im(r+1,c) ;
                sum = sum +(P - Pd).^2;
                i = i +1;
            elseif(r == row)
                %only calculate Q not pD
                P = im(r,c); %gives us the index of the p
                Q = im(r,c+1) ;
                sum = sum + (P - Q).^2;
                i = i +1;
            else
                P = im(r,c); %gives us the index of the p
                Q = im(r,c+1) ;
                Pd = im(r+1,c) ;
                sum = sum + (P - Q).^2 + (P - Pd).^2;
                i = i + 2;
            end               
        end
    end
    avg = sum / i;

end
