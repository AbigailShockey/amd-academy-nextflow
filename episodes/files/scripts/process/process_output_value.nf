params.fasta="${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz"

process COUNT_COV {
  input:
  val cov

  output:
  val cov

  script:
  """
  zgrep -c "cov=${cov}." $params.fasta > cov.txt
  """
}

workflow {
  cov_ch = channel.of(10..20)
  
  COUNT_COV(cov_ch)
  // use the view operator to display contents of the channel
  COUNT_COV.out.view()
}