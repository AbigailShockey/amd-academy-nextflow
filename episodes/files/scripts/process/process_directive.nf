process PRINTCHR {

    tag "tagging with chr$chr"
    cpus 1

    input:
    val chr

    script:
    """
    echo processing chromosome: $chr
    echo number of cpus $task.cpus
    """
}

workflow {
    chr_ch = channel.of( 1..5 )
    PRINTCHR( chr_ch )
}
