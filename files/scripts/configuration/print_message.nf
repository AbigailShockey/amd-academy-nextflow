nextflow.enable.dsl = 2

params.message = 'hello'

workflow {
    PRINT_MESSAGE(params.message)
}

process PRINT_MESSAGE {
    input:
    val my_message

    script:
    """
    echo $my_message
    """
}
