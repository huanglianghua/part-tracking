function bboxes = Sample(bbox, opt)

n = opt.nsample;
bboxes = repmat(bbox, 1, n) + randn(6, n) .* repmat(opt.sigma, 1, n);

end