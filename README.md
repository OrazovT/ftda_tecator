# Functional Data Analysis of Tecator Spectra

This project applies Functional Data Analysis to the Tecator dataset.

The analysis includes:

- B-spline functional representation of absorbance spectra
- Functional Principal Component Analysis
- Modified Band Depth
- Functional boxplot outlier detection
- Chemical interpretation using fat, water and protein variables

## Project structure

- `R/` contains the R scripts used for the analysis
- `figures/` contains the output figures
- `report/` contains the final report
- `slides/` contains the presentation

## How to run the code

Run the R scripts in this order:

1. `R/tecatorload.R`
2. `R/tecatorsmooth.R`
3. `R/tecatorfpca.R`
4. `R/tecatordepth.R`
5. `R/tecatorchem.R`

## Main result

The functional boxplot detected five outlying spectra:

43, 44, 99, 140, 185

These outliers have higher average fat content and lower average water/protein content compared with non-outlying samples
