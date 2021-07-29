function MiaProvaConPCAnet(datas, fold)

%datas è id del dataset
%fold è id del n-fold cross validation
load(strcat('C:\Lavoro\Implementazioni\PersonReID\Funzioni\Datas_',int2str(datas)),'DATA');

NF=size(DATA{3},1); %number of folds
DIV=DATA{3};
DIM1=DATA{4};
DIM2=DATA{5};
yE=DATA{2};

% Set parameters
params.ht = 128;
params.wt = 128;
params.N = 4%8;
%N.B.!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Numero di sotto-regioni dalle quali estrarre le features, anche in PAP migliora molto se uso 2*2 invece che solo whole image
params.M = 4%8;
params.lambda1 = 0.001;
params.lambda2 = 0.0001;
params.binsize = 15;
params.dictsize = 500;
params.n_iter = 20;
params.coeff = 1000;





if fold>NF%non c'è tale fold in questo dataset
else
    
    
    
    
    clear DAT
    for i=1:length(DATA{1})
        clear IMG
        IMG=single(DATA{1}{i});
        
        if size(IMG,3)==3
            IMG=rgb2gray(IMG);
        end
        
        IMG=imresize(IMG,[128 128]);%sbrocca se non faccio resize
        
        DAT(:,:,i)= IMG;
    end
    
    if datas==13 %HEP dataset
        testPattern=DIV{fold};
        TR=DAT; TR(testPattern,:)=[];
        TE=DAT(testPattern,:);
        y=yE;y(testPattern)=[];
        yy=yE(testPattern);
    elseif datas==14 %Painting91
        TR=DAT(DIM2,:);
        TE=DAT(DIM1,:);
        y=yE(DIM2);
        yy=yE(DIM1);
    else
        y=yE(DIV(fold,1:DIM1));
        yy=yE(DIV(fold,DIM1+1:DIM2));
        TR=DAT(:,:,DIV(fold,1:DIM1),:);
        TE=DAT(:,:,DIV(fold,DIM1+1:DIM2),:);
    end
    TR(:,:,find(y==0))=[];
    TE(:,:,find(yy==0))=[];
    y(find(y==0))=[];
    yy(find(yy==0))=[];
    
    % CBFD Training for MxN local regions
    PDV =pdv_extract(TR,params.M,params.N);
    for i=1:params.M
        for j=1:params.N
            W{i,j} = cbfd_learn(PDV{i,j},params.binsize, ...
                params.n_iter,params.lambda1,params.lambda2);
            D{i,j} = CalculateDictionary(double(PDV{i,j}*W{i,j} >0), ...
                params.dictsize);
        end
    end
    
    %estrarre features: training set
    Xtrain = extractFeature(TR,W,D,params);
    [eigvec2,eigval,~,sampleMean] = PCA(Xtrain);
    eigvec = (bsxfun(@rdivide,eigvec2',sqrt(eigval))');
    if params.coeff>size(eigvec,2)
        params.coeff=size(eigvec,2);
    end
    TR = (bsxfun(@minus, Xtrain, mean(Xtrain))*eigvec(:,1:params.coeff));
    
    
    %estrarre features test set
    Xtest = extractFeature(TE,W,D,params);
    TE = (bsxfun(@minus, Xtest, sampleMean)*eigvec(:,1:params.coeff));
    
    [DecisionValuec]=PoolSVMnormalizationRID(double(TR),double(TE),double(y),double(yy),1);
    [DecisionValued]=PoolSVMhistRBF(double(TR),double(TE),double(y'),double(yy'));
    
    
    
    save(strcat('Cbfd_',num2str(datas),'_',num2str(fold),'.mat'),'yy','DIV','DecisionValuec','DecisionValued');
    
end





