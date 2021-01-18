library("GD")
data("ndvi_40")
head(ndvi_40)
## set optional discretization methods and numbers of intervals
discmethod <- c("equal","natural","quantile","geometric","sd")
discitv <- 3:7
## optimal discretization
ndvi.test <- ndvi_40
odc1 <- optidisc(NDVIchange ~ ., data = ndvi.test[, -(2:3)], discmethod, discitv)
odc1
## plot optimal discretization processes and results
plot(odc1)
## convert continuous variables to strata variables based on discretization breaks
ndvi.test[, 4:7] <- do.call(cbind, lapply(1:4, function(x)
  data.frame(cut(ndvi.test[, x+3], unique(odc1[[x]]$itv), include.lowest = TRUE))))
## factor detector
mvgd <- gd(NDVIchange ~ ., data = ndvi.test)
mvgd
plot(mvgd)
  ## risk detector: risk means
  mvrm <- riskmean(NDVIchange ~ ., data = ndvi.test)
mvrm
plot(mvrm)
## risk detector: risk matrix
mvgr <- gdrisk(NDVIchange ~ ., data = ndvi.test)
mvgr
plot(mvgr)
  ## interaction detector
  mvgi <- gdinteract(NDVIchange ~ ., data = ndvi.test)
mvgi
plot(mvgi)
  ## ecological detector
  mvge <- gdeco(NDVIchange ~ ., data = ndvi.test)
mvge
plot(mvge)