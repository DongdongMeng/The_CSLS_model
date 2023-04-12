clc;clear all;close all;
%========================================================
% Context-sensitive Level Sets for Green Algae Detection
% _______________________________________________________

% I:input image
% nrow: the number of image rows
% ncol: the number of image columns
% Iteration_number: iteration number
%
% F_rho: constant function
% G_rho: gaussian kernel function
%
% N: the number of disjoint regions in the whole image
% k: empirical scaling parameter
%
% D_alpha: deformation of neighborhood characterization term
% D_beta: deformation of edge preservation term
% sigma: intensity deviation of neighborhood characterization term
%
% m0: constant for initializing level set function
% initialLSF: initialization of the level set function
% phi: level set function
% 
% timestep_T: time step of level set iteration
% epsilon: constant value
% timestep_t: time step of regularization
% 
% Img: output image
%
%Author. Meng Dongdong
%     Department of Physics
%     Ocean University of China,College of Information S&E
%     Qingdao.China
%Version:1.0 Data: May 2.2019
%========================================================
addpath('.\image');
%--------Input green algae image----------------
im = imread('GF-4_NDVI\NDVI_4_tif.tif');
I_ori = mat2gray(im);
I_chu = I_ori.*255;
I = double(I_chu(:,:,1));
[nrow,ncol] = size(I);

set(0,'defaultfigurecolor','w');
figure;imagesc(I, [0, 255]);title('Green algae image');
colormap(gray);hold on; axis off;axis equal;
pause(0.1);

%---The initialization of context-sensitive level sets---
Iteration_number = 300;

c = 11
F_rho = ones(c);                                     % Eq.(7)
gamma = 10;
G_rho=fspecial('gaussian',round(2*gamma)*2+1,gamma); % Eq.(10)

N = 2;                                               
k = 2;                 %value belongs to  [0,2]                                        
%-------------Initialization---------------------------------
D_alpha(1:nrow,1:ncol) = 1;
D_beta(1:nrow,1:ncol) = 1;
for i = 1:N
    sigma(1:nrow,1:ncol,i) = i;
end

m0 = 0.001;
initialLSF = ones(size(I(:,:,1))).*m0;               % Eq.(15)
 initialLSF(300:600,300:600) = -m0;
phi = initialLSF;
%--------------------------------------------
timestep_T = 0.1;                                    %value belongs to  [0,1]                                      
epsilon = 1;                                           
timestep_t = 0.1;                                    %value belongs to  [0,1]                                  

hold on;
[c,h] = contour(phi,[0 0],'r');
title('Initialization of the level set function');
pause(0.1);

%--------Iterations of the level set function----------------
for i = 1:Iteration_number
    [phi,D_alpha,D_beta,sigma]  = CSLS(phi,epsilon,I,F_rho,G_rho,D_alpha,D_beta,sigma,timestep_T,k);
    phi = phi + timestep_t*4*del2(phi); %regularization  Eq.(25)
    if mod(i,20)==0
        pause(0.001);
        imagesc(I,[0 255]);colormap(gray);axis off; axis equal;
        hold on;
        contour(phi,[0 0],'r');
        iterNum=['Iterations of the level set function:',num2str(i), ' iterations'];
        title(iterNum);
        hold off;
    end
end
pause(0.1);
%--------Output green algae result----------------
imwrite(phi,'GF-4_Result\NDVI_4.tif');
Img=mat2gray(phi);
imagesc(Img,[0 255]);colormap(gray);title('Green algae detection result');axis off; axis equal;


