function scores = SVMPredict(X, model)

scores = X * model.w' + model.Bias;
% scores = -scores;

end