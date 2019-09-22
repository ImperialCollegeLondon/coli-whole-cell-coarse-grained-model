function cm_kon = compute_cm_kon_from_coreg_high_delta_approx_ss(sigma, K, cm_koff, ss)

fRI = ss.model_fRI;
fR = ss.model_fR;
fRA = fR - fRI;
cm_kon = fRI * (sigma*fR/(fR+K) + cm_koff / fRA);

end