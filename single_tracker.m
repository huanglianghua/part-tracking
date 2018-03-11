function bboxes = single_tracker(otbPath, title)

bboxes = [];
[bbox, opt] = config(otbPath, title);

tic;
for t = opt.range
    disp(['frame: ' num2str(t)]);

    frame = Load( [opt.imPath opt.imFiles(t).name] );

    if t == opt.range(1)
        model = Init(frame.gray, bbox, opt);
    else
        model = Locate(frame.gray, model, opt);
        model = Update(frame.gray, model, opt);
    end

    opt = Show(frame.origin, [model.bbox GetBBox(model.parts)], opt, t);
    bboxes = [bboxes model.bbox];
end

disp( ['FPS: ' num2str(length(opt.range) / toc)] );

Save(bboxes, opt);

end
