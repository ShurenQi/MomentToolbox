% Chi^2 histogram distance. A,B are matrices of example data
% vectors, one per column. The distance is sum_i
% (u_i-v_i)^2/(u_i+v_i+epsilon). The output distance matrix is
% (#examples in A)x(#examples in B)

function D = dist_cosine(A,B)

%fprintf('\n *** calculating CHI^2 histogram distance ');

[d,m]=size(A);
[d1,n]=size(B);
if (d ~= d1)
    error('column length of A (%d) != column length of B (%d)\n',d,d1);
end

A = bsxfun(@times, A, sqrt(sum(A.^2)));
B = bsxfun(@times, B, sqrt(sum(B.^2)));

% With the MATLAB JIT compiler the trivial implementation turns out
% to be the fastest, especially for large matrices.
D = zeros(m,n);
for i=1:m % m is number of samples of A 
    if (0==mod(i,1000)) fprintf('.'); end
%     for j=1:n % n is number of samples of B
%         D(i,j) = 1-A(:,i)'*B(:,j);
%     end
    D(i,:) = ones(1,n) - A(:,i)'*B;
end
%end
