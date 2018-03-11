function model = SVMInit(X, y, sample_weight)

if nargin < 3
    sample_weight = ones(size(y));
end

% svm parameters

model.sv_size = 500;% maxial 100 cvs
model.C = 100;
model.B = 80;
model.B_p = 10;% for positive sv

model.m1 = 1;% for tvm
model.m2 = 2;% for tvm

sample_w = sample_weight;
       
pos_mask = y > 0.5;
neg_mask = ~pos_mask;
s1 = sum(sample_w(pos_mask));
s2 = sum(sample_w(neg_mask));
        
sample_w(pos_mask) = sample_w(pos_mask) * s2;
sample_w(neg_mask) = sample_w(neg_mask) * s1;
        
C = max(model.C * sample_w/sum(sample_w), 0.001);
        
% model.clsf = svmtrain( X, y, 'boxconstraint',C,'autoscale','false','quadprog_opts',optimset('maxiter',1000000));
model.clsf = svmtrain( X, y, 'boxconstraint',C,'autoscale','false',...
    'quadprog_opts',statset('MaxIter',15000),...
    'smo_opts', internal.stats.svmsmoset('TolKKT', 1e-2));
        
model.clsf.w = model.clsf.Alpha' * model.clsf.SupportVectors;
model.w = model.clsf.w;
model.Bias = model.clsf.Bias;
model.sv_label = y(model.clsf.SupportVectorIndices,:);
model.sv_full = X(model.clsf.SupportVectorIndices,:);
        
model.pos_sv = model.sv_full(model.sv_label>0.5,:);
model.pos_w = ones(size(model.pos_sv,1),1);
model.neg_sv = model.sv_full(model.sv_label<0.5,:);
model.neg_w = ones(size(model.neg_sv,1),1);
        
% compute real margin
pos2plane = -model.pos_sv * model.w';
neg2plane = -model.neg_sv * model.w';
model.margin = (min(pos2plane) - max(neg2plane))/norm(model.w);
        
% calculate distance matrix
if size(model.pos_sv,1) > 1
    model.pos_dis = squareform(pdist(model.pos_sv));
else
    model.pos_dis = inf;
end
model.neg_dis = squareform(pdist(model.neg_sv)); 

end