function w = DSCluster(data, weight, iter_thresh, epsilon)

if ~exist('epsilon','var')
    epsilon = 0.001;
end

if ~exist('iter_thresh','var')
    iter_thresh = 1e+4;
end

if ~exist('weight','var')
    weight = ones(size(data,2),1);
end

A = pdist2(data', data', 'seuclidean');
sigma2 = median( A(:) );
A = exp(-A / sigma2);

A = weight * weight' .* A;

w = ones( size(A,1), 1 );
w = w / sum(w);

A = A - diag(diag(A));
init_obj = w'*A*w;
old_obj = 0;
obj = init_obj;

iter_no = 1;
while( (obj - old_obj) / init_obj > epsilon && iter_no < iter_thresh )
    old_obj = obj;
    w = w .* ( (A*w)/(w'*A*w) );
    w = w / sum(w);
    w( isnan(w) ) = 0;
    obj = w'*A*w;
    iter_no = iter_no +1;
end

% plot(data(:,1),data(:,2),'.');
% hold on;
% plot(data(w>1e-2,1),data(w>1e-2,2),'ro');
% hold off;
% pause();

end
