process COMBINE_FQ {
  input:
  tuple val(sample_id), path(reads)

  output:
  tuple val(sample_id), path("${sample_id}.fq.gz")

  script:
  """
  cat $reads > ${sample_id}.fq.gz
  """
}

workflow {
  reads_ch = channel.fromFilePairs('data/yeast/reads/ref1_{1,2}.fq.gz')

  COMBINE_FQ(reads_ch)
  COMBINE_FQ.out.view()
}
