% This code is part of:
%
%   CMPSCI 370: Computer Vision, Spring 2016
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 3

% Entry code for corner detector

% Create a checkerboard of size 20 pixels
%I = checkerboard(20);
I = imread('polymer-science-umass.jpg');
%I = imread('6-26-2015_DOPC_SC_400_RPM_2.4_Vpp_10_Hz_RT.tif',1);
%I = imread('electroformation-sample_DOPC-2.png');
%I = imread('capitol-building.jpg');
%I = imread('transparent_particle.tif');
%size(J)

% Simple corners
[cx, cy, cs] = detectCorners(I, true, 1.5, 0.05);
figure;
subplot(1,2,1);
imshow(I); axis image off; hold on;
plot(cx, cy, 'r.');
title('Simple corners');
% Simple corners2
[cx, cy, cs] = detectCornersIan(I, 1.5, 0.05);
figure;
subplot(1,2,2);
imshow(I); axis image off; hold on;
plot(cx, cy, 'b.');
title('Simple corners 2');
% Harris corners
[cx, cy, cs] = detectCorners(I, false,1.5, 0.0001);
subplot(1,2,3);
imshow(I); axis image off; hold on;
plot(cx, cy, 'g.');
title('Harris corners');
