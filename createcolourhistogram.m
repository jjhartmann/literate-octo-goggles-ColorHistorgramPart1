%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function to create a color histogram
function histo = createcolourhistogram(image) 
model = double(image);
histo = zeros(16, 16, 16);

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

           val = histo(index1, index2, index3);
           histo(index1, index2, index3) = val + 1;
       end
   end
end
