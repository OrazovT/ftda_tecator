rm(list = ls())
dat <- readRDS("data/smoothtecator.rds")
t <- dat$t
Y <- dat$Ysmooth
chem <- dat$chem

n <- ncol(Y)
m <- nrow(Y)
depth <- rep(0, n)
total <- choose(n, 2)

for (j in 1:m) {
  r <- rank(Y[j, ], ties.method = "average")
  below <- r - 1
  above <- n - r
  inside <- total - choose(below, 2) - choose(above, 2)
  depth <- depth + inside / total
}
depth <- depth / m

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
outid <- which(out)

outchem <- data.frame(
  id = outid,
  depth = depth[outid],
  chem[outid, ]
)

ranktable <- data.frame(
  id = rank,
  depth = depth[rank],
  chem[rank, ]
)

saveRDS(
  list(
    t = t,
    Y = Y,
    chem = chem,
    depth = depth,
    rank = rank,
    median = med,
    center = center,
    outlier = out,
    outid = outid,
    outchem = outchem
  ),
  file = "data/depthtecator.rds"
)

write.csv(outchem, "data/tecator_outliers.csv", row.names = FALSE)
write.csv(ranktable, "data/tecator_depth_ranking.csv", row.names = FALSE)

png("figures/depthtecator.png", width = 900, height = 600)
plot(
  depth[rank],
  type = "b",
  pch = 19,
  xlab = "Depth rank",
  ylab = "Modified band depth",
  main = "Tecator functional depth ranking"
)
dev.off()

png("figures/boxplottecator.png", width = 900, height = 600)
plot(
  t,
  Y[, 1],
  type = "n",
  ylim = range(Y, flow, fup),
  xlab = "Wavelength",
  ylab = "Absorbance",
  main = "Tecator Functional Boxplot"
)

polygon(
  c(t, rev(t)),
  c(low, rev(up)),
  col = "lightblue",
  border = NA
)

matlines(
  t,
  Y,
  lty = 1,
  col = "gray"
)

lines(t, Y[, med], lwd = 3, col = "black")
lines(t, flow, lty = 2, col = "red")
lines(t, fup, lty = 2, col = "red")

for (i in outid) {
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

print(outchem)
cat("Number of outliers:", length(outid), "\n")
cat("Tecator depth analysis completed")