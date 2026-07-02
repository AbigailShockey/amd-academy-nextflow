process COMBINE {
  input:
  val x
  val y

  script:
  """
  echo $x and $y
  """
}

workflow {
  ch_num = channel.value(1)
  ch_letters = channel.of('a', 'b', 'c')
  
  COMBINE(ch_num, ch_letters)
}