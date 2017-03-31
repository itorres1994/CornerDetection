% Ian Torres
% 27621588
% CSCI 370: Corner Detection (Homework 3)
% Prof. Subhransu Maji
function [cx, cy, cs] = detectCorners(I, isSimple, w, th)
% This code is part of:
%
%   CMPSCI 370: Computer Vision, Spring 2016
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 3

% Convert to double format
I = im2double(I); 

% Convert color to grayscale
if size(I, 3) > 1 
    I = rgb2gray(I);
end

% Step 1: Compute corner score
if isSimple
    cornerScore = simpleScore(I, w);
else
    cornerScore = harrisScore(I, w);
end

% Step 2: Threshold corner score abd find peaks
cornerScore (cornerScore < th) = 0;
[cx, cy, cs] = nms(cornerScore);
end

function [cx, cy, cs] = detectCornersIan(I, w, th)

% Convert to double format
I = im2double(I); 

% Convert color to grayscale
if size(I, 3) > 1 
    I = rgb2gray(I);
end

% Step 1: Compute corner score

cornerScore = simpleScoreIan(I, w);

% Step 2: Threshold corner score abd find peaks
cornerScore (cornerScore < th) = 0;
[cx, cy, cs] = nms(cornerScore);
end


%--------------------------------------------------------------------------
%                                    Simple score function (Implement this)
%--------------------------------------------------------------------------
function cornerScore = simpleScore(I, w)
    gf = fspecial('Gaussian', 6*w+1, w);

    f{1} = [1 0 0; 0 -1 0; 0 0 0];
    f{2} = [0 1 0; 0 -1 0; 0 0 0];
    f{3} = [0 0 1; 0 -1 0; 0 0 0];
    f{4} = [0 0 0; 1 -1 0; 0 0 0];
    f{5} = [0 0 0; 0 -1 1; 0 0 0];
    f{6} = [0 0 0; 0 -1 0; 1 0 0];
    f{7} = [0 0 0; 0 -1 0; 0 1 0];
    f{8} = [0 0 0; 0 -1 0; 0 0 1];

    cornerScore = zeros(size(I));
    for i = 1:8, 
        diff = imfilter(I, f{i}, 'replicate', 'same');
        diffSum = imfilter(diff.^2, gf, 'replicate', 'same');
        cornerScore = cornerScore + diffSum;
    end
end

%--------------------------------------------------------------------------
%                                    Simple score function: My Method
%--------------------------------------------------------------------------
function cornerScore = simpleScoreIan(I, w)
    % This algorithm was implemented in the same manner as the lecture
    % slides: Corner Dectection (II)
    score = zeros(size(I)); % Make a score matrix the size of the image
    
    M = [-1 0 1; 0 0 0; 1 0 -1]; %original matrix
    B = [1 0 -1; 0 0 0; -1 0 1];
    D = [0 -1 0; -1 0 1; 0 1 0];
    E = [0 1 0; 1 0 -1; 0 -1 0];
    F = [0 -1 0; 1 0 -1; 0 1 0];
    G = [0 1 0; -1 0 1; 0 -1 0];
    C = cat(3,M,B,D,E,F,G);
    
    % Edit of original algorithm with more matrices
    for j = 1:9
        for i = 1:6
           tempMat = C(:,:,i);
           imdiff = imfilter(I,tempMat,'replicate');
           score = score + imgaussfilt(imdiff.^2, w);
        end
    end
    
    cornerScore = score; % Replace this with your implementation
end


%--------------------------------------------------------------------------
%                                    Harris score function (Implement this)
%--------------------------------------------------------------------------
function cornerScore = harrisScore(I, w)
    [Gx, Gy] = imgradientxy(I);  % Takes image gradient using Sobel Matrix
    
    Ixx = imgaussfilt(Gx.^2, w); % Filter the square of the x-gradient
                                 % with a Gaussian filter of sigma (w)
                                 
    Iyy = imgaussfilt(Gy.^2, w); % Filter the square of the y-gradient with
                                 % a Gaussian filter of sigma (w)
                                 
    Ixy = imgaussfilt(Gx.*Gy, w);% Filter the xy-gradient with
                                 % a Gaussian filter of sigma (w)
    
    R = (Ixx.*Iyy - Ixy.^2) - 0.04*(Ixx + Iyy).^2;% R = (ad-bc) - k*(a+b)^2
                                                  % k: 0.04
                                                  % a: Ixx, d: Iyy, 
                                                  % b: Iyx, c: Ixy, b=c
    %printf('Done!');
    cornerScore = R; % Replace this with your implementation
end
