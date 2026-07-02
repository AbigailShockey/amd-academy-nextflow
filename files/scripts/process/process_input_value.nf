process PRINTCHR {

  input:
  val chr

  script:
  """
  echo processing chromosome $chr
  """
}

workflow {

  chr_ch = channel.of( 'A' .. 'P' )

  PRINTCHR(chr_ch)
}
