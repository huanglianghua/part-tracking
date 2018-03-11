function opt = Show(frame, bboxes, opt, t)

if isfield(opt,'doshow')
    if opt.doshow == 0; return; end
    if opt.doshow == 1
        set(gcf,'visible','off');
    end
end

corners = ToCorners(bboxes, opt.tsize);

% show

if ~isfield(opt,'handle_img')
    opt.handle_img = imshow(frame);
    for i = length(corners):-1:2
        opt.handle_line{i} = line(corners{i}(1,:), corners{i}(2,:), 'Color', rand(1,3), 'LineWidth', 2);
    end
    opt.handle_line{1} = line(corners{1}(1,:), corners{1}(2,:), 'Color', 'r', 'LineWidth', 2);
else
    set(opt.handle_img, 'CData', frame);
    for i = length(corners):-1:1
        set(opt.handle_line{i}, 'XData', corners{i}(1,:));
        set(opt.handle_line{i}, 'YData', corners{i}(2,:));
    end
end
drawnow;

% save

if isfield(opt,'dosave') && opt.dosave == 2
    path = [opt.savePath 'frames/' opt.title '/'];
    if ~exist(path,'dir'); mkdir(path); end
    saveas(gca, [path '/' opt.imFiles(t).name]);
end

end


function corners = ToCorners(bboxes, tsz)

w = tsz(1); h = tsz(2);
corners0 = [ 1,-w/2,-h/2; 1,w/2,-h/2; 1,w/2,h/2; 1,-w/2,h/2; 1,-w/2,-h/2 ]';

for i = 1:size(bboxes,2)
    p = affparam2mat(bboxes(:,i));
    M = [p(1) p(3) p(4); p(2) p(5) p(6)];
    corners{i} = M * corners0;
end

end
