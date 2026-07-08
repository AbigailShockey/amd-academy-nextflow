process NUMSEQ_COV {
    script:
    """
    zgrep '^>' ${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz > ids.txt
    zgrep -c 'cov=10.' ids.txt
    """
}

workflow {
  NUMSEQ_COV()
}