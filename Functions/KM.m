function [I,It,L,DT,RT,P ] =KM(I,K)
%% REF
% Yap, P-T., Raveendran Paramesran, and Seng-Huat Ong. "Image analysis by Krawtchouk moments." IEEE Transactions on image processing 12.11 (2003): 1367-1377.
% http://www.pudn.com/Download/item/id/1205413.html
%% MODE
disp('Constraints: (0<P<1).');
P=input('P=');
%% DE
tic;
[ X,K ]=KM_D(I,K,P);
DT=toc;
[L,~]=size(find(X~=0));
%% RE
tic;
Y=KM_R(X,K);
RT=toc;
It=abs(Y);
end

