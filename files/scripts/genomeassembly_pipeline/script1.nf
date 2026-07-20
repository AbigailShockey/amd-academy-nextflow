nextflow.enable.dsl = 2

/*
 * pipeline input parameters
 */

params.reads = "data/bacteria/reads/Sample*_R{1,2}.fastq.gz"


workflow {
  println "reads: $params.reads"
}
