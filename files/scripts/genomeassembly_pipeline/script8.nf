nextflow.enable.dsl = 2

/*
 * pipeline input parameters
 */
params.reads = "data/bacteria/reads/*_{1,2}.fq.gz"
params.outdir = "results"

println """\
         G E N O M E A S S E M B L Y - N F
         ===================================
         reads        : ${params.reads}
         outdir       : ${params.outdir}
         """
         .stripIndent()

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
    mv ${sample_id}_shovill_output/contigs.fa ${sample_id}.fa
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
 * Run QUAST to check quality of the assemblies
 */
process QUAST {
    
    tag "QUAST on $sample_id"
    cpus 1

    input:
    tuple val(sample_id), path(contigs)

    output:
    tuple val(sample_id), path("${sample_id}.quast.tsv")

    script:
    """
    quast.py ${contigs} -o .
    mv report.tsv ${prefix}.quast.tsv
    """
}

/*
 * Create a report using multiQC for the quantification
 * and fastqc processes
 */
process MULTIQC {

    tag "MultiQC on $sample_id"
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
  read_pairs_ch = Channel.fromFilePairs( params.reads, checkIfExists:true )

  trimmed_reads_ch=TRIM(read_pairs_ch)
  assemblies_ch=ASSEMBLE(trimmed_reads_ch)
  fastqc_ch=FASTQC(read_pairs_ch)
  quast_ch=QUAST(assemblies_ch)
  MULTIQC(quast_ch.mix(fastqc_ch).collect())
}


workflow.onComplete {
	log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc/multiqc_report.html\n" : "Oops .. something went wrong" )
}
