function process_image_to_polygen(img_name)
    img = imread(img_name);
    img = im2double(img);
    img_bw = sum(img, 3) / 3;
    
    se = strel('diamond', 30);
    img_bw = imclose(img_bw, se);
    
    central_val = img_bw(400,400);
    img_bw(find(img_bw < central_val*9/10)) = 0;
    img_bw(find(img_bw > central_val*11/10)) = 0;
    img_bw(find(img_bw > 0)) = 1;
    
    se = strel('diamond', 10);
    polygen = zeros(800,800);
    pre_polygen = polygen;
    polygen(400,400) = 1;
    for i = 1:50
        polygen = imdilate(polygen, se) & img_bw;
    end
    
    polygen = imopen(polygen, se);
    se = strel('diamond', 5);
    polygen = imdilate(polygen, se);
    polygen = edge(polygen, 'canny');
    %polygen = corner(polygen);
    
    subplot(1,3,1);imshow(img);
    %hold on;plot(polygen(:,1),polygen(:,2),'r.');
    
    %fid = fopen('points', 'w');
    %fprintf(fid, '%d %d\n', polygen);
    %fclose(fid);
    
    subplot(1,3,2);imshow(polygen);
    
    img_with_polygen = img;
    img_with_polygen(:,:,1) = min(1,img_with_polygen(:,:,1) + polygen);
    subplot(1,3,3);imshow(img_with_polygen);