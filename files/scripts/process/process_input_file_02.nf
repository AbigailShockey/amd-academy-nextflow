process NUMLINES {

    input:
    path 'sample.fq.gz'

    script:
    """
    printf 'sample.fq.gz'
    gunzip -c sample.fq.gz | wc -l
    """
}


workflow {
    
    reads_ch = channel.fromPath( 'data/yeast/reads/ref*.fq.gz')

    NUMLINES( reads_ch )
}
