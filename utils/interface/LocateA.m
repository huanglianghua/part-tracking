function model = Locate(frame, model, opt)

n = length(model.parts);
parts = model.parts;

% alpha sampling

idx_a = randsampleWRW(n, opt.n_alpha, model.alpha);

% track

beta = zeros(opt.n_alpha, 1);

for i = 1:opt.n_alpha
    k = idx_a(i);
    [parts{k}.bbox, beta(i)] = pLocate(frame, parts{k}.bbox, parts{k}.model, opt);
    disp(['part ' num2str(k) ' locate ' num2str(beta(i))]);
end

% beta sampling

[~, sort_idx] = sort(beta, 'descend');
idx_b = sort_idx(1:opt.n_beta);

% locate

bboxes = GetBBox( parts(idx_a(idx_b)), true );
bbox = Vote(bboxes, [], opt);

% relocate

for i = 1:n
    if any( idx_a(idx_b)==i ), continue, end
    parts{i}.bbox = bbox - parts{i}.delta;
    parts{i}.bbox = pLocate(frame, parts{i}.bbox, parts{i}.model, opt);
end

% update alpha

bboxes = GetBBox(parts, true);
% alpha = DSCluster(bboxes(1:2,:));
alpha = normp(bboxes, bbox, 1.5)';
model.alpha = opt.ff_alpha * model.alpha + (1 - opt.ff_alpha) * alpha;

model.bbox = bbox;
model.parts = parts;
model.idx = idx_b;

end


function p = normp(x, mu, sigma)

dx = bsxfun(@minus, x, mu);
dx2 = sum(dx.*dx, 1);

p = (1 / (sqrt(2*pi) * sigma)) * ...
    exp( -dx2 ./ (2*sigma*sigma) );

end
