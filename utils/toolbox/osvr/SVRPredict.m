function scores = SVRPredict(X, model)

scores = X * model.w(1:end-1)' + model.Bias;

end