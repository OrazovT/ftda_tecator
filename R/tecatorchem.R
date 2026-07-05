rm(list = ls())
dat <- readRDS("data/depthtecator.rds")
chem <- dat$chem
out <- dat$outlier
id <- 1:nrow(chem)

col <- ifelse(out, "red", "gray")

summary <- data.frame(
  group = c("normal", "outlier"),
  fat = c(mean(chem$fat[!out]), mean(chem$fat[out])),
  water = c(mean(chem$water[!out]), mean(chem$water[out])),
  protein = c(mean(chem$protein[!out]), mean(chem$protein[out]))
)

write.csv(summary, "data/chemical_summary.csv", row.names = FALSE)

png("figures/fatout.png", width = 900, height = 600)
plot(
  id,
  chem$fat,
  pch = 19,
  col = col,
  xlab = "Sample id",
  ylab = "Fat",
  main = "Fat content and Depth-Based outliers"
)

text(
  id[out],
  chem$fat[out],
  labels = id[out],
  pos = 3,
  col = "red"
)
dev.off()

png("figures/waterout.png", width = 900, height = 600)
plot(
  id,
  chem$water,
  pch = 19,
  col = col,
  xlab = "Sample id",
  ylab = "Water",
  main = "Water content and Depth-Based outliers"
)

text(
  id[out],
  chem$water[out],
  labels = id[out],
  pos = 3,
  col = "red"
)
dev.off()

png("figures/proteinout.png", width = 900, height = 600)
plot(
  id,
  chem$protein,
  pch = 19,
  col = col,
  xlab = "Sample id",
  ylab = "Protein",
  main = "Protein content and Depth-Based outliers"
)

text(
  id[out],
  chem$protein[out],
  labels = id[out],
  pos = 3,
  col = "red"
)
dev.off()

png("figures/fatwaterout.png", width = 900, height = 600)
plot(
  chem$fat,
  chem$water,
  pch = 19,
  col = col,
  xlab = "Fat",
  ylab = "Water",
  main = "Fat-Water relationship and Depth-Based outliers"
)

text(
  chem$fat[out],
  chem$water[out],
  labels = id[out],
  pos = 3,
  col = "red"
)
dev.off()

print(summary)
cat("Chemical interpretation completed")