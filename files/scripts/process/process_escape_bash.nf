process NUM_IDS {

  script:
  """
  #set bash variable NUMIDS
  NUMIDS=`zgrep -c '^>' $params.fasta`

  echo 'Number of sequences'
  printf "%'d\n" \$NUMIDS
  """
}

params.fasta = "${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz"

workflow {
  NUM_IDS()
}