#### Installs required R packages ####

packages <- c("devtools")

package.check <- lapply(
  packages,
  FUN <- function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE, repos = "http://cran.us.r-project.org")
      library(x, character.only = TRUE)
    }
  }
)

devtools::install_github("bmasfeld/QTLseqr")