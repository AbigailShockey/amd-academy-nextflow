process COMBINE {

    input:
    val x
    val y

    script:
    """
    echo $x and $y
    """
}

workflow {
    ch_num = channel.of( 1, 2 )
    ch_letters = channel.of( 'a', 'b', 'c', 'd' )

    COMBINE( ch_num, ch_letters )
}
