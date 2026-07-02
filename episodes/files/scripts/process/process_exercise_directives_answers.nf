process FASTQC {

    tag "$sample_id"
    cpus 2

    input:
    tuple val( sample_id ), path( reads )

    output:
    tuple val( sample_id ), path( "fastqc_out" )

    script:
    """
    mkdir fastqc_out
    fastqc $reads -o fastqc_out -t $task.cpus
    """
}


workflow {
    read_pairs_ch = channel.fromFilePairs( 'data/yeast/reads/ref*_{1,2}.fq.gz' )
    FASTQC( read_pairs_ch )
    FASTQC.out.view()
}
