function Save(bboxes, opt)

if isfield(opt,'dosave') && ~opt.dosave
    return;
end

path = [opt.savePath 'rects/'];
if ~exist(path,'dir'); mkdir(path); end

if size(bboxes,1) == 6
    bboxes = ToRect(bboxes, opt.tsize);
end

dlmwrite([path opt.title '.txt'], bboxes);

end

function rects = ToRect(bboxes, tsize)

w = bboxes(3,:) * tsize(2);
h = bboxes(5,:) .* w;
x = bboxes(1,:) - (w-1) / 2;
y = bboxes(2,:) - (h-1) / 2;

rects = [x; y; w; h]';

end