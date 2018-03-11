function model = pInit(frame, bbox, opt)

bboxes = Sample(bbox, opt.train);

for c = 1:opt.ncascade
    % feature
    feats = Feature(frame, bboxes, opt);

    % offset
    delta = bsxfun(@minus, bboxes(1:2,:), bbox(1:2))';

    % confidence
    for i = 1:2
        model.cascades{c,i} = SVRInit(feats, delta(:,i));
        delta(:,i) = SVRPredict(feats, model.cascades{c,i});
    end
    bboxes(1:2,:) = bboxes(1:2,:) - delta';
    confidence = Overlap(bboxes, bbox);
    model.cascades{c,3} = SVRInit(feats, confidence);
end

end
