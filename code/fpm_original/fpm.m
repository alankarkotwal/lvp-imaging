%**************************************************************************
% Fourier Ptychographic Imaging for transparent objects, transmitted light
% Implementation of the original paper
%
% Author: Alankar Kotwal <alankarkotwal13@gmail.com>
%
% Make sure you run this file from the lvp-imaging directory
%**************************************************************************

% Config

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
    % Auto-detection code
    ard = arduino(serialPort);      % for now, change this for auto-detect
else
    ard = arduino(serialPort);
end

%**************************************************************************

% Webcam stuff

vid = videoinput(webcamName, webcamNo, webcamMode);

%**************************************************************************

% Image acquisition stuff

% Do something here

%**************************************************************************

% Do the actual thing

% Do something here
