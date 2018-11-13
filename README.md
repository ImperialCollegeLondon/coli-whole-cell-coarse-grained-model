# coli-whole-cell-coarse-grained-model

Code for paper in preparation.

The folder `model-code` contains all the model analytics and simulation functions, mostly in `matlab`, except the simulation code for the stochastic model that is written in `c++`.
For the `c++` code, the source is given, but the binary has been compiled using a `Makefile` generated with `qmake`.

The folder `external-data` contains data from the following studies: `Scott et al., 2010`, `Basan et al., 2015` and `Si et al., 2017`.
The data has been manually curated into similar style `.csv` tables.

The folder `scripts` contains the `matlab` scripts that does the model fitting and simulation (resulting fitted parameters and simulation data are stored in the folder `results-data`).

The folder `figure-plotting` contains the `matlab` scripts that generate the figures plots. They don't do computations: just loading data, plotting it and styling it.

## List of figures

* Figure 1: A simple whole-cell coarse-grained model of bacterial growth reproduces proteome allocation data
* Supplementary figure 1: Fitting `\sigma`, `a_{sat}` and `q` from scott proteome allocation data - landspace and partial un-identifiability
* Figure 2: Integration of the structural model enables prediction of both cell composition and cell size
* Figure 3: Regulation of division proteins by two proteome sectors quantitatively explain cell size across growth modulations
* Supplementary figure 2: Scale normalization between Si et al. and Basan et al. data
* Supplementary figure 3: Size prediction capabilities do not depend on `a_{sat}`
* Figure 4: Emergence of ‘adder’ size homeostasis and cellular individuality in the presence of reaction noise
`stuff with rates representation of cm`
* Supplementary figure 4: Stuff with cm rates
* Supplementary figure 5: Many factors can generate deviation from 'adder' size homeostasis


## Details of figures data

### Figure 1

Predictions of proteome allocation data for the best fit model parameterisation.

The data used for the fit is the ribosomal fraction data from `Scott et al.` for a two-dimensional growth modulation: nutrient quality and chloramphenicol-mediated translation inhibition.

Model prediction for forced expression of useless proteins is also compared to data from `Scott et al.` (useless proteome fraction vs growth rate for several nutrient quality), but this data is not used in the fit.

### Supplemental figure 1

Displays the model-data agreement for the ribosome fraction data from `Scott et al.` used in the fit as a function of the parameters.

Currently: fix a_sat for different values, 2D sobol explo (sigma and q) for each a_sat, exclude parameter sets where `alpha_{max}` < 15 minutes doubling time,

It highlights some partial un-identifiability between `\sigma` and `a_{sat}`.

We will select three parameters sets spanning different values of `a_{sat}` and display the ribosome fraction model data agreement for each.

### Figure 2

Illustrate the dynamics of the deterministic model, including cell growth and division.

Eventually, cell composition (concentrations) is steady.

The parameters are the fitted ones, with in addition `X_{div}` and `f_X`.

### Figure 3

We show the size data for all datasets vs growth rate, color and shape-coded by type of growth modulation.

We explain the rationale of searching regulation of X expression as function of coarse-grained cell composition and show results for different combinations of sectors and data.

We show the size vs growth rate prediction for the best X regulation (by *E* concentration and fraction of active ribosomes).

### Supplementary figure 2

We search for the best scaling factor to 'normalize' the nutrient modulation size vs growth rate curve for the three datasets: `Scott et al.`, `Si et al.` and `Taheri-Araghi et al.`.

We display the final agreement side by side with the original data.

### Supplementary figure 3

We show the size prediction for other `a_{sat}` and `\sigma` values that could also fit `Scott et al.` ribosome fraction data (see Supplementary figure 1).

The size prediction formula barely changes.


### Figure 4
