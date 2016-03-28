%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the mean shift on the window
function [deltax, deltay] = meanshift(C_img, x, y, h)

% Mean shift with gaussian kernel
 [m, n] = size(C_img);
sigma = 8;
val = C_img(y, x);
%% x
deltax = 0;
top = 0;
btm = 0;
for i = 1:n
   xi = C_img(y, i);
   gauss = xi * min(1, max(0, h - abs(x - i)));%max(0, 3*(1 - ((x - i)/h)^2));%exp(((i - x)^2)/(-2*sigma^2));
   top = (i * gauss) + top;
   btm = gauss + btm;
end
mean = (top/btm) - x;
if (mean <= 0)
    deltax = ceil(mean)
else
    deltax = floor(mean)
end



%% y
deltay = 0;
top = 0;
btm = 0;
for i = 1:m
   yi = C_img(i, x);
   gauss = yi * min(1, max(0, h - abs(y - i)));%max(0, 3*(1 - ((y - i)/h)^2));%exp(((i - y)^2)/(-2*sigma^2));
   top = (i * gauss) + top;
   btm = gauss + btm;
end
mean = (top/btm) - y;
if (mean <= 0)
    deltay = ceil(mean);
else
    deltay = floor(mean)
end

