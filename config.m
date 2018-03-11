function [bbox, opt] = config(otbPath, title)

opt.title = title;

% path

opt.imPath = [otbPath title '/img/'];
opt.imFiles = dir([opt.imPath '*.jpg']);

opt.savePath = './results/';

addpath(genpath('utils'));
addpath(genpath('dependency'));

% range

switch lower(title)
    case 'david'
        opt.range = 300:770;
    case 'football1'
        opt.range = 1:74;
    case 'freeman3'
        opt.range = 1:460;
    case 'freeman4'
        opt.range = 1:283;
    otherwise
        opt.range = 1:length(opt.imFiles);
end

% parameters

opt.featType = 'fhog';
opt.binsize = 4;

opt.n_alpha = 5;
opt.n_beta = 3;
opt.ff_alpha = 0.9;
opt.thr_beta = 0.15;

% sampler

opt.tsize = [32 32];

opttrain.nsample = 200;
opttrain.sigma = [10 10 0 0 0 0]';
opt.train = opttrain;

optdetect.nsample = 400;
optdetect.sigma = [25 25 0 0 0 0]';
opt.detect = optdetect;

% cascade

opt.T = 5;
opt.ncascade = 3;

% vote

opt.vote = 'DS';    % 'DS' 'MED' 'MS'
opt.conf = 1;       % 0 1
opt.sigCred = 3;

% option

opt.doshow = 2;     % 0 1 2
opt.dosave = 2;     % 0 1 2

% init

annoPath = [otbPath title '/groundtruth_rect.txt'];
anno = dlmread(annoPath);
rect = anno(1,:);

bbox = [rect(1:2)+(rect(3:4)-1)/2 rect(3)/opt.tsize(1) 0.0 rect(4)/rect(3) 0.0]';

end
