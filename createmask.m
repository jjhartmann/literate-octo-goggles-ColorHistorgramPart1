%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Create mask 
function mask = createmask(type, radius, c, sigma)
mask = [];
% uniform kernel
if strcmp(type, 'uniform')
    ix = sqrt(2 * pi * radius^2);
    cx = ix/2;
    [X, Y] = meshgrid(-(cx-1):(ix-cx), -(cx-1):(ix-cx));
    mask = double((X.^2 + Y.^2) <= radius^2);
    mask_index = find(mask <= 0);
    mask(mask_index) = 0;     
end


% Epanechnikov Kernel
if strcmp(type, 'epanech')
    dimen = radius * 2;
    mask = zeros(dimen, dimen);
    for x = 1:dimen
        for y = 1:dimen
            mask(x, y) = c * max(0, (3*(1 - (((radius - x)/radius)^2 + ((radius - y)/radius)^2)))/4);
        end
    end
end

% Normal Kernel
if strcmp(type, 'normal')
    dimen = radius * 2;
    mask = zeros(dimen, dimen);
    for x = 1:dimen
        for y = 1:dimen
            mask(x, y) = c *  exp((-1/2 * (((radius - x)/sigma)^2 + ((radius - y)/sigma)^2)));
        end
    end
end