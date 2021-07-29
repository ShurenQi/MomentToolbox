function [BF,L,p,q,alpha,v]=getBF(MODE,SZ1,SZ2,K)
p=0;q=0;alpha=0;v=0;
[rho,theta]=ro(SZ1,SZ2);
pz=rho>1; rho(pz)= 0.5;
%% ZM    
if MODE==1
    L=(K+1)*(K+2)/2;
    index=1;
    BF=cell(1,L);
    for order=0:1:K
        for repetition=-order:2:order
            R=getZM_RBF(order,repetition,rho);
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% PZM    
elseif MODE==2
    L=(K+1)^2;
    index=1;
    BF=cell(1,L);
    for order=0:1:K
        for repetition=-order:1:order
            R=getPZM_RBF(order,repetition,rho);
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% OFMM
elseif MODE==3
    L=(K+1)*(2*K+1);
    index=1;
    BF=cell(1,L);
    for order=0:1:K
        R=getOFMM_RBF(order,rho);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% CHFM
elseif MODE==4
    L=(K+1)*(2*K+1);
    index=1;
    BF=cell(1,L);
    for order=0:1:K
        R=getCHFM_RBF(order,rho);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% PJFM
elseif MODE==5
    L=(K+1)*(2*K+1);
    index=1;
    BF=cell(1,L);
    for order=0:1:K
        R=getPJFM_RBF(order,rho);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% JFM
elseif MODE==6
    L=(K+1)*(2*K+1);
    index=1;
    BF=cell(1,L);
    disp('Parameter Setting: p-q>-1, q>0;');
    disp('e.g.');
    disp('-OFMM: p=2, q=2;');
    disp('-CHFM: p=2, q=3/2;');
    disp('-PJFM: p=4, q=3;');
    disp('-LFM: p=1, q=1');
    p = input('p=');
    q = input('q=');
    if p-q<=-1 || q<=0
        disp('Error!');
        return;
    end
    for order=0:1:K
        R=getJFM_RBF(order,rho,p,q);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% RHFM    
elseif MODE==7
    L=(K+1)*(2*K+1); 
    BF=cell(1,L);
    index=1;
    for order=0:1:K
        R=getRHFM_RBF(order,rho);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% EFM   
elseif MODE==8
    L=(2*K+1)^2; 
    BF=cell(1,L);
    index=1;
    for order=-K:1:K
        R=getEFM_RBF(order,rho);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% PCET    
elseif MODE==9
    L=(2*K+1)^2; 
    BF=cell(1,L);
    index=1;
    for order=-K:1:K
        R=getPCET_RBF(order,rho);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% PCT    
elseif MODE==10
    L=(K+1)*(2*K+1); 
    BF=cell(1,L);
    index=1;
    for order=0:1:K
        R=getPCT_RBF(order,rho);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% PST    
elseif MODE==11
    L=K*(2*K+1); 
    BF=cell(1,L);
    index=1;
    for order=1:1:K
        R=getPST_RBF(order,rho);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% BFM    
elseif MODE==12
    L=(K+1)*(2*K+1); 
    BF=cell(1,L);
    index=1;
    v=1;
    for order=0:1:K
        R=getBFM_RBF(order,rho,v);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% FJFM
elseif MODE==13
    L=(K+1)*(2*K+1);
    index=1;
    BF=cell(1,L);
    disp('Parameter Setting: p-q>-1, q>0, alpha>0;');
    disp('e.g.');
    disp('- OFMM: p=2, q=2, alpha=1;');
    disp('- CHFM: p=2, q=3/2, alpha=1;');
    disp('- PJFM: p=4, q=3, alpha=1;');
    disp('- LFM: p=1, q=1, alpha=1;');
    p = input('p=');
    q = input('q=');
    alpha=input('alpha=');
    if p-q<=-1 || q<=0 || alpha<=0
        disp('Error!');
        return;
    end
    for order=0:1:K
        R=getFJFM_RBF(order,rho,p,q,alpha);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% GRHFM    
elseif MODE==14
    L=(K+1)*(2*K+1); 
    BF=cell(1,L);
    index=1;
    disp('Parameter Setting: alpha>0;');
    disp('e.g.');
    disp('- RHFM: alpha=1;');
    alpha=input('alpha=');
    if alpha<=0
        disp('Error!');
        return;
    end
    for order=0:1:K
        R=getGRHFM_RBF(order,rho,alpha);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% GPCET    
elseif MODE==15
    L=(2*K+1)^2; 
    BF=cell(1,L);
    index=1;
    disp('Parameter Setting: alpha>0;');
    disp('e.g.');
    disp('- PCET: alpha=2;');
    disp('- EFM: alpha=1;');
    alpha=input('alpha=');
    if alpha<=0
        disp('Error!');
        return;
    end
    for order=-K:1:K
        R=getGPCET_RBF(order,rho,alpha);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% PCT    
elseif MODE==16
    L=(K+1)*(2*K+1); 
    BF=cell(1,L);
    index=1;
    disp('Parameter Setting: alpha>0;');
    disp('e.g.');
    disp('- PCT: alpha=2;');
    alpha=input('alpha=');
    if alpha<=0
        disp('Error!');
        return;
    end
    for order=0:1:K
        R=getGPCT_RBF(order,rho,alpha);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
%% PST    
elseif MODE==17
    L=K*(2*K+1); 
    BF=cell(1,L);
    index=1;
    disp('Parameter Setting: alpha>0;');
    disp('e.g.');
    disp('- PST: alpha=2;');
    alpha=input('alpha=');
    if alpha<=0
        disp('Error!');
        return;
    end
    for order=1:1:K
        R=getGPST_RBF(order,rho,alpha);
        for repetition=-K:1:K
            pupil =R.*exp(-1j*repetition * theta);
            BF{1,index}=pupil;
            index=index+1;
        end
    end
end

