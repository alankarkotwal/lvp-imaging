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

% Image acquisition stuff. Here I'm assuming a rectangular LED array

images = zeros(yRes, xRes, 3, nX, nY); % Array of nX x nY 3-channel images
kArr = zeros(2, nX, nY);               % Array of nX x nY (kX, kY)

xCen = (nX-1)*xSep/2;                  % Get center coordinates as midpoint
yCen = (nY-1)*ySep/2;                  % of 

for i=1:nX
    for j=1:nY
        
        % Todo: Light up only the (i, j)th led, using the Arduino
        %ard.digitalWrite(something);
        %ard.digitalWrite(something);
        
        % Get the frame
        preview(vid);
        start(vid);
        stoppreview(vid);
        images(:, :, :, i, j) = getdata(vid); % Change this for multiple
                                              % shots per angle. Stacking
        
        % Todo: Calculate k and put it in the kArr
        
    end
end

%**************************************************************************

% Do the actual thing

% Initialize the output and generate an upsampled image
output = zeros(yOut, xOut, 3);
output(:, :, :) = imresize(images(:, :, :, 1, 1), [yOut xOut]);
