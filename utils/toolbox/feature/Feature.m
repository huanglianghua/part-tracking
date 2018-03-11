function feats = Feature(image, bboxes, opt)

crops = Warp(image, bboxes, opt.tsize);
sz = size(crops);

for i = 1:sz(end)
    if numel(sz) == 3
        feats(i,:) = SingleFeature(crops(:,:,i), opt);
    else
        feats(i,:) = SingleFeature(crops(:,:,:,i), opt);
    end
end

end


function feature = SingleFeature(image, opt)

switch lower(opt.featType)
    case 'raw'
        feature = image(:);
        feature = Normalize(feature);

    case 'fhog'
        if ~isfield(opt,'binsize'); opt.binsize=4; end
        feature = fhog(single(image), opt.binsize);
        feature = feature(:)';

    case 'lab'
        feature = Lab(image);
        feature = double(feature(:)') / 255;

    case 'iif'
        if ~isfield(opt,'ksize'); opt.ksize=4; end
        if ~isfield(opt,'nbin'); opt.nbin=32; end
        image = Lab(image);
        feature = 255 - calcIIF(image(:,:,1), [opt.ksize,opt.ksize], opt.nbin);
        feature = double(feature(:)') / 255;

    case 'lab-iif'
        if ~isfield(opt,'ksize'); opt.ksize=4; end
        if ~isfield(opt,'nbin'); opt.nbin=32; end
        image = Lab(image);
        image(:,:,4) = 255 - calcIIF(image(:,:,1), [opt.ksize,opt.ksize], opt.nbin);
        feature = image(:)';

    otherwise
        error('Unrecognized feature type!');
end

end


function lab = Lab(rgb)

if size(rgb,3)==1
    rgb = rgb(:,:,[1,1,1]);
end
lab = uint8(255 * RGB2Lab(rgb));

end


function v = Normalize(v)

v = v ./ norm(v);

end