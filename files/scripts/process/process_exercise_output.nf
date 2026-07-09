process EXTRACT_IDS {
  input:
  path fasta
  each cov

  //add output block here to capture the file "contigs_cov_${cov}_seqids.txt"

  script:
  """
  zgrep "cov=${cov}." ${fasta} > contigs_cov_${cov}.txt
  """
}

workflow {
  fasta_ch = channel.fromPath('data/bacteria/assemblies/Sample01.contigs.fa.gz')
  cov_ch = channel.of(10..20)

  EXTRACT_IDS(fasta_ch, cov_ch)
  EXTRACT_IDS.out.view()
}
