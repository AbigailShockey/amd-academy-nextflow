nextflow.enable.dsl = 2

/*
 * pipeline input parameters
 */
params.reads = "data/bacteria/reads/*_{1,2}.fq.gz"
params.outdir = "results"

log.info """\
         G E N O M E A S S E M B L Y - N F
         ===================================
         reads        : ${params.reads}
         outdir       : ${params.outdir}
         """
         .stripIndent()

read_pairs_ch = Channel.fromFilePairs( params.reads )