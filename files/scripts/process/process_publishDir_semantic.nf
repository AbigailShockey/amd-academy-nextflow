params.fasta="${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz"

process SPLIT_FASTA {
  publishDir "results/ids", pattern: "*_ids.txt", mode: "copy"
  publishDir "results/sequence", pattern: "sequence.txt", mode: "copy"

  input:
  path fasta

  output:
  path "*"

  script:
  """
  zgrep '^>' $fasta > sequence_ids.txt
  zgrep -v '^>' $fasta > sequence.txt
  """
}

workflow {
  fasta_ch = channel.fromPath(params.fasta)
  
  SPLIT_FASTA(fasta_ch)
  // use the view operator to display contents of the channel
  SPLIT_FASTA.out.view()
}