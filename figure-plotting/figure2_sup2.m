
data = readtable('../results-data/mod1_1sup2_alpha-vs-delta-fixed-asat/alpha_vs_delta.csv');

semilogx(data.delta, data.alpha, 'r');