function [phi,D_alpha,D_beta,sigma] = CSLS(phi,epsilon,I,F_rho,G_rho,D_alpha,D_beta,sigma,timestep_T,k)
%========================================================
% Iterations of the level set function
% _______________________________________________________
% Input parameter
% phi: level set function
% epsilon: constant value
% I:input image
% F_rho: constant function
% G_rho: gaussian kernel function
% D_alpha: deformation of neighborhood characterization term
% D_beta: deformation of edge preservation term
% sigma: intensity deviation of neighborhood characterization term
% timestep_T: time step of level set iteration
% k: empirical scaling parameter
%
% M: two-dimension membership function
% C_alpha: clean image of neighborhood characterization term
% C_beta: clean image of edge preservation term 
%
%Author. Meng Dongdong
%     Department of Physics
%     Ocean University of China,College of Information S&E
%     Qingdao.China
%Version:1.0 Data: May 2.2019
%========================================================
M = update_M(phi,epsilon);

C_alpha = update_C(I,F_rho,M,D_alpha);
C_beta  = update_C(I,G_rho,M,D_beta);

D_alpha = update_Dalpha(I,F_rho,M,C_alpha,sigma);
D_beta  = update_Dbeta(I,G_rho,M,C_beta);

sigma = update_sigma(I,D_alpha,F_rho,C_alpha,M);
 
e = update_e(I,F_rho,G_rho,sigma,D_alpha,D_beta,C_alpha,C_beta,k);
phi = update_phi(phi,e,timestep_T,epsilon);

%--------Update the clean image J----------------
function C = update_C(I,K,M,D)
[row,col,dim] = size(M);
for i = 1:dim
    Top = conv2(D,K,'same').*I.*M(:,:,i);
    Bottom = conv2(D.^2,K,'same').*M(:,:,i);
    de = sum(sum(Bottom));
    de = de+(de==0)*eps;
    C(1:row,1:col,i) = sum(sum(Top))/de;         % Eq.(17)
end

%--------Update the deformation D_alpha----------------
function Dalpha = update_Dalpha(I,K,M,C,sigma)
[row,col,dim] = size(M);
J1 = zeros(row,col);
J2 = J1;
for i = 1:dim
    csi  = C(:,:,i)./sigma(:,:,i);
    c2si = C(:,:,i).^2./sigma(:,:,i);
    J1 = J1 + conv2(I.*M(:,:,i),K,'same').*csi;
    J2 = J2 + conv2(M(:,:,i),K,'same').*c2si;
end
Dalpha = J1./(J2+(J2==0).*eps);                    % Eq.(19)

%--------Update the deformation D_beta----------------
function Dbeta = update_Dbeta(I,G,M,C)
[row,col,dim] = size(M);
J1 = zeros(row,col);
J2 = J1;
for i = 1:dim
    csi  = C(:,:,i);
    c2si = C(:,:,i).^2;
    J1 = J1 + conv2(I.*M(:,:,i),G,'same').*csi;
    J2 = J2 + conv2(M(:,:,i),G,'same').*c2si;
end
Dbeta = J1./(J2+(J2==0).*eps);                     % Eq.(19)

%--------Update the intensity deviation sigma----------------
function sigma = update_sigma(I,D,F,C,M)             
[row,col,dim] = size(C);
I2 = I.^2;
for i = 1:dim
    MI1F = conv2(M(:,:,i).*I2,F,'same');
    DC = D.*(C(:,:,i));
    DCMIF = -2*DC.*conv2(M(:,:,i).*I,F,'same');
    DC2MF = DC.^2.*conv2(M(:,:,i),F,'same');
    Top = sum(sum(MI1F+DCMIF+DC2MF));
    Buttom = conv2(M(:,:,i),F,'same');
    de =  sum(sum(Buttom));
    de  = de + (de==0)*eps;
    sigma(1:row,1:col,i) = Top/de;                 % Eq.(21)
end

%--------Update the intermediate level set function----------------
function phi = update_phi(phi,e,timestep_T,epsilon)
phi = NeumannBoundCond(phi);
DiracF = Dirac(phi,epsilon);
F = e(:,:,2)-e(:,:,1);
phi = phi + timestep_T*(F.*DiracF);                      % Eq.(22)

function e = update_e(I,F_rho,G_rho,sigma,D_alpha,D_beta,C_alpha,C_beta,k)
[row,col,dim] = size(sigma);
sigma = sqrt(sigma);
for i = 1:dim
    E_nc1 = I.^2.*conv2(1./(sigma(:,:,i).^2),F_rho,'same');
    E_nc2 = -2*C_alpha(:,:,i).*I.*conv2(D_alpha./(sigma(:,:,i).^2),F_rho,'same');
    E_nc3 = C_alpha(:,:,i).^2.*conv2(D_alpha.^2./(sigma(:,:,i).^2),F_rho,'same');
    E_ep1 = I.^2.*conv2(1,G_rho,'same');
    E_ep2 = -2*C_beta(:,:,i).*I.*conv2(D_beta,G_rho,'same');
    E_ep3 = C_beta(:,:,i).^2.*conv2(D_beta.^2,G_rho,'same');
    e(:,:,i) = conv2(log(sigma(:,:,i)),F_rho,'same')+...
        (E_nc1+E_nc2+E_nc3)./2+k*(E_ep1+E_ep2+E_ep3);   % Eq.(23)
end
%--------Neumann boundary condition----------------
function g = NeumannBoundCond(f)
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1)  = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol])  = g(2:end-1,[3 ncol-2]);

%--------Heaviside function----------------
function H = Heaviside(u,epsilon)
H = 0.5*(1+2/pi*atan(u./epsilon));                       % Eq.(13)

%--------Dirac delta function----------------
function DrcU = Dirac(u,epsilon)
DrcU = (epsilon/pi)./(epsilon^2+u.^2);                   % Eq.(24)

%--------Two-dimension membership function----------------
function M = update_M(phi1,epsilon)
phi1=NeumannBoundCond(phi1);
H1 = Heaviside(phi1,epsilon);
M(:,:,1) = H1;
M(:,:,2) = 1-H1;