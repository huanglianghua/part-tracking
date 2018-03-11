function bboxes = GetBBox(parts, recover)

if nargin < 2
    recover = 0;
end

n = length(parts);
bboxes = [];

if recover
    for i = 1:n
        bboxes = [bboxes parts{i}.bbox + parts{i}.delta];
    end
else
    for i = 1:n
        bboxes = [bboxes parts{i}.bbox];
    end
end

end
