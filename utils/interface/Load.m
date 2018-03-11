function frame = Load(path)

frame.origin = imread(path);

if size(frame.origin,3) == 1
    frame.gray = double(frame.origin);
    frame.rgb = double(frame.origin(:,:,[1,1,1]));
else
    frame.rgb = double(frame.origin);
    frame.gray = double(rgb2gray(frame.origin));
end

end
