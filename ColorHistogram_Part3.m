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
radius =  30;
x = bx + tx/2;
y = by + ty/2;
tx = tx + 50;
ty = ty + 50;
for frame_index = 1:f
    % Get frame form movie
    frame = video(:,:,:,frame_index);  
    
    % Create colour histogram and backprojection
    I_histo = createcolourhistogram(window, 0, 0);
    R_histo = createratiohistogram(M_histo, I_histo);
    
    % Create window
    bx = (x - tx/2);
    by = (y - ty/2);
    window = imcrop(frame, [bx by tx ty]);
    
    % Back project onto window
    BP_img = createbackprojectionimage(R_histo, window);
    
    % Create circular mask
    mask = createmask('epanech' , radius, 1, 20);

    % Conv image with mask and display
    C_img = conv2(BP_img, mask);
    MAX_val =max(max(C_img));
    C_norm = C_img/MAX_val;
    [h, w] = size(C_img);
    [h1, w1, d] = size(window);
    C_crop = imcrop(C_img, [(w - w1)/2, (h - h1)/2, w1, h1]); 
    % Create Threshold
    th = MAX_val - 0;
    
    
    %% Conduct Mean Shift
    WRK_DONE = false;
    epsilon = 1;
    while (~WRK_DONE)
        % Call mean shift function: pass in Backprojected window and
        % normalized x and y positions
        [deltax, deltay] = meanshift(C_crop, ceil(x - bx), ceil(y - by));
        
        WRK_DONE = ((deltax < epsilon) && (deltay < epsilon)); 
        x = x + deltax;
        y = y - deltay;
    end
    
    %% Print to figure
    theta = 0 : (2 * pi /10000) : (2 * pi);
    pline_x = radius * cos(theta) + x;
    pline_y = radius * sin(theta) + y;
    
    figure(1),imshow(frame),hold on
    plot(x, y, 'x', 'LineWidth', 3)
    plot(pline_x, pline_y, 'LineWidth', 3)
    drawnow;
    hold off

   % input('Hit Enter to continue');

end