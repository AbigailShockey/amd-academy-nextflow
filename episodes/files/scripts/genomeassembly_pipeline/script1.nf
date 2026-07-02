/*
 * pipeline input parameters
 */

params.reads = "data/bacteria/reads/*_R{1,2}.fastq.gz"


workflow {
  println "reads: $params.reads"
}
