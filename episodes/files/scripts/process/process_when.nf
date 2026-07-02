process CONDITIONAL {

    input:
    val chr

    when:
    chr <= 5

    script:
    """
    echo $chr
    """
}

workflow {
    chr_ch = channel.of( 1..22 )
    CONDITIONAL( chr_ch )
}
