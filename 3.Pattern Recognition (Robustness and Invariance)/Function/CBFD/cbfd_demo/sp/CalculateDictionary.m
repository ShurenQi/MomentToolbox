function dictionary = CalculateDictionary(feature,dictionarySize)
%% k-means

fprintf('Building Dictionary\n\n');

reduce_flag = 1;
ndata_max = 100000;   % use 4% avalible memory if its greater than the default

ndata = size(feature,1);

if (reduce_flag > 0) && (ndata > ndata_max)
%     fprintf('Reducing to %d descriptors\n', ndata_max);
    p = randperm(ndata);
    feature = feature(p(1:ndata_max), :);
end


%% perform clustering
options = zeros(1,14);
options(1) = 1; % display
options(2) = 1;
options(3) = 0.001; % precision  0.1
options(5) = 1; %centers initialize
centers = zeros(dictionarySize, size(feature,2));

options(14) = 200; % maximum iterations

%% run kmeans
% fprintf('\nRunning k-means\n');

dictionary = sp_kmeans(centers, feature, options);

%%