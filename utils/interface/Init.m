function model = Init(frame, bbox, opt)

[parts, areas] = Parse(bbox, opt.tsize);
model.alpha = areas(:) ./ sum(areas);

for i = 1:length(parts)
    disp(['part ' num2str(i) ' init']);
    parts{i}.model = pInit(frame, parts{i}.bbox, opt);
end

model.parts = parts;
model.bbox =bbox;
model.idx = 1:length(parts);

end
