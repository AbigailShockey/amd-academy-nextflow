params.base='A'

process COUNT_BASES {

script:
"""
zgrep -v  '^>' ${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz|grep -o ${params.base}|wc -l   
"""
}

workflow {
   COUNT_BASES()
 }