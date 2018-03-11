function model = pUpdate(frame, bbox, model, opt)

% collect

bboxes = Sample(bbox, opt.train);

for c = 1:opt.ncascade
    % feature
    feats = Feature(frame, bboxes, opt);
    
    % offset
    delta = bsxfun(@minus, bboxes(1:2,:), bbox(1:2))';
    
    % confidence
    for i = 1:2        
        delta(:,i) = SVRPredict(feats, model.cascades{c,i});                        
    end
    bboxes(1:2,:) = bboxes(1:2,:) - delta';
    confidence = Overlap(bboxes, bbox);
    
    collection.data{c}.X = feats;
    collection.data{c}.y = [delta confidence];
end

model = Merge(model, collection);

% update

if model.collection.t >= opt.T
    for c = 1:opt.ncascade
        for i = 1:3
            model.cascades{c,i} = SVRUpdate(model.collection.data{c}.X, ...
                                            model.collection.data{c}.y(:,i), model.cascades{c,i});
        end
        model.collection.data{c}.X = [];
        model.collection.data{c}.y = [];
    end
    
    model.collection.t = 0;
end

end


function model = Merge(model, collection)

if ~isfield(model, 'collection')
    model.collection = collection;
    model.collection.t = 1;
else
    ncascade = length(collection.data);
    
    for c = 1:ncascade
        model.collection.data{c}.X = [model.collection.data{c}.X; collection.data{c}.X];
        model.collection.data{c}.y = [model.collection.data{c}.y; collection.data{c}.y];
    end
    
    model.collection.t = model.collection.t + 1;
end

end