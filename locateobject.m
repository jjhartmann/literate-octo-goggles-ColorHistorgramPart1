%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Function: Convolve the image and locate the object
function [x, y, pline_x, pline_y] = locateobject(BP_image, image, radius, max_diff, prev_x, prev_y)
% Create circular mask
mask = createmask('normal' , radius, 2, 20);

% Conv image with mask and display
C_img = conv2(BP_image, mask);
MAX_val =max(max(C_img));
C_norm = C_img/MAX_val;

%% Find location
th = MAX_val - max_diff;
th_index = find(C_img < th);
peaks = C_img;
peaks(th_index) = 0;

% find points
points = bwmorph(peaks, 'shrink', inf);
[m, n] = find(points == 1);

[count_m, nn] = size(m);
[count_n, nn] = size(n);

%% find closest x-y to prev value
found = count_m == 1;
m_final = m(1);
n_final = n(1);
if (count_m > 1 && prev_x > 0)
   delta_x = abs(n(1) - prev_x);
   delta_y = abs(m(1) - prev_y);
   for i = 2:count_m
       if (delta_x > abs(n(i) - prev_x) && delta_y > abs(m(i) - prev_y))
            delta_x = abs(n(i) - prev_x);
            delta_y = abs(m(i) - prev_y);
            m_final = m(i);
            n_final = n(i);
       end
   end
   found = true;
end

%% Return x-y position
m = m_final;
n = n_final;
x = 0;
y = 0;
pline_x = 0;
pline_y = 0;
if (~found)
    disp('Model not in image.')   
else
    % create circle for image
    [h, w, d] = size(image);
    [h1, w1] = size(points);
    delta_h = abs(h1 - h);
    delta_w = abs(w1 - w);
    
    x = (n - delta_w/2);
    y = (m - delta_h/2);
    
    figure(2), hold;
    theta = 0 : (2 * pi /10000) : (2 * pi);
    pline_x = radius * cos(theta) + x;
    pline_y = radius * sin(theta) + y;
end
