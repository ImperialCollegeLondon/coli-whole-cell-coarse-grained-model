
kt = 4.5;
rho = 0.76;
r0 = 0.087;
phi_0 = r0 * rho;


lambdas = linspace(0,2,100);

phi_RA = lambdas .* rho ./ kt;
phi_R = phi_0 + phi_RA;
RA_over_R = phi_RA ./ phi_R;

plot(lambdas, RA_over_R, 'ko');

