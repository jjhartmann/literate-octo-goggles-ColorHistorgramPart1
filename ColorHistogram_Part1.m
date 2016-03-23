%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Swains et al. Color Histogram Part 1

model = imread('SwainDatabase\swain_database\chickensoupnoodles.sqr.128.bmp');
imshow(model)

model = double(model);
M_histo = zeros(16, 16, 16);

%% Build the histogram for model
[w, h, d] = size(model);
th = 20;
for i = 1:w
   for j = 1:h
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
