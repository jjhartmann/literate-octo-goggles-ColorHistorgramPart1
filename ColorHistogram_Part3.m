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
x = bx + tx/2;
y = by + ty/2;
cx = x;
cy = y;
tx = tx + 50;
ty = ty + 50;
for frame_index = 1:f
    % Get frame form movie
    frame = video(:,:,:,frame_index);  
    
    % Create colour histogram and backprojection
    I_histo = createcolourhistogram(window, 0, 0);
    R_histo = createratiohistogram(M_histo, I_histo);
    
    % Create window
    window = imcrop(frame, [(x - tx/2) (y - ty/2) tx ty]);
        
    % Back project onto window
    BP_img = createbackprojectionimage(R_histo, window);
    
    % Create circular mask
    mask = createmask('epanech' , radius, 2, 20);

    % Conv image with mask and display
    C_img = conv2(BP_img, mask);
    MAX_val =max(max(C_img));
    C_norm = C_img/MAX_val;

    % Create Threshold
    th = MAX_val - 0;
    
    %% Conduct Mean Shift
    WRK_DONE = false;
    epsilon = 2;
    while (~WRK_DONE)
        [deltax, deltay] = meanshift(BP_img, window, th);
        
        WRK_DONE = ((deltax < epsilon) && (deltaY < epsilon)); 
        x = x + deltax;
        y = y + deltay;
    end
    
    %% Print to figure
    figure(1),imshow(frame),hold on
    plot(x, y, 'x', 'LineWidth', 3)
    plot(pline_x, pline_y, 'LineWidth', 3)
    drawnow;
    hold off

   % input('Hit Enter to continue');

end