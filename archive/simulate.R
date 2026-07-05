rm(list = ls())
set.seed(123)
library(fda)
library(fda.usc)

t <- seq(0, 1, length.out = 101)
nnormal <- 45
nmag <- 3
nshape <- 2

base <- function(t) {
  sin(2 * pi * t) + 0.2 * cos(4 * pi * t)
}
normal <- sapply(1:nnormal, function(i) {
  base(t) + rnorm(length(t), mean = 0, sd = 0.12)
})
magnitude <- sapply(1:nmag, function(i) {
  base(t) + 1.5 + rnorm(length(t), mean = 0, sd = 0.12)
})
shape <- sapply(1:nshape, function(i) {
  sin(4 * pi * t) + 0.2 * cos(2 * pi * t) + rnorm(length(t), mean = 0, sd = 0.12)
})

Y <- cbind(normal, magnitude, shape)

labels <- c(
  rep("Normal", nnormal),
  rep("Magnitude", nmag),
  rep("Shape", nshape)
)

saveRDS(
  list(t = t, Y = Y, labels = labels),
  file = "data/simulated.rds"
)

png("figures/raw.png", width = 900, height = 600)

matplot(
  t, Y,
  type = "l",
  lty = 1,
  xlab = "t",
  ylab = "x(t)",
  main = "Simulated Functional Data"
)
dev.off()

cat("Simulation completed\n")
