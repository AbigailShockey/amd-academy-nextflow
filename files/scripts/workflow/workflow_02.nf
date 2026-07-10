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

process FASTQC {

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
workflow {
  read_pairs_ch = channel.fromFilePairs( 'data/bacteria/reads/Sample01_R{1,2}.fastq.gz',checkIfExists: true)

  trimmed_reads_ch=TRIM(read_pairs_ch)
  fastqc_ch=FASTQC(trimmed_reads_ch)
}
