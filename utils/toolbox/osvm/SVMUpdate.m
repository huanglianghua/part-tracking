function model = SVMUpdate(X, y, model, sample_weight)

if ~exist('sample_weight','var')
    sample_weight = ones(size(y));
end

% score = max(SVMPredict(X,model));
% disp( ['Max Score: ' num2str(score)] );

X = [model.pos_sv; model.neg_sv; X];
y = [ones(size(model.pos_sv,1),1); zeros(size(model.neg_sv,1),1); y];% positive:1 negative:0
sample_w = [model.pos_w; model.neg_w; sample_weight];
       
pos_mask = y > 0.5;
neg_mask = ~pos_mask;
s1 = sum(sample_w(pos_mask));
s2 = sum(sample_w(neg_mask));
        
sample_w(pos_mask) = sample_w(pos_mask)*s2;
sample_w(neg_mask) = sample_w(neg_mask)*s1;
        
C = max(model.C * sample_w/sum(sample_w), 0.001);

% model.clsf = svmtrain( X, y, ...%'kernel_function',@kfun,'kfunargs',{svm_tracker.struct_mat},...
%        'boxconstraint',C,'autoscale','false','options',statset('MaxIter',5000));
model.clsf = svmtrain( X, y, ...%'kernel_function',@kfun,'kfunargs',{svm_tracker.struct_mat},...
       'boxconstraint',C,'autoscale','false','quadprog_opts',optimset('maxiter',2000));

%**************************
model.w = model.clsf.Alpha'*model.clsf.SupportVectors;
model.Bias = model.clsf.Bias;
model.clsf.w = model.w;
% get the idx of new svs
sv_idx = model.clsf.SupportVectorIndices;
sv_old_sz = size(model.pos_sv,1)+size(model.neg_sv,1);
sv_new_idx = sv_idx(sv_idx>sv_old_sz);
sv_new = X(sv_new_idx,:);
sv_new_label = y(sv_new_idx,:);
        
num_sv_pos_new = sum(sv_new_label);
        
% update pos_dis, pos_w and pos_sv
pos_sv_new = sv_new(sv_new_label>0.5,:);
if ~isempty(pos_sv_new)
    if size(pos_sv_new,1)>1
        pos_dis_new = squareform(pdist(pos_sv_new));
    else
        pos_dis_new = 0;
    end
    pos_dis_cro = pdist2(model.pos_sv,pos_sv_new);
    model.pos_dis = [model.pos_dis, pos_dis_cro; pos_dis_cro', pos_dis_new];
    model.pos_sv = [model.pos_sv;pos_sv_new];
    model.pos_w = [model.pos_w; ones(num_sv_pos_new,1)];
end
        
% update neg_dis, neg_w and neg_sv
neg_sv_new = sv_new(sv_new_label<0.5,:);
if ~isempty(neg_sv_new)
    if size(neg_sv_new,1)>1
        neg_dis_new = squareform(pdist(neg_sv_new));
    else
        neg_dis_new = 0;
    end
    neg_dis_cro = pdist2(model.neg_sv,neg_sv_new);
    model.neg_dis = [model.neg_dis, neg_dis_cro; neg_dis_cro', neg_dis_new];
    model.neg_sv = [model.neg_sv;neg_sv_new];
    model.neg_w = [model.neg_w;ones(size(sv_new,1)-num_sv_pos_new,1)];
end
        
model.pos_dis = model.pos_dis + diag(inf*ones(size(model.pos_dis,1),1));
model.neg_dis = model.neg_dis + diag(inf*ones(size(model.neg_dis,1),1));
        
        
% compute real margin
pos2plane = -model.pos_sv*model.w';
neg2plane = -model.neg_sv*model.w';
model.margin = (min(pos2plane) - max(neg2plane))/norm(model.w);
        
% ����֧����������
% check if to remove
if size(model.pos_sv,1) + size(model.neg_sv,1) > model.B
    pos_score_sv = -(model.pos_sv*model.w'+model.Bias);
    neg_score_sv = -(model.neg_sv*model.w'+model.Bias);
    m_pos = abs(pos_score_sv) < model.m2;
    m_neg = abs(neg_score_sv) < model.m2;
    
    if sum(m_pos) > 0
        model.pos_sv = model.pos_sv(m_pos,:);
        model.pos_w = model.pos_w(m_pos,:);
        model.pos_dis = model.pos_dis(m_pos,m_pos);
    end

    if sum(m_neg) > 0
        model.neg_sv = model.neg_sv(m_neg,:);
        model.neg_w = model.neg_w(m_neg,:);
        model.neg_dis = model.neg_dis(m_neg,m_neg);
    end
end
        
% ����Ƿ���Ҫ�ϲ�
while size(model.pos_sv,1)+size(model.neg_sv,1)>model.B
    [mm_pos,idx_pos] = min(model.pos_dis(:));
    [mm_neg,idx_neg] = min(model.neg_dis(:));
            
%     if mm_pos > mm_neg || size(model.pos_sv,1) <= model.B_p% merge negative samples
    if mm_pos > mm_neg
        [i,j] = ind2sub(size(model.neg_dis),idx_neg);
        w_i= model.neg_w(i);
        w_j= model.neg_w(j);
        merge_sample = (w_i*model.neg_sv(i,:)+w_j*model.neg_sv(j,:))/(w_i+w_j);                
                
        model.neg_sv([i,j],:) = []; model.neg_sv(end+1,:) = merge_sample;
        model.neg_w([i,j]) = []; model.neg_w(end+1,1) = w_i + w_j;
                
        model.neg_dis([i,j],:)=[]; model.neg_dis(:,[i,j])=[];
        neg_dis_cro = pdist2(model.neg_sv(1:end-1,:),merge_sample);
        model.neg_dis = [model.neg_dis, neg_dis_cro;neg_dis_cro',inf];                
    else
        [i,j] = ind2sub(size(model.pos_dis),idx_pos);
        w_i = model.pos_w(i);
        w_j = model.pos_w(j);
        merge_sample = (w_i*model.pos_sv(i,:)+w_j*model.pos_sv(j,:))/(w_i+w_j);                

        model.pos_sv([i,j],:) = []; model.pos_sv(end+1,:) = merge_sample;
        model.pos_w([i,j]) = []; model.pos_w(end+1,1) = w_i + w_j;
                
        model.pos_dis([i,j],:)=[]; model.pos_dis(:,[i,j])=[];
        pos_dis_cro = pdist2(model.pos_sv(1:end-1,:),merge_sample);
        model.pos_dis = [model.pos_dis, pos_dis_cro;pos_dis_cro',inf];
    end   
end

end
