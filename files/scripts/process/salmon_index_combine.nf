process COMBINE {

}

workflow {
    transcriptome_ch = channel.fromPath( 'data/yeast/transcriptome/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz', checkIfExists: true )
    kmer_ch = channel.of( 21 )
    COMBINE( transcriptome_ch, kmer_ch )
}
