function [img_output] = MySeamCarving(img,newX,newY)

[originalSizeY, originalSizeX, originalSizeChannels] = size(img);
xDiff = originalSizeX - newX;
yDiff = originalSizeY - newY;

if xDiff > 0
    img = CarvingHelper(img,xDiff);
end

if yDiff > 0
    imgTransposed = permute(img,[2 1 3]);
    imgTransposed = CarvingHelper(imgTransposed,yDiff);
    img = permute(imgTransposed,[2 1 3]);
end

img_output = img;
end

function [img] = CarvingHelper(img,sizeDiff)

for count = 1: sizeDiff
    img_gray = rgb2gray(img);
    
    sobel = fspecial('sobel');
    img_dy = imfilter(img_gray, sobel, 'conv');
    img_dx = imfilter(img_gray, sobel', 'conv');
    img_grad_mag = sqrt(img_dx.^2 + img_dy.^2);
    
    E = img_grad_mag;
    M = E;
    [sizeY, sizeX] = size(img_gray);
    
    for y = 2: sizeY
        for x = 1: sizeX
            if x == 1
                M(y,x) = M(y,x) + min( M(y-1,x), M(y-1,x+1) );
            elseif x == sizeX
                M(y,x) = M(y,x) + min( M(y-1,x-1), M(y-1,x) );
            else
                M(y,x) = M(y,x) + min( M(y-1,x-1), min( M(y-1,x), M(y-1,x+1) ) );
            end
        end
    end
    
    output = zeros(sizeY, sizeX - 1, 3);
    [minValue,minLocation] = min(M(sizeY,1:sizeX));
    
    currRow_r = img(sizeY,:,1);
    currRow_r(minLocation) = [];
    output(sizeY,:,1) = currRow_r;
    
    currRow_g = img(sizeY,:,2);
    currRow_g(minLocation) = [];
    output(sizeY,:,2) = currRow_g;
    
    currRow_b = img(sizeY,:,3);
    currRow_b(minLocation) = [];
    output(sizeY,:,3) = currRow_b;
    
    for y = 1: sizeY-1
        x = minLocation;
        left = -1;
        centre = -1;
        right = -1;
        
        if x == 1
            centre = M(sizeY-y,x);
            right = M(sizeY-y,x+1);
            minValue = min(centre, right);
        elseif x == sizeX
            left = M(sizeY-y,x-1);
            centre = M(sizeY-y,x);
            minValue = min(left, centre);
        else
            left = M(sizeY-y,x-1);
            centre = M(sizeY-y,x);
            right = M(sizeY-y,x+1);
            minValue = min(left, min(centre, right));
        end
        
        if minValue == left
            minLocation = minLocation - 1;
        elseif minValue == right
            minLocation = minLocation + 1;
        end
        
        currRow_r = img(sizeY-y,:,1);
        currRow_r(minLocation) = [];
        output(sizeY-y,:,1) = currRow_r;
        
        currRow_g = img(sizeY-y,:,2);
        currRow_g(minLocation) = [];
        output(sizeY-y,:,2) = currRow_g;
        
        currRow_b = img(sizeY-y,:,3);
        currRow_b(minLocation) = [];
        output(sizeY-y,:,3) = currRow_b;
    end
    img = output;
end
end