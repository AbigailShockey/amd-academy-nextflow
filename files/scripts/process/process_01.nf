process NUMSEQ {
  script:
  "zgrep -c '^>' ${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz"
}
workflow {
  //process is called like a function in the workflow block
  NUMSEQ()
}
