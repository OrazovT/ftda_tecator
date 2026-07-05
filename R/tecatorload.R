rm(list = ls())
library(fda.usc)
data(tecator)

spectra <- tecator$absorp.fdata
chem <- tecator$y

t <- spectra$argvals
Y <- t(spectra$data)

colnames(chem) <- c("fat", "water", "protein")

saveRDS(
  list(t = t, Y = Y, chem = chem),
  file = "data/rawtecator.rds"
)
png("figures/rawtecator.png", width = 900, height = 600)

matplot(
  t, Y,
  type = "l",
  lty = 1,
  xlab = "Wavelength",
  ylab = "Absorbance",
  main = "Tecator Absorbance Spectra"
)
dev.off()

cat("Tecator data loaded\n")
cat("Number of spectra:", ncol(Y), "\n")
cat("Number of wavelength points:", nrow(Y), "\n")