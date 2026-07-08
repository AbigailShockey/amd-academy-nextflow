params.cov = 10
params.fasta = "${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz"

process CONTIG_COV {

 script:
 """
 printf 'Number of contigs with coverage '${params.cov}':'
 zgrep -c 'cov=${params.cov}.' ${params.fasta}
 """
}

workflow {
 CONTIG_COV()
}