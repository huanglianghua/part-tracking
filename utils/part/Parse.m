function [parts, areas] = Parse(bbox, tsize)

bboxes = zeros(6,7);

bboxes(:,1) = bbox;
bboxes(:,2:3) = Divide(bbox, tsize);
bboxes(:,4:5) = Divide(bboxes(:,2), tsize);
bboxes(:,6:7) = Divide(bboxes(:,3), tsize);

delta = bsxfun(@minus, bbox, bboxes);

for i = 1:size(bboxes,2)
    parts{i}.bbox = bboxes(:,i);
    parts{i}.delta = delta(:,i);
end

areas = Area(bboxes, tsize);

end


function parts = Divide(bbox, tsize)
    rect = ToRect(bbox, tsize);

    x = rect(1);
    y = rect(2);
    w = rect(3);
    h = rect(4);

    if w > h
        rects(1,:) = [x, y, w/2, h];
        rects(2,:) = [x+w/2, y, w/2, h];
    else
        rects(1,:) = [x, y, w, h/2];
        rects(2,:) = [x, y+h/2, w, h/2];
    end

    parts = ToAffine(rects, tsize);
end


function rects = ToRect(bboxes, tsize)

w = bboxes(3,:) * tsize(1);
h = bboxes(5,:) .* w;
x = bboxes(1,:) - (w-1) / 2;
y = bboxes(2,:) - (h-1) / 2;

rects = [x; y; w; h]';

end


function affines = ToAffine(rects, tsize)
    n = size(rects,1);

    w = rects(:,3);
    h = rects(:,4);
    x = rects(:,1) + (w-1) / 2;
    y = rects(:,2) + (h-1) / 2;

    affines = [x y w/tsize(1) zeros(n,1) h./w zeros(n,1)]';
end


function areas = Area(bboxes, tsize)
    areas = bboxes(3,:) .* bboxes(5,:) .* tsize(1);
end
