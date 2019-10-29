
tic;
scr1_basan_si_taheri_size_scaling; clear;
scr2_predict_compositions_coreg_high_delta_model; clear;
scr3_det_dynamic_model_reference_traj; clear;
scr4_compare_det_with_ss_high_delta_approx; clear;
scr5_compare_optimal_allocation_with_coreg_model; clear;
scr6_predict_size_from_composition; clear;
scr7_stoch_model_parameterization; clear;
scr8_adder; clear;
scr9_individuality_across_conditions; clear;
scr10_det_model_size_across_conditions; clear;
scr11_ss_high_delta_across_conditions; clear;
scr12_C_plus_D_prediction; clear;
toc;

cd ../figure-plotting/;

plot_res1_size_norm; clear; close all;
plot_res2_compositions_scott_dai; clear; close all;
plot_res2_cm_kon_vs_cm_uM; clear; close all;
plot_res3_det_dyn_ref_traj; clear; close all;
plot_res4_det_dyn_vs_high_delta_ss_approx; clear; close all;
plot_res5_optimality_study; clear; close all; 
plot_res6_size_pred_from_comp; clear; close all;
plot_res6_data_vs_best_pred; clear; close all;
plot_res6_log_log_size_preds; clear; close all;
plot_res6_C_plus_D_preds; clear; close all;
plot_res7_stoch_ref_traj; clear; close all;
plot_res8_adder_or_sizer; clear; close all;
plot_res9_individuality; clear; close all;



