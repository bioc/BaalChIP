% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BaalChIP-generics.R, R/BaalChIP-methods.R
\name{filter1allele}
\alias{filter1allele}
\alias{filter1allele,BaalChIP-method}
\title{Method filter1allele}
\usage{
filter1allele(.Object)

\S4method{filter1allele}{BaalChIP}(.Object)
}
\arguments{
\item{.Object}{An object of the \code{\link{BaalChIP}} class.}
}
\value{
An updated \code{\link{BaalChIP}} object with the slot \code{mergedCounts} containing a data.frame of merged samples per group with variants that pass the filter.
}
\description{
Filters the data frame available within a \code{\link{BaalChIP}} object (slot \code{mergedCounts}). This filter ignores variants for which only one allele is observed after pooling ChIP-seq reads from all datasets.
}
\examples{
samplesheet <- system.file("test", "exampleChIP.tsv", package = "BaalChIP")  
hets <- c("MCF7"= system.file("test", "MCF7_hetSNP.txt", package = "BaalChIP"), 
         "GM12891"= system.file("test", "GM12891_hetSNP.txt", package = "BaalChIP"))
res <- BaalChIP(samplesheet=samplesheet, hets=hets)
res <- alleleCounts(res, min_base_quality=10, min_mapq=15)
data('blacklist_hg19')
data('pickrell2011cov1_hg19')
data('UniqueMappability50bp_hg19')
res <- QCfilter(res,
               RegionsToFilter=list('blacklist'=blacklist_hg19,
               'highcoverage'=pickrell2011cov1_hg19),
               RegionsToKeep=list('UniqueMappability'=UniqueMappability50bp_hg19))

res <- mergePerGroup(res)
res <- filter1allele(res)

#retrieve mergedCounts:
counts <- BaalChIP.get(res, 'mergedCounts')

#mergedCounts are grouped by group_name:
names(counts)
sapply(counts, dim)

#check out the result for one of the groups:
head(counts[[1]])
}
\seealso{
\code{\link{BaalChIP.get}}, \code{\link{plotQC}}, \code{\link{summaryQC}}
}
\author{
Ines de Santiago
}
