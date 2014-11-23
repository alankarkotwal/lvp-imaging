%*****************************************************************************
% Fourier Ptychographic Imaging
% Implementation of the original paper
%
% Author: Alankar Kotwal <alankarkotwal13@gmail.com>
%
% Make sure you run this file from the lvp-imaging directory
%*****************************************************************************

% Config

config;

%*****************************************************************************

% Make sure you're in the lvp-imaging directory

path = pwd;
[~, folder, ~] = fileparts(path);

if(~strcmp('lvp-imaging', folder))
    error('Run the script in the lvp-imaging directory.');
end

%*****************************************************************************

% Serial port stuff

if(autodetectSerialPort)
    % Auto-detection code
else
    % 
end

%*****************************************************************************

% Webcam port stuff

vid = videoinput('linuxvideo', 1, 'YUYV_1280x720');

%*****************************************************************************

% Do the actual thing

