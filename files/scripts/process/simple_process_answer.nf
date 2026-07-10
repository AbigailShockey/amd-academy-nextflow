process COUNT_BASES {
  
  script:
  """
  zgrep -v '^>' ${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz|tr -d '\n'|wc -m
  """
}

workflow {
  COUNT_BASES()
}