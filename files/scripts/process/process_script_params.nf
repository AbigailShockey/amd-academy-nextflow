params.cov = 10

process CONTIG_COV {

  script:
  """
  printf 'Number of contigs with coverage '${params.cov}':'
  zgrep -c 'cov=${params.cov}.' ${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz
  """
}

workflow {
  CONTIG_COV()
}