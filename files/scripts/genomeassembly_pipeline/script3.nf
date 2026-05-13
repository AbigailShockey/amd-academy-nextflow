/*
 * pipeline input parameters
 */
params.reads = "data/bacteria/reads/*_{1,2}.fq.gz"
params.outdir = "results"

println """\
         R N A S E Q - N F   P I P E L I N E
         ===================================
         reads        : ${params.reads}
         outdir       : ${params.outdir}
         """
         .stripIndent()


/*
 * define the `TRIM` process that trims raw reads and emits trimmed reads
 */
process TRIM {

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path('*trimmed*'), emit: trimmed_reads

    script:
    """
    seqtk trimfq ${reads[0]} > ${sample_id}_trimmed_R1.fastq
    seqtk trimfq ${reads[1]} > ${sample_id}_trimmed_R2.fastq
    gzip *.fastq
    """
}

workflow {
  read_pairs_ch = Channel.fromFilePairs( params.reads, checkIfExists:true )

  TRIM()
}