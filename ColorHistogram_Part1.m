%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Swains et al. Color Histogram Part 1

model_img = imread('SwainDatabase\swain_database\chickensoupnoodles.sqr.128.bmp');
imshow(model_img)

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
imshow(image_img)

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




