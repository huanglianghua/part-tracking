function model = Locate(frame, model, opt)

n = length(model.parts);
do_update = ones(n,1);

% locate parts

parts = model.parts;
beta = zeros(n, 1);

for i = 1:n
    disp(['part ' num2str(i) ' locate']);
    [parts{i}.bbox, beta(i)] = pLocate(frame, parts{i}.bbox, parts{i}.model, opt);
end

% alpha sampling

[~,idx_sort] = sort(model.alpha, 'descend');
idx_a = idx_sort(1:opt.n_alpha);

% beta sampling

idx_b = [];

for i = 1:opt.n_alpha
    k = idx_a(i);
    if beta(k) > opt.thr_beta
        idx_b = [idx_b k];
    end
end

if length(idx_b) < opt.n_beta
    idx_b = idx_a(1:opt.n_beta);
end

% locate target

bboxes = GetBBox(parts(idx_b), true);
bbox = Vote(bboxes, [], opt);
% bbox = Vote(bboxes, model.alpha(idx_b), opt);

% relocate

for i = 1:n
    dist = pdist2(parts{i}.bbox', bbox');
    
    if ~any(idx_b == i) || dist > 15
        parts{i}.bbox = pLocate(frame, bbox - parts{i}.delta, parts{i}.model, opt);
    end
    
    dist = pdist2(parts{i}.bbox', bbox');
    
    if dist > 80
        parts{i}.bbox = bbox - parts{i}.delta;
%         do_update(i) = 0;
    end
end

% update alpha

bboxes = GetBBox(parts, true);
% alpha = DSCluster(bboxes(1:2,:));
alpha = normp(bboxes, bbox, 1.5)';
model.alpha = opt.ff_alpha * model.alpha + (1 - opt.ff_alpha) * alpha;

model.bbox = bbox;
model.parts = parts;
model.do_update = do_update;

end

function p = normp(x, mu, sigma)

dx = bsxfun(@minus, x, mu);
dx2 = sum(dx.*dx, 1);

p = (1 / (sqrt(2*pi) * sigma)) * ...
    exp( -dx2 ./ (2*sigma*sigma) );

end
