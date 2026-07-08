process COMBINE {
 input:


 script:
 """
 zgrep -c "cov=${cov}." ${fasta}
 """
}


workflow {

}