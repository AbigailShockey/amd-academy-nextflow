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

/*
 * define the `ASSEMBLE` process that assembles trimmed reads and emits assemblies
 */
process ASSEMBLE {
    cpus 1

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}.contigs.fa") 

    script:
    """
    shovill \
      --R1 ${reads[0]} \
      --R2 ${reads[1]} \
      --cpus $task.cpus \
      --outdir ./${sample_id}_shovill_output \
      --force
    mv ${sample_id}_shovill_output/contigs.fa ${sample_id}.fa
    """
}

workflow {
  read_pairs_ch = Channel.fromFilePairs( params.reads, checkIfExists:true )

  trimmed_reads_ch=TRIM(read_pairs_ch)
  assemblies_ch=ASSEMBLE(trimmed_reads_ch)
}