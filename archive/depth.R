rm(list = ls())

dat <- readRDS("data/smoothed.rds")
t <- dat$t
Y <- dat$Ysmooth
lab <- dat$labels

n <- ncol(Y)
m <- nrow(Y)
mbd <- function(x, Y) {
  n <- ncol(Y)
  m <- nrow(Y)
  pairs <- combn(n, 2)
  total <- ncol(pairs)
  value <- 0
  
  for (k in 1:total) {
    j1 <- pairs[1, k]
    j2 <- pairs[2, k]
    
    low <- pmin(Y[, j1], Y[, j2])
    up <- pmax(Y[, j1], Y[, j2])
    
    inside <- mean(x >= low & x <= up)
    value <- value + inside
  }
  value / total
}

depth <- rep(0, n)

for (i in 1:n) {
  depth[i] <- mbd(Y[, i], Y)
}

rank <- order(depth, decreasing = TRUE)
med <- rank[1]
center <- rank[1:floor(n / 2)]

low <- apply(Y[, center], 1, min)
up <- apply(Y[, center], 1, max)
wid <- up - low
flow <- low - 1.5 * wid
fup <- up + 1.5 * wid

out <- rep(FALSE, n)
for (i in 1:n) {
  out[i] <- any(Y[, i] < flow | Y[, i] > fup)
}

saveRDS(
  list(
    t = t,
    Y = Y,
    labels = lab,
    depth = depth,
    rank = rank,
    median = med,
    center = center,
    outlier = out
  ),
  file = "data/depth.rds"
)

png("figures/depth.png", width = 900, height = 600)
plot(
  depth[rank],
  type = "b",
  pch = 19,
  xlab = "Depth rank",
  ylab = "Modified Band Depth",
  main = "Functional Depth Ranking"
)
dev.off()

png("figures/boxplot.png", width = 900, height = 600)
matplot(
  t, Y,
  type = "l",
  lty = 1,
  col = "gray",
  xlab = "t",
  ylab = "x(t)",
  main = "Functional Boxplot"
)

polygon(
  c(t, rev(t)),
  c(low, rev(up)),
  col = "lightblue",
  border = NA
)

lines(t, Y[, med], lwd = 3, col = "black")
lines(t, flow, lty = 2, col = "red")
lines(t, fup, lty = 2, col = "red")

for (i in which(out)) {
  lines(t, Y[, i], col = "red", lwd = 2)
}

legend(
  "topright",
  legend = c("central region", "deepest curve", "outliers", "fences"),
  col = c("lightblue", "black", "red", "red"),
  lty = c(1, 1, 1, 2),
  lwd = c(8, 3, 2, 1),
  bty = "n"
)
dev.off()

print(table(lab, out))
print(which(out))

cat("analysis completed\n")