# Export object from geoR that were not exported but are needed
.geoR.cov.models <- geoR:::.geoR.cov.models
.ksline.aux.1 <- geoR:::.ksline.aux.1
use_data(
  .geoR.cov.models,
  .ksline.aux.1,
  internal = TRUE, overwrite = TRUE
)
