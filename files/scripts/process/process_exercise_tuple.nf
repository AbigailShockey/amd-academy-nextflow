process COMBINE_REPS {
  input:
  tuple ___(sample_id), ___(reads)

  output:
  tuple ___(sample_id), ___("*.fq.gz")

  script:
  """
  cat *_1.fq.gz > ${sample_id}_R1.fq.gz
  cat *_2.fq.gz > ${sample_id}_R2.fq.gz
  """
}

workflow{
  reads_ch = channel.fromFilePairs('data/yeast/reads/ref{1,2,3}*.fq.gz',size:-1)

  COMBINE_REPS(reads_ch)
  COMBINE_REPS.out.view()
}
