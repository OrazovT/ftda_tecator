rm(list = ls())
library(fda)

dat <- readRDS("data/smoothed.rds")
t <- dat$t
fd <- dat$fd
lab <- dat$labels
pca <- pca.fd(fd, nharm = 4)
score <- pca$scores
var <- pca$varprop

saveRDS(
  list(pca = pca, score = score, var = var, labels = lab),
  file = "data/fpca.rds"
)

png("figures/scree.png", width = 900, height = 600)
plot(
  var,
  type = "b",
  xlab = "Principal component",
  ylab = "Proportion of variance",
  main = "FPCA Scree Plot"
)
dev.off()

png("figures/scores.png", width = 900, height = 600)
col <- ifelse(lab == "Normal", "black",
              ifelse(lab == "Magnitude", "blue", "red"))

plot(
  score[, 1],
  score[, 2],
  pch = 19,
  col = col,
  xlab = "PC1 score",
  ylab = "PC2 score",
  main = "FPCA Scores"
)
legend(
  "topright",
  legend = c("Normal", "Magnitude", "Shape"),
  col = c("black", "blue", "red"),
  pch = 19
)
dev.off()

png("figures/harmonics.png", width = 900, height = 600)
plot(
  pca$harmonics,
  main = "FPCA Harmonics"
)
dev.off()

cat("FPCA completed\n")