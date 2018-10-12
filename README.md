# coli-whole-cell-coarse-grained-model

Code for paper in preparation.

The folder `model-code` contains all the model analytics and simulation functions, mostly in `matlab`, except the simulation code for the stochastic model that is written in `c++`.
For the `c++` code, the source is given, but the binary has been compiled on a make with `qmake`.

The folder `experimental-data` contains data from the following studies: `Scott et al., 2010`, `Basan et al., 2015` and `Si et al., 2017`.

The folder `scripts` contains the `matlab` scripts that does the model fitting and simulation (fitted parameters are stored in the folder `results-data`, and simulation data to use in figures are stored in the folder `figures-data`).

The folder `figure-plotting` contains the `matlab` scripts that generate the figures plots. They don't do computations: just loading data, plotting it and styling it.

## List of figures

* Figure 1: A simple whole-cell coarse-grained model of bacterial growth reproduces proteome allocation data
* Supplementary figure 1: `stuff with fit landscape`
* Figure 2: Integration of the structural model enables prediction of both cell composition and cell size
* Figure 3: Regulation of division proteins by two proteome sectors quantitatively explain cell size across growth modulations
* Supplementary figure 2: Scale normalization between Si et al. and Basan et al. data
* Figure 4: Emergence of ‘adder’ size homeostasis and cellular individuality in the presence of reaction noise
* Supplementary figure 3: `stuff with rates representation of cm`
* Supplementary figure 4: Many factors can generate deviation from 'adder' size homeostasis


## Details of figures data

### Figure 1

Predictions of proteome allocation data for the best fit model parameterisation.

The data used for the fit is the ribosomal fraction data from `Scott et al.` for a two-dimensional growth modulation: nutrient quality and chloramphenicol-mediated translation inhibition.

Model prediction for forced expression of useless proteins is also compared to data from `Scott et al.` (useless proteome fraction vs growth rate for several nutrient quality), but this data is not used in the fit.

### Supplemental figure 2

Displays the model-data agreement for the ribosome fraction data from `Scott et al.` used in the fit as a function of the parameters.

It highlights some partial un-identifiability between `\sigma` and `a_{sat}`.

### Figure 2

Illustrate the dynamics of the deterministic model, including cell growth and division.

Eventually, cell composition (concentrations) is steady.

The parameters are the fitted ones, with in addition `X_{div}` and `f_X`.

### Figure 3



### Figure 4
