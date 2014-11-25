%**************************************************************************
% Fourier Ptychographic Imaging for transparent objects, transmitted light
% Function: Circular mask for the Fourier Transform
% Expects: Mask size, circle center coordinates, circle radius
% Returns: Mask where values in circle are 1, outside are zero
%
% Author: Alankar Kotwal <alankarkotwal13@gmail.com>
%**************************************************************************

function outputImage = circularMask(size, xC, yC, rad)

outputImage = zeros(size);

for i=1:size(1)
    for j=1:size(2)
        
        if((xC-i)^2 + (yC - j)^2 < rad^2) % Distance condition
            outputImage(i, j) = 1;
        end
        
    end
end