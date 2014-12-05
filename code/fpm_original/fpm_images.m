%**************************************************************************
% Fourier Ptychographic Imaging for transparent objects, transmitted light
% Implementation of the original paper
%
% Author: Alankar Kotwal <alankarkotwal13@gmail.com>
%
% Make sure you run this file from the lvp-imaging directory
%**************************************************************************

% Fancy stuff

clc;
disp('%**************************************************************************');
disp('                              fpm_images 0.1');
disp('%**************************************************************************');

%**************************************************************************

% Source the config file

disp('********************');
disp('Initial configuration');
config;

%**************************************************************************

% Make sure you're in the lvp-imaging directory



path = pwd;
[~, folder, ~] = fileparts(path);

if(~strcmp('lvp-imaging', folder))
    error('Run this script in the lvp-imaging directory.');
end

%**************************************************************************

% Register images

if(strcmp(regImages, 'yes'))
    
    mkdir(tempImageDir);

    disp('********************');
    disp('Registering images');

    [optimizer, metric] = imregconfig(regType);

    fixedImage = imread(fixedImageName);
    fixedImage = fixedImage(:, :, 1);
    
    fixedImageSize = size(fixedImage);

    for i=1:nX
        for j=1:nY

            disp('--');
            disp('Processing image ');
            disp([i j]);

            movingImage = imread(strcat(imageFolder, '_', int2str(i),  ...
                                        int2str(j), '.png'));
            movingImage = movingImage(:, :, 1);

            regImage = imregister(movingImage, fixedImage, metricType, ...
                                  optimizer, metric);
            
            if(strcmp(cropImages, 'yes'))
                regImage = regImage(yMargin:fixedImageSize(1)-yMargin, ...
                                    xMargin:fixedImageSize(2)-xMargin);
            end

            imwrite(regImage, strcat(tempImageDir, imageFolder, '_', ...
                                     int2str(i), int2str(j), '.png'));

        end
    end
    
end
%**************************************************************************

% Output stuff

disp('********************');
disp('Get image size paramters');
tempImage = double(imread(strcat(tempImageDir, imageFolder, '_11.png')));
[yRes, xRes] = size(tempImage);
yOut = scale*yRes;
xOut = scale*xRes;

%**************************************************************************

% Do the actual thing
% Algorithm in Zheng, G et al. 2013, "Wide-Field, High-Resolution Fourier
% Ptychographic Microscopy", Nature Photonics

% Calculate some stuff. All calculations in cm unless specified

disp('********************');
disp('Calculate some global constants');
wavenum = 2*pi/(lam*10^-7);
filtRad = wavenum*sin(atan(lensRad/foc));           % In k-space
xCen = (nX-1)*xSep/2;                               % Get midpoint
yCen = (nY-1)*ySep/2;                               % of LED array
pixelSize = 10^-4 * pixSize/(magnification*scale);  % In object plane

% Initialize the output and generate an upsampled image

disp('********************');
disp('Initialize output');
imageSize = [yOut xOut];
outputIntensity = imresize(sqrt(tempImage), imageSize);
outputPhase = zeros(yOut, xOut);
outputImage = outputIntensity .* exp(sqrt(-1)*outputPhase);
outputFFT = fftshift(fft2(outputImage));

count = 0; % Set a convergence criterion as RMSD between this and prev
           % image. For now, number of iterations

while(count<maxIter)
    
    disp('********************');
    disp('Processing iteration ');
    disp(count);
    
    % For each image we have taken
    for i=1:nX
        for j=1:nY
            
            disp('--');
            disp('Processing image ');
            disp([i j]);
            
            % Read the image
            disp('Reading image');
            tempImageRead = imread(strcat(tempImageDir, imageFolder,  ...
                                          '_', int2str(i),int2str(j), ...
                                          '.png'));
            tempImageRead = fliplr(tempImageRead);
            tempImageRead = imresize(tempImageRead, [yOut xOut]);
            tempImageRead = sqrt(double(tempImageRead));
            
            % Get the k parameters for this image
            % Checked if the minus signs are required, possible debug
            disp('Calculating parameters');
            xDist = xCen - (i-1)*xSep;
            yDist = yCen - (j-1)*ySep;
            absDist = sqrt(xDist^2 + yDist^2 + h^2);
            kx = wavenum * xDist/absDist;
            ky = wavenum * yDist/absDist;
            
            % Get our mask - Only problematic step left! FiltRad?
            disp('Generating mask image');
            imageMask = circularMask(imageSize, kx, ky, filtRad, pixelSize);
            %imshow(imageMask);
            
            % Then filter around the (i,j)th k vector, get IFFT
            disp('Filtering estimate and getting IFFT');
            tempFFT = outputFFT .* imageMask;
            tempImage = ifft2(ifftshift(tempFFT));
            
            % Replace this magnitude by the measured magnitude
            disp('Replacing magnitude');
            tempImage = tempImageRead .* exp(sqrt(-1)*angle(tempImage));
            
            % Take the FFT of this creature
            disp('Getting FFT of replaced estimate');
            tempFFT = fftshift(fft2(tempImage));
            
            % If mask is 1, replace outputFFT by tempFFT
            disp('Replacing in Fourier domain');
            outputFFT = tempFFT .* imageMask + outputFFT .* (1-imageMask);
            
        end
    end
    
    count = count+1;
    
end

outputImage = ifft2(ifftshift(outputFFT));
outputIntensity = abs(outputImage);
outputPhase = angle(outputImage);

imwrite(histeq(mat2gray(outputIntensity)), 'results\20140412_Intensity_Output_03.png');
imwrite(histeq(mat2gray(outputIntensity)), 'results\20140412_Phase_Output_03.png');