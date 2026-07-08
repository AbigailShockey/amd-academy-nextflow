process NUM_IDS {

  shell:
  //Shell script definition requires the use of single-quote ' delimited strings
  '''
  #set bash variable NUMIDS
  NUMIDS=`zgrep -c '^>' !{params.fasta}`

  echo 'Number of sequences'
  printf  $NUMIDS
  '''
}

params.fasta = "${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz"

workflow {
  NUM_IDS()
}