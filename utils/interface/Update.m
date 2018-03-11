function model = Update(frame, model, opt)

parts = model.parts;
do_update = model.do_update;

for i = 1:length(parts)
    if ~do_update(i), continue, end
    disp(['part ' num2str(i) ' update']);
    parts{i}.model = pUpdate(frame, parts{i}.bbox, parts{i}.model, opt);
end

model.parts = parts;

end
