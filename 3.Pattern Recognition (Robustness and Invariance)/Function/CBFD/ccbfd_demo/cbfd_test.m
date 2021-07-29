function fea = cbfd_test(img,W,D,params)
% Extract full face represenentation 
% Input: 
%       img: face image (scaled 0-255)
%       W: MxN Projection matrices
%       D: MxN Dictionary matrices
% Output:
%       fea: histogram representation for face image

dict_size = params.dictsize;
M = params.M;
N = params.N;

Tdata = double(img);
[h, w] = size(img);

nn = [-3 -3; -2 -3; -1 -3; 0 -3; 1 -3; 2 -3; 3 -3; -3 -2; -2 -2; ...
    -1 -2;  0 -2; 1 -2; 2 -2;  3 -2; -3 -1;-2 -1;-1 -1; 0 -1; 1 -1; ... 
     2 -1; 3 -1; -3  0; -2 0; -1  0; 1 0; 2 0; 3 0; -3 1; -2 1; -1 1; ...
     0  1; 1 1; 2 1; 3  1; -3 2; -2 2;-1 2;0 2;1 2; 2 2; 3 2; -3 3; ...
    -2 3; -1 3; 0 3; 1 3;2 3; 3 3];
R = 3;

CG = Tdata((R+1):(h-R), (R+1):(w-R));
Tcode1 = zeros(size(CG,1),size(CG,2),size(nn,1));
for ii=1:size(nn,1)
    Tmp = Tdata(((R+1):(h-R))+nn(ii,1),((R+1):(w-R))+nn(ii,2));
    Tcode1(:, :, ii) = Tmp-CG;
end

[Th, Tw, ~] = size(Tcode1);
delta_h = round(Th / M);
delta_w = round(Tw / N);

fea = zeros(1,M*N*dict_size);
cnt=0;
for i = 1:M
    s_h = delta_h * (i-1) + 1;
    e_h = s_h + delta_h - 1;
    e_h = min(e_h, Th);
    for j = 1:N
        s_w = delta_w * (j-1) + 1;
        e_w = s_w + delta_w - 1;
        e_w = min(e_w, Tw);
        Tmp = Tcode1(s_h:e_h, s_w:e_w, :);
        [t_h, t_w, t_d] = size(Tmp);
        Tmp = reshape(Tmp, t_h*t_w, t_d);

        fea((cnt+1):cnt+dict_size)= ...
          getHist(double(Tmp*W{i,j} > 0), D{i,j});
        cnt = cnt+dict_size;
    end
end

