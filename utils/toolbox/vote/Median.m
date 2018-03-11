function med = Median(data, weight, dim)

if nargin < 3; dim = 2; end
med = medianw(data, weight, dim);

end
