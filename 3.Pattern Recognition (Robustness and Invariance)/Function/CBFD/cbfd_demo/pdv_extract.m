function PDV =pdv_extract(data,M,N)
% Extract random PDV's at R=3 at different local regions
% Input: 
%       data: face images
%       M: number of blocks in row level
%       N: number of blocks in column level
%              
% Output:
%       PDV: Pixel Difference Vectors at R=3


% extract PDV samples from data
nn = [-3 -3; -2 -3; -1 -3; 0 -3; 1 -3; 2 -3; 3 -3; -3 -2; -2 -2; ...
    -1 -2;  0 -2; 1 -2; 2 -2;  3 -2; -3 -1;-2 -1;-1 -1; 0 -1; 1 -1; ... 
     2 -1; 3 -1; -3  0; -2 0; -1  0; 1 0; 2 0; 3 0; -3 1; -2 1; -1 1; ...
     0  1; 1 1; 2 1; 3  1; -3 2; -2 2;-1 2;0 2;1 2; 2 2; 3 2; -3 3; ...
    -2 3; -1 3; 0 3; 1 3;2 3; 3 3];
R = 3;

randnum1 = min(16,floor((size(data,1)-R*2)/M));
randnum2 = min(16,floor((size(data,2)-R*2)/N));
PDV = cell(M, N);
for i=1:M
    for j=1:N
        PDV{i,j} = zeros(randnum1*randnum2*size(data,3),size(nn,1));
    end
end
cnt = 0;

perm1 = randperm(floor((size(data,1)-R*2)/M));
perm2 = randperm(floor((size(data,2)-R*2)/N));

for d=1:size(data,3)
    Tdata = double(data(:,:,d));
    Tdata = preproc2(Tdata,0.2,1,2,[],[],10);
    [h, w] = size(data(:,:,d));

    CG = Tdata((R+1):(h-R), (R+1):(w-R));
    Tcode1 = zeros(size(CG,1),size(CG,2),size(nn,1));
    
    for ii=1:size(nn,1)
        Tmp = Tdata(((R+1):(h-R))+nn(ii,1),((R+1):(w-R))+nn(ii,2));
        Tcode1(:, :, ii) = Tmp-CG;
    end
    
    [Th, Tw, ~] = size(Tcode1);
    delta_h = floor(Th / M);
    delta_w = floor(Tw / N);
        
    for i = 1:M
        s_h = delta_h * (i-1) + 1;
        e_h = s_h + delta_h - 1;
        e_h = min(e_h, Th);
        for j = 1:N
            s_w = delta_w * (j-1) + 1;
            e_w = s_w + delta_w - 1;
            e_w = min(e_w, Tw);
            Tmp = Tcode1(s_h:e_h, s_w:e_w, :);
            PDV{i,j}(cnt+1:cnt+randnum1*randnum2,:) = ...
                reshape(Tmp(perm1(1:randnum1),perm2(1:randnum2),:),randnum1*randnum2,size(nn,1));
        end
    end
    cnt = cnt + randnum1*randnum2;
end

