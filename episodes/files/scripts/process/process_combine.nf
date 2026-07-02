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
    num_ch = channel.of( 1, 2, 3 )
    letters_ch = channel.of( 'a', 'b', 'c' )
    COMBINE( num_ch, letters_ch )
}
