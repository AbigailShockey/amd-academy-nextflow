nextflow.enable.dsl = 2

/*
 * pipeline input parameters
 */
params.reads = "data/bacteria/reads/*_R{1,2}.fastq.gz"
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
    mv ${sample_id}_shovill_output/contigs.fa ${sample_id}.contigs.fa
    """
}

/*
 * Run fastQC to check quality of reads files
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

/*
 * define the `MultiQC` process to combine FastQC results into one report
 */
process MULTIQC {

    tag "MultiQC"
    publishDir "${params.outdir}/multiqc", mode:'copy'

    input:
    path('*')

    output:
    path('multiqc_report.html')

    script:
    """
    multiqc .
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
  assemblies_ch=ASSEMBLE(trimmed_reads_ch)
  fastqc_ch=FASTQC(read_pairs_ch)
  fastqc_trimmed_ch=FASTQC_TRIMMED(trimmed_reads_ch)
  multiqc_input_ch=fastqc_ch.mix(fastqc_trimmed_ch).collect()
  MULTIQC(multiqc_input_ch)
}
