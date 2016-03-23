%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Function: Convolve the image and locate the object
function [x, y, pline_x, pline_y] = locateobject(BP_image, radius)
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

%% Find location
th = MAX_val - 50;
th_index = find(C_img < th);
peaks = C_img;
peaks(th_index) = 0;

% find points
points = bwmorph(peaks, 'shrink', inf);
[m, n] = find(points == 1);

[count_m, nn] = size(m);
[count_n, nn] = size(n);
x = 0;
y = 0;
pline_x = 0;
pline_y = 0;
if ( count_m > 1 || count_n > 1)
    disp('Model not in image.')   
else
    x = (n - delta_w/2);
    y = (m - delta_h/2);

    % create circle for image
    [h, w, d] = size(image_img);
    [h1, w1] = size(points);
    delta_h = abs(h1 - h);
    delta_w = abs(w1 - w);
    figure(2), hold;
    theta = 0 : (2 * pi /10000) : (2 * pi);
    pline_x = radius * cos(theta) + x;
    pline_y = radius * sin(theta) + y;
end
