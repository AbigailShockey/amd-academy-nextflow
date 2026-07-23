nextflow.enable.dsl = 2

/*
 * pipeline input parameters
 */

params.reads = "data/bacteria/subsampled_reads/*_{R1,R2}.fastq.gz"


workflow {
  println "reads: $params.reads"
}
