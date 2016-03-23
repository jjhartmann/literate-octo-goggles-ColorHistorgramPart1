%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Colour Histogram Part 2 - Object tracking. 


load('CMPT412_blackcup.mat');
load('CMPT412_bluecup.mat');

% TODO: choose what video
video = blackcup;

% Get box input 
frame1 = video(:,:,:,1);
figure(1),imshow(frame1)
[bx, by] = ginput(1);
[tx, ty] = ginput(1);

% Crop image
ty = abs(by - ty);
tx = abs(bx - tx);
model_img = imcrop(frame1, [bx by tx ty]);
figure(2),imshow(model_img)

