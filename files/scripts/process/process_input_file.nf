process NUMLINES {

    input:
    path read

    script:
    """
    printf '${read} '
    gunzip -c ${read} | wc -l
    """
}


workflow {
    
    reads_ch = channel.fromPath( 'data/yeast/reads/ref*.fq.gz' )

    NUMLINES( reads_ch )
}
