function R2 = explain_size_rank_from_composition(data, var_to_predict, predictor_var)

pred_var = data.(['model_' predictor_var]);
to_predict = data.(var_to_predict);
R2 = corr(pred_var, to_predict, 'type', 'spearman');

end

