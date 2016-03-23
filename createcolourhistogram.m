%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function to create a color histogram
function histo = createcolourhistogram(image, th) 
model = double(image);
histo = zeros(8, 8, 8);

%% Build the histogram for model
[h, w, d] = size(model);
for i = 1:h
   for j = 1:w
       red = model(i, j, 1) + 1;
       grn = model(i, j, 2) + 1;
       blu = model(i, j, 3) + 1;
       
       IL = red + grn + blu;
       
       if (IL > th && IL < ((3 * 256)-th))
           index1 = ceil(red/32);
           index2 = ceil(grn/32);
           index3 = ceil(blu/32);
%             index1 = ceil((abs(red - grn)+1)/16);
%             index2 = ceil((abs((2*blu) - red - grn)+1)/32);
%             index3 = ceil((abs(red + grn + blu)+1)/48);
            
           val = histo(index1, index2, index3);
           histo(index1, index2, index3) = val + 1;
       end
   end
end
