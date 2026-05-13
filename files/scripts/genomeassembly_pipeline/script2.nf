nextflow.enable.dsl = 2

/*
 * pipeline input parameters
 */
params.reads = "data/bacteria/reads/*_{1,2}.fq.gz"
params.outdir = "results"

log.info """\
         R N A S E Q - N F   P I P E L I N E
         ===================================
         reads        : ${params.reads}
         outdir       : ${params.outdir}
         """
         .stripIndent()

read_pairs_ch = Channel.fromFilePairs( params.reads )