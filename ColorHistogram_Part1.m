%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Swains et al. Color Histogram Part 1

model_img = imread('SwainDatabase\swain_database\garan.sqr.128.bmp');
figure(1), imshow(model_img)

model = double(model_img);
M_histo = zeros(16, 16, 16);

%% Build the histogram for model
[h, w, d] = size(model);
th = 5;
for i = 1:h
   for j = 1:w
       red = model(i, j, 1) + 1;
       grn = model(i, j, 2) + 1;
       blu = model(i, j, 3) + 1;
       
       
       if ( red > th || grn > th || blu > th)
           index1 = ceil(red/16);
           index2 = ceil(grn/16);
           index3 = ceil(blu/16);

           val = M_histo(index1, index2, index3);
           M_histo(index1, index2, index3) = val + 1;
       end
   end
end

%% Build Histogram for Image
I_histo = zeros(16, 16, 16);
image_img = imread('SwainDatabase\SwainCollageForBackprojectionTesting.bmp');
figure(2), imshow(image_img)

image = double(image);
[h, w, d] = size(image);
th = 5;
for i = 1:h
   for j = 1:w
       red = image(i, j, 1) + 1;
       grn = image(i, j, 2) + 1;
       blu = image(i, j, 3) + 1;
       
       
       if ( red > th || grn > th || blu > th)
           index1 = ceil(red/16);
           index2 = ceil(grn/16);
           index3 = ceil(blu/16);

           val = I_histo(index1, index2, index3);
           I_histo(index1, index2, index3) = val + 1;
       end
   end
end



%% Build Ratio histogram R
R_histo = double(zeros(16, 16, 16));

% Iterate over I_histo and M_histo and get the ratio min(M/I, 1);
for i = 1:16
    for j = 1:16
        for k = 1:16
            M_val = M_histo(i, j, k);
            I_val = I_histo(i, j, k);
            
            % check for inf or nan
            if (M_val == 0 || I_val == 0)
                if (M_val == 0)
                    M_val = 0;
                    I_val = 1;
                else
                    M_val = 1;
                    I_val = 1;
                end
            end
            
            R_histo(i, j, k) = min(double(M_val)/double(I_val), 1.0);
        end
    end
end


%% Use the each pixel in the image-to-search as an index into the R_histo
% replace pixel with ratio
[h, w, d] = size(image);
BP_image = double(zeros(h, w));

for i = 1:h
    for j = 1:w
       red = image(i, j, 1) + 1;
       grn = image(i, j, 2) + 1;
       blu = image(i, j, 3) + 1;
       
       index1 = ceil(red/16);
       index2 = ceil(grn/16);
       index3 = ceil(blu/16);
       
       R_val = R_histo(index1, index2, index3);
       BP_image(i, j) = R_val;
    end
end

%% Build mask
figure(2), imshow(image_img)
[cx, cy] = ginput(1);
[px, py] = ginput(1);

% Find the radius of circle
radius = floor(sqrt((cx - px)^2 + (cy - py)^2))/2;

% Create circular mask
ix = sqrt(2 * pi * radius^2);
cx = ix/2;
[X, Y] = meshgrid(-(cx-1):(ix-cx), -(cx-1):(ix-cx));
mask = double((X.^2 + Y.^2) <= radius^2);
mask_index = find(mask <= 0);
mask(mask_index) = 0;

% Conv image with mask and display
C_img = conv2(BP_image, mask);
MAX_val =max(max(C_img));
C_norm = C_img/MAX_val;
figure(3),imshow(C_norm)
figure(4),mesh(C_img)

%% Find location
th = MAX_val - 50;
th_index = find(C_img < th);
peaks = C_img;
peaks(th_index) = 0;
figure(5), imshow(peaks)

% find points
points = bwmorph(peaks, 'shrink', inf);
[m, n] = find(points == 1);

[count_m, nn] = size(m);
[count_n, nn] = size(n);
if ( count_m > 1 || count_n > 1)
    disp('Model not in image.')
else
    disp('Location of object is:')
    disp([num2str(m), ' ', num2str(n)])

    % draw circule on image
    [h, w, d] = size(image_img);
    [h1, w1] = size(points);
    delta_h = abs(h1 - h);
    delta_w = abs(w1 - w);
    figure(2), hold;
    theta = 0 : (2 * pi /10000) : (2 * pi);
    pline_x = radius * cos(theta) + (n - delta_w/2);
    pline_y = radius * sin(theta) + (m - delta_h/2);
    hold on; 
    plot(n - delta_w/2, m - delta_h/2, 'x', 'LineWidth', 3)
    plot(pline_x, pline_y, 'LineWidth', 3)
    hold off;
end





