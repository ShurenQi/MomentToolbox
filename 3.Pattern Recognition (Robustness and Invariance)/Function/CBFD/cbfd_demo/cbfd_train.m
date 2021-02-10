% CBFD Training for MxN local regions

load feret\train.mat
PDV =pdv_extract(data,params.M,params.N);
for i=1:params.M
    for j=1:params.N
        fprintf('learn CBFD for PDV region (%i,%i)',i,j);
        W{i,j} = cbfd_learn(PDV{i,j},params.binsize, ...
            params.n_iter,params.lambda1,params.lambda2);
        D{i,j} = CalculateDictionary(double(PDV{i,j}*W{i,j} >0), ...
            params.dictsize); 
    end
end