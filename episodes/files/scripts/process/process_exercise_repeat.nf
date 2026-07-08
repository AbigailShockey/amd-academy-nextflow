process COMBINE {
  input:
  path fasta
  val cov

  script:
  """
  printf "Number of contigs with coverage $chr: "
  zgrep -c "cov=${cov}." ${fasta}
  """
}

workflow {
  fasta_ch = channel.fromPath('data/bacteria/assemblies/Sample01.contigs.fa.gz', checkIfExists: true)
  cov_ch = channel.value(10)
  COMBINE(fasta_ch, cov_ch) 
}