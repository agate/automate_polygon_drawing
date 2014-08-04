function polygen = process_single_layer(img_layer, is_satellite)
    [size_x,size_y] = size(img_layer);
    
    filter = fspecial('gaussian', [30,30], 1);
    img_layer = imfilter(img_layer, filter, 'replicate');
    
    se = strel('diamond', 30);
    img_layer = imclose(img_layer, se);
    
    %figure(3);imshow(img_layer);pause;
    if is_satellite
        threshold = 0.10;
        se = strel('diamond', 5);
    else
        threshold = 0.01;
        se = strel('diamond', 3);
    end
    
    hist_val = imhist(img_layer(size_x/2-5:size_x/2+5,size_y/2-5:size_y/2+5));
    central_val = find(hist_val == max(max(hist_val))) / 255;
    % central_val = mean(mean(img_layer(size_x/2-5:size_x/2+5,size_y/2-5:size_y/2+5)));
    img_layer(find(img_layer < central_val-threshold)) = 0;
    img_layer(find(img_layer > central_val+threshold)) = 0;
    img_layer(find(img_layer > 0)) = 1;
    
    polygen = zeros(size_x,size_y);
    polygen(size_x/2,size_y/2) = 1;
    for i = 1:50
        polygen = imdilate(polygen, se) & img_layer;
    end
