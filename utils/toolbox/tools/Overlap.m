function overlap = Overlap( bboxes, bbox )
%%%%
n = size(bboxes,2);

% [32,32]的大小不影响重叠率计算结果
rects = ToRect(bboxes, [32,32]);
rect0 = ToRect(bbox, [32 32]);

%% calculate overlap rate

left_tracker = rects(:,1);
bottom_tracker = rects(:,2);
right_tracker = left_tracker + rects(:,3) - 1;
top_tracker = bottom_tracker + rects(:,4) - 1;

left_anno = repmat(rect0(1), n,1);
bottom_anno = repmat(rect0(2), n,1);
right_anno = left_anno + repmat(rect0(3), n,1) - 1;
top_anno = bottom_anno + repmat(rect0(4), n,1) - 1;

tmp = (max(0, min(right_tracker, right_anno) - max(left_tracker, left_anno)+1 )) .* (max(0, min(top_tracker, top_anno) - max(bottom_tracker, bottom_anno)+1 ));
area_tracker = rects(:,3) .* rects(:,4);
area_anno = rect0(:,3) .* rect0(:,4);
overlap = tmp./(area_tracker+area_anno-tmp);

end


function rects = ToRect(bboxes, tsize)

w = bboxes(3,:) * tsize(2);
h = bboxes(5,:) .* w;
x = bboxes(1,:) - (w-1) / 2;
y = bboxes(2,:) - (h-1) / 2;

rects = [x; y; w; h]';

end