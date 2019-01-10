# Intelligent Image Resizing  
Matlab implementation of seam carving to resize images.  
This algorithm minimizes the amount of important information removed in an image when resizing  
To resize an image call:  
	intelligentResize(im,v,h,W, mask,maskWeight)  
	im: a colour image to resize  
        v: the number of vertical seams to insert or delete  
        h:the number of horizontal seams to insert or delete  
        W:the weight vector W for the color energy  
        mask:the mask image with its weight maskWeight  
        The sign of v and h signal insertion/removal of seams  
        Positive sign means seam insertion, negative seam removal  

## Example input image  
![alt text](cat.png)  
## Example result image  
![alt text](catResized.png)  
