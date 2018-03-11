function [bbox, cred, w] = Vote(bboxes, confidence, opt)

if isempty(confidence) || ~opt.conf
    confidence = ones(size(bboxes,2),1) / size(bboxes,2);
end

switch lower(opt.vote)
case 'ds'
    w = DSCluster(bboxes(1:2,:), confidence);
    bbox = bboxes * w;
case 'med'
    bbox = Median(bboxes, confidence);
case 'ms'
    bbox = MeanShift(bboxes, confidence);
end

cred = sum(normp(bboxes, bbox, opt.sigCred));
% cred = dot(normp(bboxes, bbox, opt.sigCred), w);

end


function p = normp(x, mu, sigma)

dx = bsxfun(@minus, x, mu);
dx2 = sum(dx.*dx, 1);

p = (1 / (sqrt(2*pi) * sigma)) * ...
    exp( -dx2 ./ (2*sigma*sigma) );

end
