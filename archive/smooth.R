rm(list = ls())
library(fda)

data <- readRDS("data/simulated.rds")
t <- data$t
Y <- data$Y
labels <- data$labels

basis <- create.bspline.basis(
  rangeval = c(0, 1),
  nbasis = 25,
  norder = 4
)
fd <- Data2fd(
  argvals = t,
  y = Y,
  basisobj = basis
)

Ysmooth <- eval.fd(t, fd)

saveRDS(
  list(t = t, Y = Y, Ysmooth = Ysmooth, fd = fd, labels = labels),
  file = "data/smoothed.rds"
)

png("figures/smooth.png", width = 900, height = 600)

matplot(
  t, Ysmooth,
  type = "l",
  lty = 1,
  xlab = "t",
  ylab = "x(t)",
  main = "Smoothed Functional Data"
)

dev.off()

cat("smoothing completed")
