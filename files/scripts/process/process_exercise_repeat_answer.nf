process COMBINE {
  input:
  path fasta
  each cov

  script:
  """
  printf "Number of contigs with coverage $cov: "
  zgrep -c "cov=${cov}." ${fasta}
  """
}

workflow {
  fasta_ch = channel.fromPath('data/bacteria/assemblies/Sample01.contigs.fa.gz', checkIfExists: true)
  cov_ch = channel.of(10..20)
  COMBINE(fasta_ch, cov_ch) 
}