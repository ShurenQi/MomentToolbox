function [I,F] = ZM_qRecursive(I,n)

N=size(I,1);
F=zeros(size(I));
x = 1:N;
y = x;
[X,Y] = meshgrid(x,y);
R = sqrt((2.*X-N-1).^2+(2.*Y-N-1).^2)/N;
% R = R./sqrt(2);
Theta = atan2((N-1-2.*Y+2),(2.*X-N+1-2));
PZ=R>1;
R(PZ) = 0.2;
I(PZ) = 0;

r = R ;
nmax = n;
rr = r.^2;
for n=0:1:nmax+1
    m = n-4;
    while m>= 0
        H3mn(n+1,m+1) = -(4 * (m + 2)*(m + 1)) / ((n + m + 2)*(n - m));
        H2mn(n+1,m+1) = H3mn(n+1,m+1) * (n + m + 4)*(n - m - 2) / (4 * (m + 3)) + (m + 2);
        H1mn(n+1,m+1) = (m + 4)*(m + 3) /2 - H2mn(n+1,m+1) * (m + 4) +...
            H3mn(n+1,m+1) * (n + m + 6)*(n - m - 4) / 8.0;
        m = m - 2;
    end
end

for n=0:1:nmax+1
    m = n;
    Rn = r.^n;
    if n>1
        Rnm2 = r.^(n-2);
    end
    while m>= 0
        if (m == n)
            Rnm = Rn;
            Rnmp4 = Rn;  %% save Rn(m+4)
        else
            if (m == n - 2)
                Rnnm2 = n.*Rn - (n - 1).*Rnm2;
                Rnm = Rnnm2;
                Rnmp2 = Rnnm2;  %% save Rn(m+2)
            else
                H3 = H3mn(n+1,m+1);
                H2 = H2mn(n+1,m+1);
                H1 = H1mn(n+1,m+1);
                Rnm = H1.*Rnmp4 + (H2 + H3 ./ rr).*Rnmp2;
                Rnmp4 = Rnmp2;  %% Rnmp2 now becomes Rnmp4 for next m
                Rnmp2 = Rnm;  %% Rnm becomes Rnmp2 for next m
            end
        end
        Rad = Rnm;
        Product = I(x,y).*Rad.*exp(-1i*m*Theta);
        Z = sum(Product(:));
        cnt = nnz(Rad)+1;%?        Z = (n+1)*Z/cnt;
        Z = 4*(n+1)*Z/(pi*cnt);
        Znm = Z; 
        Exp=exp(1i*m*Theta);
        F=F+Znm.*Rad.*Exp;
        m = m-2;
    end
end
F=real(F);
x = 1:N;
y = x;
[X,Y] = meshgrid(x,y);
R = sqrt((2.*X-N-1).^2+(2.*Y-N-1).^2)/N;
PZ=R>1;
F(PZ)=0;
I(PZ)=0;
end



