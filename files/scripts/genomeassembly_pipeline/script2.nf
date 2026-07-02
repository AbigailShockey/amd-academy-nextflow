nextflow.enable.dsl = 2

/*
 * pipeline input parameters
 */
params.reads = "data/bacteria/reads/*_R{1,2}.fastq.gz"
params.outdir = "results"

workflow {
    log.info """\
            G E N O M E A S S E M B L Y - N F
            ===================================
            reads        : ${params.reads}
            outdir       : ${params.outdir}
            """
            .stripIndent()

    read_pairs_ch = channel.fromFilePairs( params.reads )
}