%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function: Perform packprojection on image with R_Histo
function BP_image = createbackprojectionimage(R_histo, image)
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