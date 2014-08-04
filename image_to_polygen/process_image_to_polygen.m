function process_image_to_polygen(img_name, is_satellite)
    img = imread(img_name);
    img = im2double(img);
    img_bw = sum(img, 3) / 3;

    polygen_r = process_single_layer(img(:,:,1), is_satellite);
    polygen_g = process_single_layer(img(:,:,2), is_satellite);
    polygen_b = process_single_layer(img(:,:,3), is_satellite);
    polygen_bw = process_single_layer(img_bw, is_satellite);
    polygen = polygen_r & polygen_g & polygen_b & polygen_bw;
    
    %figure(1);
    %subplot(2,2,1);imshow(polygen_r);
    %subplot(2,2,2);imshow(polygen_g);
    %subplot(2,2,3);imshow(polygen_b);
    %subplot(2,2,4);imshow(polygen_bw);
    %imshow(polygen);
    se = strel('diamond', 10);
    polygen = imclose(polygen, se);
    polygen = imopen(polygen, se);
    polygen = imdilate(polygen, se);
    polygen = im2uint8(polygen);
    
    [size_x,size_y] = size(img_bw);
    filter = ones(3,3) / 9;
    convolution = imfilter(polygen, filter, 'replicate');
    border = zeros(size_x, size_y);
    border(find(convolution>0 & convolution<255)) = 1;
    %imshow(border);
    
    %polygen = edge(polygen, 'canny');
    %polygen = corner(polygen);
    
    
    [x,y] = find(border == 1);
    %fid = fopen('points', 'w');
    fprintf(1, '%d %d\n', [y,x]');
    %fclose(fid);
    
    %subplot(1,3,1);
    %figure(2);
    %imshow(img);
    %hold on;plot(y,x,'r.');
    %subplot(1,3,2);
    %imshow(polygen);
    
    %img_with_polygen = img;
    %img_with_polygen(:,:,1) = min(1,img_with_polygen(:,:,1) + polygen);
    %subplot(1,3,3);imshow(img_with_polygen);