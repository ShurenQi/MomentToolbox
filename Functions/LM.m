function [I,It,L,DT,RT ] =LM(I,K)
%% REF
% https://en.wikipedia.org/wiki/Legendre_polynomials.
% M. R. Teague, Image analysis via the general theory of moments, J. Opt. Soc. Am., 70 (1980) 920-930.
% Yap, Pew-Thian, and Raveendran Paramesran. "An efficient method for the computation of Legendre moments." IEEE Transactions on Pattern Analysis and Machine Intelligence 27.12 (2005): 1996-2002.
%% DE
tic;
[ X,P ]=LM_D(I,K);
DT=toc;
[L,~]=size(find(X~=0));
%% RE
tic;
Y=LM_R(X,P);
RT=toc;
It=abs(Y);
end

