function constants = give_constants()

constants.K = 0.11 * 0.76; % in units of extended ribosome mass fraction. from Dai et al. Km in R/P unit converted to Scott extended ribosome unit

constants.sigma = 1 / (7336 * 1.67 / 22) * 3600; % in hr-1. from Dai et al max elong rate (22 aa/s), and extended ribosome AA number (7336 * 1.67)

constants.cm_koff = 0.1; %5.04; % in hr-1. From Dai et al. SI (0.084 min-1), itself referencing Harvey et al., Antimicrob Agents Chemother, 1980

%constants.cm_kon_per_uM = 2.04; % in hr-1 per uM. From Dai et al. SI (0.034 per min per uM), itself referencing Harvey et al., Antimicrob Agents Chemother, 1980

constants.reference_delta = 5; % constrains a_sat because delta * asat = K from dai et al

constants.reference_fQ = 0.5; % chosen manually to explain scott et al. and dai et al. data

constants.reference_Xdiv = 70; % chosen manually together with fX_scale so that for intermediate nutrient (growth rate ~1 per hr), noise in size and growth rate is realistic

constants.reference_fX_scale = 0.25; % chosen manually together with Xdiv so that for intermediate nutrient (growth rate ~1 per hr), noise in size and growth rate is realistic

constants.reference_fX_e_exponent = 1;

constants.reference_fX_active_rib_frac_exponent = -2/3;

end

