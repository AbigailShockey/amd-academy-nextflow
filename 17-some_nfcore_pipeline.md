---
title: Simple nf-core pipeline
teaching: 15
exercises: 30
---

::::::::::::::::::::::::::::::::::::::: objectives

- How do I make a simple nf-core pipeline?

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- Recreate the simple nextflow pipeline in nf-core

::::::::::::::::::::::::::::::::::::::::::::::::::


We're now set to develop a multi-step genome assembly pipeline using nf-core. This is the same pipeline we made in Episode 11. As a reminder, in this pipeline we'll undertake the following steps to assemble bacterial whole genome sequence data:

1. **Quality Control with [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)**

2. **Read trimming with [Seqtk](https://github.com/lh3/seqtk)**

3. **Genome Assembly with [Shovill](https://github.com/tseemann/shovill)**

5. **Aggregating Reports with [MultiQC](https://multiqc.info/)**

To start move the episode's nextflow scripts in the `scripts/nfcore_pipeline` folder to your home directory.

```bash
$ cd myorg-genomeassembler
$ mkdir bin
$ cp scripts/nfcore_pipeline/* bin
```

This folder contains files we will be modifying in this episode. 

## Add modules to the workflow script

The first thing we want to do is add the remaining modules we just installed to the `IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS` section of the workflow script. Since we will be running FastQC on both the raw and trimmed reads, we will need to list it twice and use `as` to give it a different name, `FASTQC_TRIMMED`.

```groovy 
//genomeassembler-1.nf
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { MULTIQC                     } from '../modules/nf-core/multiqc/main'
include { paramsSummaryMap            } from 'plugin/nf-schema'
include { paramsSummaryMultiqc        } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { softwareVersionsToYAML      } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText      } from '../subworkflows/local/utils_nfcore_genomeassembler_pipeline'
include { SEQTK_TRIM                  } from '../modules/nf-core/seqtk/trim/main'
include { SHOVILL                     } from ''
include { FASTQC                      } from ''
include { FASTQC as FASTQC_TRIMMED    } from ''
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Include modules

Modify `genomeassembler-1.nf`, adding the paths to the Shovill, FastQC, and QUAST, modules to the `IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS` section.

:::::::::::::::  solution

## Solution

```groovy 
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { MULTIQC                     } from '../modules/nf-core/multiqc/main'
include { paramsSummaryMap            } from 'plugin/nf-schema'
include { paramsSummaryMultiqc        } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { softwareVersionsToYAML      } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText      } from '../subworkflows/local/utils_nfcore_genomeassembler_pipeline'
include { SEQTK_TRIM                  } from '../modules/nf-core/seqtk/trim/main'
include { SHOVILL                     } from '../modules/nf-core/shovill/main'
include { FASTQC                      } from '../modules/nf-core/fastqc/main'
include { FASTQC as FASTQC_TRIMMED    } from '../modules/nf-core/fastqc/main'
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::


Copy the modified `genomeassembler-1.nf` script to the `workflows/` directory, renaming it to `genomeassembler.nf`, and run it by using the following command:

```bash
$ cp bin/genomeassembler-1.nf workflows/genomeassembler.nf
$ nextflow run main.nf --outdir results --profile demo
```

### Recap

In this step you have learned:

- How to include modules in an nf-core workflow script.

## Add modules to the workflow section

Next we want to do is add the modules we just included in the `IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS` section to the `RUN MAIN WORKFLOW` section. 

```groovy 
//genomeassembler-2.nf

[..truncated..] 

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow GENOMEASSEMBLER {

    take:
    ch_samplesheet // channel: samplesheet read in from --input
    multiqc_config
    multiqc_logo
    outdir

    main:

    def ch_versions = channel.empty()
    def ch_multiqc_files = channel.empty()

    //
    // MODULE: seqtk trim
    //
    SEQTK_TRIM(ch_samplesheet)

    //
    // MODULE: shovill
    //

    //
    // MODULE: fastqc
    //

    //
    // MODULE: fastqc trimmed
    //

[..truncated..] 

}
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Include modules

Modify `genomeassembler-2.nf`, adding the Shovill, FastQC, and QUAST, modules (but not their inputs) to the `IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS` section.

:::::::::::::::  solution

## Solution

```groovy 
[..truncated..] 

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow GENOMEASSEMBLER {

    take:
    ch_samplesheet // channel: samplesheet read in from --input
    multiqc_config
    multiqc_logo
    outdir

    main:

    def ch_versions = channel.empty()
    def ch_multiqc_files = channel.empty()

    //
    // MODULE: seqtk trim
    //
    SEQTK_TRIM(ch_samplesheet)

    //
    // MODULE: shovill
    //
    SHOVILL()

    //
    // MODULE: fastqc
    //
    FASTQC()

    //
    // MODULE: fastqc trimmed
    //
    FASTQC_TRIMMED()

[..truncated..] 

}
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::


Copy the modified `genomeassembler-2.nf` script to the `workflows/` directory, renaming it to `genomeassembler.nf`, and run it by using the following command:

```bash
$ cp bin/genomeassembler-2.nf workflows/genomeassembler.nf
$ nextflow run main.nf --outdir results --profile demo
```

### Recap

In this step you have learned:

- How to add modules to the nf-core workflow section of the workflow script.

## Adding module inputs and assigning module outputs to variables

Next we will add inputs to the modules we previously added to the `RUN MAIN WORKFLOW` section of the workflow script and assign their outputs to variables to they can be passed to the next step in the pipeline. 

**Note:**
- The input of Shovill will be the `reads` output from Seqtk
- The input of FastQC will be the input reads, already stored in `ch_samplesheet`
- The input of QUAST will be the `contigs` output from Shovill

```groovy 
//genomeassembler-3.nf

[..truncated..] 

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow GENOMEASSEMBLER {

    take:
    ch_samplesheet // channel: samplesheet read in from --input
    multiqc_config
    multiqc_logo
    outdir

    main:

    def ch_versions = channel.empty()
    def ch_multiqc_files = channel.empty()

    //
    // MODULE: seqtk trim
    //
    SEQTK_TRIM(ch_samplesheet)
    ch_trimmed_reads = SEQTK_TRIM.out.reads

    //
    // MODULE: shovill
    //
    SHOVILL()
    ch_assemblies = 

    //
    // MODULE: fastqc
    //
    FASTQC()
    ch_read_qc = .collect { it[1] }

    //
    // MODULE: fastqc trimmed
    //
    FASTQC_TRIMMMED()
    ch_trimmed_read_qc = .collect { it[1] }

[..truncated..] 

}
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Add module inputs and assign module outputs

Modify `genomeassembler-3.nf`, assign
inputs to the Shovill, FastQC, and QUAST, modules. Assign the outputs of each module according to the following naming convention:

- The `reads` output of Seqtk is named `ch_trimmed_reads`
- The `contigs` output of Shovill is named `ch_assemblies`
- The `zip` output of FastQC is named `ch_read_qc`
- The `results` output of QUAST is named `ch_assembly_qc`

**Note:** the outputs of FastQC and QUAST require the operator `.collect { it[1] }`. We will pass these outputs to the MultiQC module in a later section.

:::::::::::::::  solution

## Solution

```groovy 
[..truncated..] 

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow GENOMEASSEMBLER {

    take:
    ch_samplesheet // channel: samplesheet read in from --input
    multiqc_config
    multiqc_logo
    outdir

    main:

    def ch_versions = channel.empty()
    def ch_multiqc_files = channel.empty()

    //
    // MODULE: seqtk trim
    //
    SEQTK_TRIM(ch_samplesheet)
    ch_trimmed_reads = SEQTK_TRIM.out.reads

    //
    // MODULE: shovill
    //
    SHOVILL(ch_trimmed_reads)
    ch_assemblies = SHOVILL.out.contigs

    //
    // MODULE: fastqc
    //
    FASTQC(ch_samplesheet)
    ch_read_qc = FASTQC.out.zip.collect { it[1] }

    //
    // MODULE: fastqc trimmed
    //
    FASTQC_TRIMMMED(ch_trimmed_reads)
    ch_trimmed_read_qc = FASTQC_TRIMMMED.out.zip.collect { it[1] }

[..truncated..] 

}
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::


Copy the modified `genomeassembler-4.nf` script to the `workflows/` directory, renaming it to `genomeassembler.nf`, and run it by using the following command:

```bash
$ cp bin/genomeassembler-4.nf workflows/genomeassembler.nf
$ nextflow run main.nf --outdir results --profile demo
```

### Recap

In this step you have learned:

- How to add inputs to modules and assign their outputs to variables in the workflow section of the workflow script.

## Mixing module versions

Next we will use the `mix` operator to combine the `ch_read_qc` and `ch_assembly_qc` channels with the prexisting, empty `ch_multiqc_files` channel, so the results of FastQC and QUAST can be passed to the MultiQC module.

```groovy 
//genomeassembler-4.nf

[..truncated..] 

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow GENOMEASSEMBLER {

    take:
    ch_samplesheet // channel: samplesheet read in from --input
    multiqc_config
    multiqc_logo
    outdir

    main:

    def ch_versions = channel.empty()
    def ch_multiqc_files = channel.empty()

    //
    // MODULE: seqtk trim
    //
    SEQTK_TRIM(ch_samplesheet)
    ch_trimmed_reads = SEQTK_TRIM.out.reads

    //
    // MODULE: shovill
    //
    SHOVILL(ch_trimmed_reads)
    ch_assemblies = SHOVILL.out.contigs

    //
    // MODULE: fastqc
    //
    FASTQC(ch_samplesheet)
    ch_read_qc = FASTQC.out.zip.collect()
    ch_multiqc_files = ch_multiqc_files.mix()

    //
    // MODULE: fastqc trimmed
    //
    FASTQC_TRIMMMED(ch_trimmed_reads)
    ch_trimmed_read_qc = FASTQC_TRIMMMED.out.zip.collect { it[1] }
    ch_multiqc_files = ch_multiqc_files.mix()

[..truncated..] 

}
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Add module inputs and assign module outputs

Modify `genomeassembler-5.nf` and use the `mix` operator to combine the `ch_read_qc` and `ch_assembly_qc` channels with the prexisting, empty `ch_multiqc_files` channel.

:::::::::::::::  solution

## Solution

```groovy 
[..truncated..] 

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow GENOMEASSEMBLER {

    take:
    ch_samplesheet // channel: samplesheet read in from --input
    multiqc_config
    multiqc_logo
    outdir

    main:

    def ch_versions = channel.empty()
    def ch_multiqc_files = channel.empty()

    //
    // MODULE: seqtk trim
    //
    SEQTK_TRIM(ch_samplesheet)
    ch_trimmed_reads = SEQTK_TRIM.out.reads
    ch_versions = ch_versions.mix(seqtk_versions)

    //
    // MODULE: shovill
    //
    SHOVILL(ch_trimmed_reads)
    ch_assemblies = SHOVILL.out.contigs
    ch_versions = ch_versions.mix(shovill_versions)

    //
    // MODULE: fastqc
    //
    FASTQC(ch_samplesheet)
    ch_read_qc = FASTQC.out.zip.collect()
    ch_multiqc_files = ch_multiqc_files.mix(ch_read_qc)

    //
    // MODULE: fastqc trimmed
    //
    FASTQC_TRIMMMED(ch_trimmed_reads)
    ch_trimmed_read_qc = FASTQC_TRIMMMED.out.zip.collect { it[1] }
    ch_multiqc_files = ch_multiqc_files.mix(ch_trimmed_read_qc)

[..truncated..] 

}
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::


Copy the modified `genomeassembler-5.nf` script to the `workflows/` directory, renaming it to `genomeassembler.nf`, and run it by using the following command:

```bash
$ cp bin/genomeassembler-5.nf workflows/genomeassembler.nf
$ nextflow run main.nf --outdir results --profile demo
```

:::::::::::::::::::::::::::::::::::::::: keypoints
- ALiases allow you to use the same module multiple times under different names
::::::::::::::::::::::::::::::::::::::::::::::::::
