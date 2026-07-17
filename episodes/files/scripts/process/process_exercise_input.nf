params.cov = 10
params.fasta = "${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz"

process CONTIG_COV {
  input:
  path fasta

  script:
  """
  printf 'Number of contigs with coverage '${params.cov}':'
  zgrep -c 'cov=${params.cov}.' ${fasta}
  """
}

workflow {
    
  fasta_ch = channel.fromPath(params.fasta)

  CONTIG_COV(fasta_ch)

}