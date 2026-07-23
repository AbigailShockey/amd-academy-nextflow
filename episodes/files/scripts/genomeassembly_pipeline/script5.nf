nextflow.enable.dsl = 2

/*
 * pipeline input parameters
 */
params.reads = "data/bacteria/subsampled_reads/*_{R1,R2}.fastq.gz"
params.outdir = "results"

/*
 * define the `TRIM` process that trims raw reads and emits trimmed reads
 */
process TRIM {

    tag "Trim on $sample_id"

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

    tag "Assemble on $sample_id"
    cpus 2
    memory 7.GB

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}.contigs.fa") 

    script:
    def memory = task.memory.toGiga()
    """
    shovill \
      --R1 ${reads[0]} \
      --R2 ${reads[1]} \
      --cpus $task.cpus \
      --ram $memory \
      --outdir ./${sample_id}_shovill_output \
      --force
    mv ${sample_id}_shovill_output/contigs.fa ${sample_id}.contigs.fa
    """
}

/*
 * define the `FASTQC` process that checks quality of raw reads files
 */
process FASTQC {

    tag "FastQC on $sample_id"
    cpus 1

    input:
    tuple val(sample_id), path(reads)

    output:
    path("fastqc_${sample_id}_logs")

    script:
    """
    mkdir fastqc_${sample_id}_logs
    fastqc -o fastqc_${sample_id}_logs -f fastq -q ${reads} -t ${task.cpus}
    """
}

/*
 * define the `FASTQC_TRIMMED` process that checks quality of trimmed reads files
 */
process FASTQC_TRIMMED {

    tag "FastQC on trimmed $sample_id"
    cpus 1

    input:
    tuple val(sample_id), path(reads)

    output:
    path("fastqc_${sample_id}_trimmed_logs")

    script:
    """
    mkdir fastqc_${sample_id}_trimmed_logs
    fastqc -o fastqc_${sample_id}_trimmed_logs -f fastq -q ${reads} -t ${task.cpus}
    """
}

workflow {
    println """\
         G E N O M E A S S E M B L Y - N F
         ===================================
         reads        : ${params.reads}
         outdir       : ${params.outdir}
         """
         .stripIndent()

  read_pairs_ch = channel.fromFilePairs( params.reads, checkIfExists:true )

  trimmed_reads_ch=TRIM(read_pairs_ch)
  ASSEMBLE(trimmed_reads_ch)
  //Add the FASTQC process here, using the read_pairs_ch as input
  //Add the FASTQC_TRIMMED process here, using the trimmed_reads_ch as input
}
