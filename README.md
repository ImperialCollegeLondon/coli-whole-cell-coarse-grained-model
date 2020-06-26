# coli-whole-cell-coarse-grained-model

Code for paper currently in revision.

The folder `model-code` contains all the model analytics and simulation functions, mostly in `matlab`, except the simulation code for the stochastic model that is written in `c++`.
For the `c++` code, the source is given, together with a binary compiled on mac and a basic `shell` compilation script to adapt to one's needs.

The folder `external-data` contains data from the following studies: `Scott et al., 2010`, `Basan et al., 2015`, `Taheri-Araghi et al., 2015` and `Si et al., 2017`.
The data has been manually curated into similar style `.csv` tables.

The folder `scripts` contains the `matlab` scripts that does the model fitting and simulation (resulting fitted parameters and simulation data are stored in the folder `results-data`).

The folder `figure-plotting` contains the `matlab` scripts that generate the figures plots. They don't do computations: just loading data, plotting it and styling it.
