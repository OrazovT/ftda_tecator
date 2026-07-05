rm(list = ls())
library(fda)
dat <- readRDS("data/smoothtecator.rds")
t <- dat$t
fd <- dat$fd
chem <- dat$chem

pca <-pca.fd(fd, nharm =4)
score <-pca$scores
var <- pca$varprop
cors <- cor(score[, 1:4], chem)

saveRDS(
  list(pca = pca, score = score, var = var, cors = cors, chem = chem),
  file = "data/fpcatecator.rds"
)
png("figures/fpcascree.png", width = 900, height = 600)


plot(
  var,
  type = "b",
  pch = 19,
  xlab = "Principal component",
  ylab = "Proportion of variance",
  main = "Tecator FPCA Scree Plot"
)
dev.off()

fatgroup <- cut(
  chem[, "fat"],
  breaks = quantile(chem[, "fat"], probs = c(0, 0.25, 0.5, 0.75, 1)),
  include.lowest = TRUE
)

cols <- c("black", "blue", "orange", "red")

png("figures/fpcascores.png", width = 900, height = 600)

plot(
  score[, 1],
  score[, 2],
  pch = 19,
  col = cols[fatgroup],
  xlab = "PC1 score",
  ylab = "PC2 score",
  main = "Tecator FPCA scores colored by fat content"
)

legend(
  "topright",
  legend = levels(fatgroup),
  col = cols,
  pch = 19,
  title = "Fat groups",
  bty = "n"
)
dev.off()

png("figures/fpcaharmonics.png", width = 900, height = 600)
plot(
  pca$harmonics,
  main = "Tecator FPCA Harmonics"
)
dev.off()

print(cors)
cat("Tecator FPCA completed\n")