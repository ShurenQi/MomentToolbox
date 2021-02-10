function block_fea = getHist(Tmp,B)
dict_size = size(B,1);
dist_mat = sp_dist2(Tmp, B);
[min_dist, min_ind] = min(dist_mat, [], 2);
block_fea = hist(min_ind, 1:dict_size);
if(sum(block_fea)~=0)
    block_fea = block_fea ./ sum(block_fea);
    block_fea = sqrt(block_fea);
end  
