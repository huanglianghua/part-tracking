function [bbox, cred] = pLocate(frame, bbox, model, opt)

bboxes = Sample(bbox, opt.detect);

for c = 1:opt.ncascade
    % feature
    feats = Feature(frame, bboxes, opt);

    % offset
    delta = zeros(size(bboxes,2),2);

    % confidence
    for j = 1:2
        delta(:,j) = SVRPredict(feats, model.cascades{c,j});
    end
    bboxes(1:2,:) = bboxes(1:2,:) - delta';
    tmp = SVRPredict(feats, model.cascades{c,3});

    if ~exist('weight','var'); confidence = 1; end
    confidence = double(tmp) .* confidence;
end

[bbox, cred] = Vote(bboxes, confidence, opt);

end
