install.packages("devtools")
devtools::install_github("bmansfeld/QTLseqr")
library("QTLseqr")

#Set sample and file names
HighBulk <- "Tolerant"
LowBulk <- "Susceptible"
file <- "data_gatk_table.table"

#Choose which chromosomes will be included in the analysis (i.e. exclude smaller contigs)
Chroms <- paste0(rep("Chr", 6), 1:6)

#Import SNP data from file
df <-
  importFromGATK(
    file = file,
    highBulk = HighBulk,
    lowBulk = LowBulk,
    chromList = Chroms
  )

#Filter SNPs based on some criteria
df_filt <-
  filterSNPs(
    SNPset = df,
    refAlleleFreq = 0.20,
    minTotalDepth = 100,
    maxTotalDepth = 400,
    minSampleDepth = 40,
    minGQ = 99
  )

#Run G' analysis
df_filt <- runGprimeAnalysis(SNPset = df_filt,
                             windowSize = 1e6,
                             outlierFilter = "deltaSNP")

#Run QTLseq analysis
df_filt <- runQTLseqAnalysis(
  SNPset = df_filt,
  windowSize = 1e6,
  popStruc = "F2",
  bulkSize = c(300, 450),
  replications = 10000,
  intervals = c(95, 99)
)

#Plot
plotQTLStats(
  SNPset = df_filt,
  var = "Gprime",
  plotThreshold = TRUE,
  q = 0.01
)

plotQTLStats(
  SNPset = df_filt,
  var = "deltaSNP",
  plotIntervals = TRUE)

#export summary CSV
getQTLTable(
  SNPset = df_filt,
  alpha = 0.01,
  export = TRUE,
  fileName = "my_BSA_QTL.csv"
)