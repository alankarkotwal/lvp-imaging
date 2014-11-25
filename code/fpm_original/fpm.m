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
    error('Run the script in the lvp-imaging directory.');
end

%**************************************************************************

% Serial port stuff

if(autodetectSerialPort)
    % Todo: Auto-detection code, write this
else
    ard = arduino(serialPort);
end

%**************************************************************************

% Webcam stuff

vid = videoinput(webcamName, webcamNo, webcamMode);
vid.FramesPerTrigger = imagesPerTrigger;
vid.ReturnedColorspace = 'rgb';

%**************************************************************************

% Output stuff

yOut = scale*yRes;
xOut = scale*xRes;

%**************************************************************************

% Image acquisition stuff. Here I'm assuming a rectangular LED array

images = zeros(yOut, xOut, 3, nX, nY); % Array of nX x nY 3-channel images
kArr = zeros(2, nX, nY);               % Array of nX x nY (kX, kY)

xCen = (nX-1)*xSep/2;                  % Get center coordinates as midpoint
yCen = (nY-1)*ySep/2;                  % of LED array. Change this.

for i=1:nX
    for j=1:nY
        
        % Todo: Light up only the (i, j)th led, using the Arduino
        %ard.digitalWrite(something);
        %ard.digitalWrite(something);
        
        % Get the frame and upsample after storing
        preview(vid);
        start(vid);
        stoppreview(vid);
        tempImage = getdata(vid);
        images(:, :, :, i, j) = imresize(tempImage, [yOut xOut]);
        % Change this for multiple shots per angle. Stacking
        
        % Save images if necessary, as images/i-j.png
        if(saveImages)
            imwrite(tempImage, strcat('images/', int2str(i), '-', ...
                    int2str(j), '.png'));
        end
        
        % Todo: Calculate k and put it in the kArr
        
    end
end

%**************************************************************************

% Do the actual thing

% Initialize the output and generate an upsampled image
imageSize = [yOut xOut];
outputIntensity = images(:, :, :, 1, 1);
outputPhase = zeros(yOut, xOut, 3);

while(1)  % Set a convergence criterion as RMSD between this and prev image
    
    outputImage = outputIntensity .* exp(sqrt(-1)*outputPhase);
    outputFFT = fftshift(fft2(outputImage));
    
    
    
end

outputImage = outputIntensity .* exp(sqrt(-1)*outputPhase);
imwrite(outputImage, 'images/output.png');

imshow(outputImage);