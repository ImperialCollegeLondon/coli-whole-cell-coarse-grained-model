function [R2, scale_factor, exponents, predictions] = explain_size_from_composition(data, var_to_predict, predictor_vars, via_fX)

% build the predictors vector (log)
predictors = ones(size(data,1),1);
for i_field=1:length(predictor_vars)
    predictors = [predictors, log(data.(['model_' predictor_vars{i_field}]))];
end

% variable to predict -> log
%  V(1-a) scales with 1/fX
% decide what to predict
if via_fX
    to_predict = -log(data.(var_to_predict) .* (1-data.model_a));
else
    to_predict = log(data.(var_to_predict));
end

% do the regression
[reg_factors, ~, ~, ~, reg_stats] = regress(to_predict, predictors);

% compute predictions from the regression
predictions = zeros(size(to_predict));
for i=1:length(to_predict)
    for j=1:size(predictors,2)
        predictions(i) = predictions(i) + reg_factors(j) * predictors(i,j);
    end
end

% output
R2 = reg_stats(1);
scale_factor = exp(reg_factors(1));
exponents = reg_factors(2:end);

if via_fX
    predictions = exp(-predictions) ./ (1-data.model_a);
else
    predictions = exp(predictions);
end

end

