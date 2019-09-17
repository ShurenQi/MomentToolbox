function [I,It,L,DT,RT ] =TM(I,K)
%% REF
% https://en.wikipedia.org/wiki/Chebyshev_polynomials
% https://github.com/PanosNikolaou/Tchebichef-moments
% Mukundan, Ramakrishnan, S. H. Ong, and Poh Aun Lee. "Image analysis by Tchebichef moments." IEEE Transactions on image Processing 10.9 (2001): 1357-1364.
%% DE
tic;
[ X,P ]=TM_D(I,K);
DT=toc;
[L,~]=size(find(X~=0));
%% RE
tic;
Y=TM_R(X,P);
RT=toc;
It=abs(Y);
end

