%**************************************************************************
% Fourier Ptychographic Imaging for transparent objects, transmitted light
% Function: Circular mask for the Fourier Transform
% Expects: Mask size, circle center coordinates, circle radius
% Returns: Mask where values in circle are 1, outside are zero
%
% Author: Alankar Kotwal <alankarkotwal13@gmail.com>
%**************************************************************************

function outputImage = circularMask(size, kxC, kyC, rad, pixelSize)

outputImage = zeros(size);

% Get object size in image
imageSizeX = size(2) * pixelSize;
imageSizeY = size(1) * pixelSize;

% If distance to center < radius, then pixel = 1
for i=1:size(1)
    for j=1:size(2)
        
        if(((2*pi*(j-size(2)/2))/imageSizeX - kxC)^2 + ((2*pi*(size(1)/2 - i))/imageSizeY - kyC)^2 < rad^2) % Distance condition
            outputImage(i, j) = 1;
        end
        
    end
end