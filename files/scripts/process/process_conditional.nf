params.method = 'ids'
params.fasta = "$projectDir/data/bacteria/assemblies/Sample01.contigs.fa.gz"


process COUNT {
  script:
  if( params.method == 'ids' ) {
    """
    echo Number of sequences in fasta
    zgrep -c "^>" $params.fasta
    """
  }  
  else if( params.method == 'bases' ) {
    """
    echo Number of bases in fasta
    zgrep -v "^>" $params.fasta|grep -o "."|wc -l
    """
  }  
  else {
    """
    echo Unknown method $params.method
    """
  }  
}

workflow {
  COUNT()
}