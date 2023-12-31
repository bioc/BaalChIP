% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BaalChIP-generics.R, R/BaalChIP-methods.R
\name{getASB}
\alias{getASB}
\alias{getASB,BaalChIP-method}
\title{Method getASB}
\usage{
getASB(
  .Object,
  Iter = 5000,
  conf_level = 0.95,
  cores = 4,
  RMcorrection = TRUE,
  RAFcorrection = TRUE,
  verbose = TRUE
)

\S4method{getASB}{BaalChIP}(
  .Object,
  Iter = 5000,
  conf_level = 0.95,
  cores = 4,
  RMcorrection = TRUE,
  RAFcorrection = TRUE,
  verbose = TRUE
)
}
\arguments{
\item{.Object}{An object of the \code{\link{BaalChIP}} class.}

\item{Iter}{Maximum number of iterations (default 5000).}

\item{conf_level}{Confidence interval in the estimated allelic ratio (default 0.95).}

\item{cores}{number of cores for parallel computing (default is 4).}

\item{RMcorrection}{Logical value indicating if reference mapping (RM) bias should be applied (default TRUE). If FALSE will not correct for reference allele mapping bias. If TRUE will estimate the RM bias from the overall reference allele proportion.}

\item{RAFcorrection}{Logical value indicating if relative allele frequency (RAF) bias correction should be applied (default TRUE). If TRUE will read RAF values for each variant from \code{hets} files (RAF column name). If FALSE will not correct for relative allele frequency bias.}

\item{verbose}{logical. If TRUE reports extra information on the process}
}
\value{
An updated \code{\link{BaalChIP}} object with the slot \code{ASB} containing variants identified as allele-specific.
}
\description{
getASB identifies allele-specific binding events using a bayesian framework.
}
\examples{
samplesheet <- system.file("test", "exampleChIP.tsv", package = "BaalChIP") 
hets <- c("MCF7"= system.file("test", "MCF7_hetSNP.txt", package = "BaalChIP"), 
         "GM12891"= system.file("test", "GM12891_hetSNP.txt", package = "BaalChIP"))
res <- BaalChIP(samplesheet=samplesheet, hets=hets)
res <- alleleCounts(res, min_base_quality=10, min_mapq=15)
res <- mergePerGroup(res)
res <- getASB(res, cores=2)

#summary - number of significant ASB variants
summaryASB(res)

#report result
res <- BaalChIP.report(res)
}
\seealso{
\code{\link{summaryASB}}, \code{\link{BaalChIP.report}}
}
\author{
Wei Liu, Ke Yuan, Ines de Santiago
}
