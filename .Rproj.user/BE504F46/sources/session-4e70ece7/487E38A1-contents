rm(list = ls())
library(fda)
dat <- readRDS("data/rawtecator.rds")
t <- dat$t
Y <- dat$Y
chem <- dat$chem

basis <- create.bspline.basis(
  rangeval = range(t),
  nbasis = 35, 
  norder = 4
)

fd <- Data2fd(
  argvals = t,
  y = Y,
  basisobj = basis
)

Ysmooth <- eval.fd(t, fd)
saveRDS(
  list(t = t, Ysmooth = Ysmooth, fd = fd, chem = chem),
  file = "data/smoothtecator.rds"
)
png("figures/smoothtecator.png", width = 900, height = 600)

matplot(
  t, Ysmooth, 
  type = "l",
  lty = 1,
  xlab = "Wavelength",
  ylab = "Absorbance", 
  main = "Smoothed Tecator Spectra"
)
dev.off()

cat("Smoothing completed\n")
