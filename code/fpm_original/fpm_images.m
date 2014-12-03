%**************************************************************************
% Fourier Ptychographic Imaging for transparent objects, transmitted light
% Implementation of the original paper
%
% Author: Alankar Kotwal <alankarkotwal13@gmail.com>
%
% Make sure you run this file from the lvp-imaging directory
%**************************************************************************

% Source the config file

config;

%**************************************************************************

% Make sure you're in the lvp-imaging directory

path = pwd;
[~, folder, ~] = fileparts(path);

if(~strcmp('lvp-imaging', folder))
    error('Run this script in the lvp-imaging directory.');
end

%**************************************************************************

% Output stuff

tempImage = double(imread(strcat(imageFolder, '_11.png')));
tempImage = tempImage(:, :, 1);
[yRes, xRes] = size(tempImage);
yOut = scale*yRes;
xOut = scale*xRes;

%**************************************************************************

% Do the actual thing
% Algorithm in Zheng, G et al. 2013, "Wide-Field, High-Resolution Fourier
% Ptychographic Microscopy", Nature Photonics

% Calculate some stuff. All calculations in cm unless specified
wavenum = 2*pi/(lam*10^-7);
filtRad = wavenum*sin(atan(lensRad/foc));   % In k-space
xCen = (nX-1)*xSep/2;                       % Get midpoint
yCen = (nY-1)*ySep/2;                       % of LED array
pixelSize = pixSize/(magnification*scale);  % In object plane, um
pixelWavenumber = 10^-4/pixelSize;          % In object plane, cm^-1

% Initialize the output and generate an upsampled image
imageSize = [yOut xOut];
outputIntensity = imresize(sqrt(tempImage), imageSize);
outputPhase = zeros(yOut, xOut);

count = 0; % Set a convergence criterion as RMSD between this and prev
           % image. For now, number of iterations

while(count<5)
    
    % For each image we have taken
    for i=1:nX
        for j=1:nY
            
            % Read the image
            tempImageRead = imread(strcat(imageFolder, '_', int2str(i), ...
                                          int2str(j), '.png'));
            tempImageRead = tempImageRead(:, :, 1);
            tempImageRead = fliplr(tempImageRead);
            tempImageRead = imresize(tempImageRead, [yOut xOut]);
            tempImageRead = sqrt(double(tempImageRead));
            
            % Get the k parameters for this image
            % Checked if the minus signs are required, possible debug
            xDist = xCen - (i-1)*xSep;
            yDist = yCen - (j-1)*ySep;
            absDist = sqrt(xDist^2 + yDist^2 + h^2);
            kx = wavenum * xDist/absDist;
            ky = wavenum * yDist/absDist;
            
            % Get our mask - Only problematic step left! FiltRad?
            imageMask = circularMask(imageSize, kx, ky, filtRad);
            imshow(imageMask);
            
            % Reconstruct HR image from intensity and phase, find FFT
            outputImage = outputIntensity .* exp(sqrt(-1)*outputPhase);
            outputFFT = fftshift(fft2(outputImage));
            
            % Then filter around the (i,j)th k vector, get IFFT
            tempFFT = outputFFT .* imageMask;
            tempImage = ifft2(ifftshift(tempFFT));
            
            % Replace this magnitude by the measured magnitude
            tempImage = tempImageRead .* exp(sqrt(-1)*angle(tempImage));
            
            % Take the FFT of this creature
            tempFFT = fftshift(fft2(tempImage));
            
            % If mask is 1, replace outputFFT by tempFFT
            outputFFT = tempFFT .* imageMask + outputFFT .*(1-imageMask);
            
        end
    end
    
    count = count+1;
    
end

figure; imshow(outputIntensity);
figure; imshow(outputPhase);