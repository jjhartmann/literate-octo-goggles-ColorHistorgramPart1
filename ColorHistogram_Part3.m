%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Color histogram - With Mean Shift

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

%% Get Model Histogram
M_histo = createcolourhistogram(model_img, 0, 0);

%% Iterate through video and track object
[h, w, d, f] = size(video);
radius = max(ty, tx)/2 + 20;
x = bx;
y = by;
for frame_index = 1:f

    frame = video(:,:,:,frame_index);

    I_histo = createcolourhistogram(frame, 0, 0);
    R_histo = createratiohistogram(M_histo, I_histo);
    BP_img = createbackprojectionimage(R_histo, frame);
    [x, y, pline_x, pline_y] = locateobject(BP_img, frame, radius, 0, -1, -1);

    figure(1),imshow(frame),hold on
    plot(x, y, 'x', 'LineWidth', 3)
    plot(pline_x, pline_y, 'LineWidth', 3)
    drawnow;
    hold off

   % input('Hit Enter to continue');

end