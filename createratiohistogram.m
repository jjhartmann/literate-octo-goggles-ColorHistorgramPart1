%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Function to create a ratio histogram. 
function R_histo = createratiohistogram(M_histo, I_histo)
R_histo = double(zeros(8, 8, 8));

% Iterate over I_histo and M_histo and get the ratio min(M/I, 1);
for i = 1:8
    for j = 1:8
        for k = 1:8
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