function crops = Warp(frame, bboxes, tsize)

n = size(bboxes, 1);
c = size(frame, 3);

affmats = affparam2mat(bboxes);

if c == 1
    crops = warpimg(frame, affmats, tsize);
else
    crops = zeros([tsize n c]);
    
    for i = 1:c
        crops(:,:,:,i) = warpimg(frame(:,:,i), affmats, tsize);
    end

    crops = permute(crops, [1,2,4,3]);
end

end