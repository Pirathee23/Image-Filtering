function conv = MyConv(imgd, array)
    img_2=rgb2gray(imgd);
    img=im2double(img_2);
    kernel = rot90(array,2);
          
    [img_h,img_w,p] = size(img);  
    [kernel_h,kernel_w] = size(kernel);

    % Zero Padding
    padx=img_w + (2*floor (kernel_h / 2));
    pady=img_h + (2*floor (kernel_h / 2));
    mod_filter_h = floor (kernel_h / 2);
    mod_filter_w = floor (kernel_w / 2); 
    
    img_out=zeros(pady,padx);
    for j= pady-img_h : pady-mod_filter_h
        for i=padx-img_w : padx-mod_filter_w
            img_out(j,i)=img(j-mod_filter_h, i-mod_filter_w);
        end
    end
 
    %Convolution
    for j=2*mod_filter_h : pady-mod_filter_h
        for i=2*mod_filter_w : padx-mod_filter_w
            pixel_sum = 0;
            for y = 1:kernel_h
                for x = 1: kernel_w
                    pixel_sum = pixel_sum + kernel(y,x) * img_out(j - mod_filter_h + y-1, i - mod_filter_w + x-1);
                end
            end
            conv(j-mod_filter_h,i-mod_filter_w) = pixel_sum;
        end
    end
end