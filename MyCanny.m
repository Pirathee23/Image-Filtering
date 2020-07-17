function canny = MyCanny(img, sigma, thresh)

    %Gaussian Blur
   % Gaussian_filter = fspecial('gaussian',[3 3],sigma);
   % img_out= imfilter (img,Gaussian_filter,'same');
    

    Gfilter_x = fspecial('gaussian',[3 1], sigma);
    Gfilter_y = fspecial('gaussian',[1 3], sigma);
    img_out_1 = conv2 (img, Gfilter_x,'same');
    img_out = conv2 (img_out_1, Gfilter_y,'same');

    
    %Gradient Magnitude
    sobel_filter = fspecial('sobel');
    img_dy = imfilter(img_out, sobel_filter, 'conv');
    img_dx = imfilter(img_out, sobel_filter', 'conv');
    grad_mag = sqrt(img_dx.^2 + img_dy.^2);
    grad_orientation = atan2(img_dy, img_dx);
    
    %Threshold
    img_thresh = grad_mag > thresh/255;
    
    %NMS -Zero Padding          
    [img_h,img_w,p] = size(img_thresh);  
    filter_height = 3;
    filter_width = 3;
    mod_filter_h = floor (filter_height / 2);
    mod_filter_w = floor (filter_width / 2);
    padx = img_w + (2*mod_filter_w);
    pady = img_h + (2*mod_filter_h);

    img_zero_pad = zeros(pady,padx);
    for j= pady-img_h : pady-mod_filter_h
        for i=padx-img_w : padx-mod_filter_w
            img_zero_pad(j,i)=img_thresh(j-mod_filter_h, i-mod_filter_w);
        end
    end
    
    for j=2*mod_filter_h : pady-mod_filter_h
        for i=2*mod_filter_w : padx-mod_filter_w
            original_value = img_zero_pad(j,i);
            maximum = 0;
            rad=abs(grad_orientation(j-1,i-1));
            for y = 1:filter_height
                for x = 1: filter_width
                    if rad>=5.89 | rad<0.39 | (rad>=2.75 & rad<3.53) %Horizontal
                        %pixel_value = img_zero_pad(j - mod_filter_h + y-1, i - mod_filter_w + x-1);
                        if (img_zero_pad(j+1,i)>img_zero_pad(j,i)) || (img_zero_pad(j-1,i)>img_zero_pad(j,i))
                           img_zero_pad(j,i)=0;
                        end                        
                    elseif (rad>=1.18 & rad<1.96) | (rad>=4.32 & rad<5.11) %Vertical
                        if (img_zero_pad(j,i+1)>img_zero_pad(j,i)) || (img_zero_pad(j,i-1)>img_zero_pad(j,i))
                           img_zero_pad(j,i)=0;
                        end                         
                    elseif (rad>=1.96 & rad<2.75) | (rad>=5.11 & rad<5.89) %Diagonal \
                        if (img_zero_pad(j+1,i+1)>img_zero_pad(j,i)) || (img_zero_pad(j-1,i-1)>img_zero_pad(j,i))
                           img_zero_pad(j,i)=0;
                        end                        
                    elseif (rad>=0.39 & rad<1.18) | (rad>=3.53 & rad<4.32) %Diagonal /
                        if (img_zero_pad(j+1,i-1)>img_zero_pad(j,i)) || (img_zero_pad(j-1,i+1)>img_zero_pad(j,i))
                           img_zero_pad(j,i)=0;
                        end                   
                    end
                end
            end
            %canny(j-mod_filter_h,i-mod_filter_w) = img_zero_pad(j,i);
        end
    end
    canny=img_zero_pad;
end
