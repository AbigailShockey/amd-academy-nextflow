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
$ cp scripts/nfcore_pipeline/*.nf bin/
```

This folder contains files we will be modifying in this episode. 

## Add modules to the workflow script

The first thing we want to do is add the remaining modules we just installed to the `IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS` section of the workflow script. Since we will be running FastQC on both the raw and trimmed reads, we will need to list it twice and use `as` to give it a different name, `FASTQC_TRIMMED`. This new name is known as an "alias".

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

Modify `genomeassembler-1.nf`, adding the paths to the Shovill, FastQC, and FASTQC_TRIMMED, module paths to the `IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS` section.

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

```output
 N E X T F L O W   ~  version 25.10.4

Launching `main.nf` [cranky_legentil] DSL2 - revision: 27a6d188dd

Input/output options
  input                     : https://raw.githubusercontent.com/wslh-bio/spriggan/main/samplesheets/test_full.csv
  outdir                    : results

Institutional config options
  config_profile_name       : Demo test profile
  config_profile_description: Demo test dataset to check pipeline function

Generic options
  trace_report_suffix       : 2026-06-01_18-52-56

Core Nextflow options
  runName                   : cranky_legentil
  launchDir                 : /home/user/nfcore-pipeline/myorg-genomeassembler
  workDir                   : /home/user/nfcore-pipeline/myorg-genomeassembler/work
  projectDir                : /home/user/nfcore-pipeline/myorg-genomeassembler
  userName                  : user
  profile                   : demo
  configFiles               : /home/user/nfcore-pipeline/myorg-genomeassembler/nextflow.config

!! Only displaying parameters that differ from the pipeline defaults !!
------------------------------------------------------
executor >  local (4)
[47/d1eb63] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:SEQTK_TRIM (Sample02)     [100%] 3 of 3 ✔
[0b/9fa7b7] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:MULTIQC (genomeassembler) [100%] 1 of 1 ✔
-[myorg/genomeassembler] Pipeline completed successfully-
```

Viewing the `results` directory with `tree` shows us that the pipeline emitted results for both MultiQC and FastQC. Information about the pipeline's execution can be found in the `pipeline_info` directory.

```bash
tree results
```

```output
results
├── multiqc
│   ├── multiqc_data
│   │   ├── llms-full.txt
│   │   ├── multiqc_citations.txt
│   │   ├── multiqc_data.json
│   │   ├── multiqc.log
│   │   ├── multiqc.parquet
│   │   ├── multiqc_software_versions.txt
│   │   └── multiqc_sources.txt
│   └── multiqc_report.html
├── pipeline_info
│   ├── execution_report_2026-06-01_18-52-56.html
│   ├── execution_timeline_2026-06-01_18-52-56.html
│   ├── execution_trace_2026-06-01_18-52-56.txt
│   ├── genomeassembler_software_mqc_versions.yml
│   ├── params_2026-06-01_18-52-59.json
│   └── pipeline_dag_2026-06-01_18-52-56.html
└── seqtk
    ├── Sample01_Sample01_R1.fastq.gz
    ├── Sample01_Sample01_R2.fastq.gz
    ├── Sample02_Sample02_R1.fastq.gz
    ├── Sample02_Sample02_R2.fastq.gz
    ├── Sample03_Sample03_R1.fastq.gz
    └── Sample03_Sample03_R2.fastq.gz
```

## Add modules to the workflow section

Next we want to add the modules we just included in the `IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS` section to the `RUN MAIN WORKFLOW` section. 

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

## Add the remaining modules

Modify `genomeassembler-2.nf`, adding the SHOVILL, FASTQC, and FASTQC_TRIMMED, modules (but not their inputs) to the `IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS` section.

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
$ nextflow run main.nf --outdir results --profile demo -resume
```
```output
 N E X T F L O W   ~  version 25.10.4

Launching `main.nf` [voluminous_mestorf] DSL2 - revision: 27a6d188dd

Input/output options
  input                     : https://raw.githubusercontent.com/wslh-bio/spriggan/main/samplesheets/test_full.csv
  outdir                    : results

Institutional config options
  config_profile_name       : Demo test profile
  config_profile_description: Demo test dataset to check pipeline function

Generic options
  trace_report_suffix       : 2026-06-01_18-57-51

Core Nextflow options
  runName                   : voluminous_mestorf
  launchDir                 : /home/user/nfcore-pipeline/myorg-genomeassembler
  workDir                   : /home/user/nfcore-pipeline/myorg-genomeassembler/work
  projectDir                : /home/user/nfcore-pipeline/myorg-genomeassembler
  userName                  : user
  profile                   : demo
  configFiles               : /home/user/nfcore-pipeline/myorg-genomeassembler/nextflow.config

!! Only displaying parameters that differ from the pipeline defaults !!
------------------------------------------------------
[-        ] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:SEQTK_TRIM -
Process `MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:SHOVILL` declares 1 input but was called with 0 arguments

 -- Check script 'workflows/genomeassembler.nf' at line: 43 or see '.nextflow.log' file for more details
```

The pipeline will fail this time because the modules we added to the workflow have no inputs.

## Adding module inputs and assigning module outputs to variables

Next we will add inputs to the modules we previously added to the `RUN MAIN WORKFLOW` section of the workflow script and assign their outputs to variables to they can be passed to the next step in the pipeline. 

**Note:**
- The input of SHOVILL will be the `reads` output from Seqtk
- The input of FASTQC will be the input reads, already stored in `ch_samplesheet`
- The input of FASTQC_TRIMMED will be the `contigs` output from Shovill

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
    FASTQC_TRIMMED()
    ch_trimmed_read_qc = .collect { it[1] }

[..truncated..] 

}
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Add module inputs and assign module outputs

Modify `genomeassembler-3.nf`, assign inputs to the SHOVILL, FASTQC, and FASTQC_TRIMMED, modules. Assign the outputs of each module according to the following naming convention:

- The `reads` output of SEQTK_TRIM is named `ch_trimmed_reads`
- The `contigs` output of SHOVILL is named `ch_assemblies`
- The `zip` output of FASTQC is named `ch_read_qc`
- The `zip` output of FastQC_TRIMMED is named `ch_trimmed_read_qc`

**Note:** the outputs of FASTQC and FASTQC_TRIMMED require the operator `.collect { it[1] }`. This tells Nextflow to collect the second item in the `zip` output (Groovy is a 0-indexed language), which is the files. Recall that this is because nf-core uses meta maps, and the first item in the output is the metadata.

```groovy
[meta,file]
```

We will pass these `zip` outputs to the MultiQC module in a later section.

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
    FASTQC_TRIMMED(ch_trimmed_reads)
    ch_trimmed_read_qc = FASTQC_TRIMMED.out.zip.collect { it[1] }

[..truncated..] 

}
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::


Copy the modified `genomeassembler-3.nf` script to the `workflows/` directory, renaming it to `genomeassembler.nf`, and run it by using the following command:

```bash
$ cp bin/genomeassembler-3.nf workflows/genomeassembler.nf
$ nextflow run main.nf --outdir results --profile demo -resume
```

```output
 N E X T F L O W   ~  version 25.10.4

Launching `main.nf` [special_mayer] DSL2 - revision: 27a6d188dd

Input/output options
  input                     : https://raw.githubusercontent.com/wslh-bio/spriggan/main/samplesheets/test_full.csv
  outdir                    : results

Institutional config options
  config_profile_name       : Demo test profile
  config_profile_description: Demo test dataset to check pipeline function

Generic options
  trace_report_suffix       : 2026-06-01_18-59-36

Core Nextflow options
  runName                   : special_mayer
  launchDir                 : /home/user/nfcore-pipeline/myorg-genomeassembler
  workDir                   : /home/user/nfcore-pipeline/myorg-genomeassembler/work
  projectDir                : /home/user/nfcore-pipeline/myorg-genomeassembler
  userName                  : user
  profile                   : demo
  configFiles               : /home/user/nfcore-pipeline/myorg-genomeassembler/nextflow.config

!! Only displaying parameters that differ from the pipeline defaults !!
------------------------------------------------------
executor >  local (10)
[52/4da2b6] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:SEQTK_TRIM (Sample03)     [100%] 3 of 3, cached: 3 ✔
[99/24083e] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:SHOVILL (Sample03)        [100%] 3 of 3 ✔
[a2/d468a1] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:FASTQC (Sample03)         [100%] 3 of 3 ✔
[ba/f254df] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:FASTQC_TRIMMED (Sample03) [100%] 3 of 3 ✔
[48/0a6795] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:MULTIQC (genomeassembler) [100%] 1 of 1 ✔
-[myorg/genomeassembler] Pipeline completed successfully-
```

The pipeline should finished successfully this time, because we gave each module an input.

Viewing the `results` directory with `tree` shows us the pipeline emitted results for the added modules. Additionally, there are more pipeline executation files in the `pipeline_info` directory.

```bash
tree results
```

```output
results
├── fastqc
│   ├── Sample01_1_fastqc.html
│   ├── Sample01_1_fastqc.zip
│   ├── Sample01_2_fastqc.html
│   ├── Sample01_2_fastqc.zip
│   ├── Sample02_1_fastqc.html
│   ├── Sample02_1_fastqc.zip
│   ├── Sample02_2_fastqc.html
│   ├── Sample02_2_fastqc.zip
│   ├── Sample03_1_fastqc.html
│   ├── Sample03_1_fastqc.zip
│   ├── Sample03_2_fastqc.html
│   └── Sample03_2_fastqc.zip
├── multiqc
│   ├── multiqc_data
│   │   ├── llms-full.txt
│   │   ├── multiqc_citations.txt
│   │   ├── multiqc_data.json
│   │   ├── multiqc.log
│   │   ├── multiqc.parquet
│   │   ├── multiqc_software_versions.txt
│   │   └── multiqc_sources.txt
│   └── multiqc_report.html
├── pipeline_info
│   ├── execution_report_2026-06-01_18-52-56.html
│   ├── execution_report_2026-06-01_18-57-51.html
│   ├── execution_report_2026-06-01_18-59-36.html
│   ├── execution_timeline_2026-06-01_18-52-56.html
│   ├── execution_timeline_2026-06-01_18-57-51.html
│   ├── execution_timeline_2026-06-01_18-59-36.html
│   ├── execution_trace_2026-06-01_18-52-56.txt
│   ├── execution_trace_2026-06-01_18-57-51.txt
│   ├── execution_trace_2026-06-01_18-59-36.txt
│   ├── genomeassembler_software_mqc_versions.yml
│   ├── params_2026-06-01_18-52-59.json
│   ├── params_2026-06-01_18-57-55.json
│   ├── params_2026-06-01_18-59-39.json
│   ├── pipeline_dag_2026-06-01_18-52-56.html
│   ├── pipeline_dag_2026-06-01_18-57-51.html
│   └── pipeline_dag_2026-06-01_18-59-36.html
├── seqtk
│   ├── Sample01_Sample01_R1.fastq.gz
│   ├── Sample01_Sample01_R2.fastq.gz
│   ├── Sample02_Sample02_R1.fastq.gz
│   ├── Sample02_Sample02_R2.fastq.gz
│   ├── Sample03_Sample03_R1.fastq.gz
│   └── Sample03_Sample03_R2.fastq.gz
└── shovill
    ├── contigs.fa
    ├── shovill.corrections
    ├── shovill.log
    └── spades.fasta
```

Because of the way the Shovill module is coded, only the output of the last sample passed to Shovill is available in the `results` directory.

## Mixing FastQC results

Next we will use the `mix` operator to combine the `ch_read_qc` and `ch_assembly_qc` channels with the prexisting, empty `ch_multiqc_files` channel, so the results of FastQC and FASTQC_TRIMMED can be passed to the MultiQC module.

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
    FASTQC_TRIMMED(ch_trimmed_reads)
    ch_trimmed_read_qc = FASTQC_TRIMMED.out.zip.collect { it[1] }
    ch_multiqc_files = ch_multiqc_files.mix()

[..truncated..] 

}
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Add module inputs and assign module outputs

Modify `genomeassembler-4.nf` and use the `mix` operator to combine the `ch_read_qc` and `ch_assembly_qc` channels with the prexisting, empty `ch_multiqc_files` channel.

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
    ch_multiqc_files = ch_multiqc_files.mix(ch_read_qc)

    //
    // MODULE: fastqc trimmed
    //
    FASTQC_TRIMMED(ch_trimmed_reads)
    ch_trimmed_read_qc = FASTQC_TRIMMED.out.zip.collect { it[1] }
    ch_multiqc_files = ch_multiqc_files.mix(ch_trimmed_read_qc)

[..truncated..] 

}
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::


Copy the modified `genomeassembler-4.nf` script to the `workflows/` directory, renaming it to `genomeassembler.nf`, and run it by using the following command:

```bash
$ cp bin/genomeassembler-4.nf workflows/genomeassembler.nf
$ nextflow run main.nf --outdir results --profile demo -resume
```

```output
X T F L O W   ~  version 25.10.4

Launching `main.nf` [cheesy_banach] DSL2 - revision: 27a6d188dd

Input/output options
  input                     : https://raw.githubusercontent.com/wslh-bio/spriggan/main/samplesheets/test_full.csv
  outdir                    : results

Institutional config options
  config_profile_name       : Demo test profile
  config_profile_description: Demo test dataset to check pipeline function

Generic options
  trace_report_suffix       : 2026-06-01_19-12-40

Core Nextflow options
  runName                   : cheesy_banach
  launchDir                 : /home/user/nfcore-pipeline/myorg-genomeassembler
  workDir                   : /home/user/nfcore-pipeline/myorg-genomeassembler/work
  projectDir                : /home/user/nfcore-pipeline/myorg-genomeassembler
  userName                  : user
  profile                   : demo
  configFiles               : /home/user/nfcore-pipeline/myorg-genomeassembler/nextflow.config

!! Only displaying parameters that differ from the pipeline defaults !!
------------------------------------------------------
executor >  local (1)
[52/4da2b6] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:SEQTK_TRIM (Sample03)     [100%] 3 of 3, cached: 3 ✔
[99/24083e] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:SHOVILL (Sample03)        [100%] 3 of 3, cached: 3 ✔
[a2/d468a1] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:FASTQC (Sample03)         [100%] 3 of 3, cached: 3 ✔
[ba/f254df] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:FASTQC_TRIMMED (Sample03) [100%] 3 of 3, cached: 3 ✔
[5a/b7335a] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:MULTIQC (genomeassembler) [100%] 1 of 1 ✔
-[myorg/genomeassembler] Pipeline completed successfully-
```

```output
results
├── fastqc
[..truncated..] 
│   ├── multiqc_data
│   │   ├── fastqc_adapter_content_plot.txt
│   │   ├── fastqc_per_base_n_content_plot.txt
│   │   ├── fastqc_per_base_sequence_quality_plot.txt
│   │   ├── fastqc_per_sequence_gc_content_plot_Counts.txt
│   │   ├── fastqc_per_sequence_gc_content_plot_Percentages.txt
│   │   ├── fastqc_per_sequence_quality_scores_plot.txt
│   │   ├── fastqc_sequence_counts_plot.txt
│   │   ├── fastqc_sequence_duplication_levels_plot.txt
│   │   ├── fastqc_sequence_length_distribution_plot.txt
│   │   ├── fastqc-status-check-heatmap.txt
│   │   ├── fastqc_top_overrepresented_sequences_table.txt
│   │   ├── llms-full.txt
│   │   ├── multiqc_citations.txt
│   │   ├── multiqc_data.json
│   │   ├── multiqc_fastqc.txt
│   │   ├── multiqc_general_stats.txt
│   │   ├── multiqc.log
│   │   ├── multiqc.parquet
│   │   ├── multiqc_software_versions.txt
│   │   └── multiqc_sources.txt
│   ├── multiqc_plots
│   │   ├── pdf
│   │   │   ├── fastqc_adapter_content_plot.pdf
│   │   │   ├── fastqc_per_base_n_content_plot.pdf
│   │   │   ├── fastqc_per_base_sequence_quality_plot.pdf
│   │   │   ├── fastqc_per_sequence_gc_content_plot_Counts.pdf
│   │   │   ├── fastqc_per_sequence_gc_content_plot_Percentages.pdf
│   │   │   ├── fastqc_per_sequence_quality_scores_plot.pdf
│   │   │   ├── fastqc_sequence_counts_plot-cnt.pdf
│   │   │   ├── fastqc_sequence_counts_plot-pct.pdf
│   │   │   ├── fastqc_sequence_duplication_levels_plot.pdf
│   │   │   ├── fastqc_sequence_length_distribution_plot.pdf
│   │   │   ├── fastqc-status-check-heatmap.pdf
│   │   │   └── fastqc_top_overrepresented_sequences_table.pdf
│   │   ├── png
│   │   │   ├── fastqc_adapter_content_plot.png
│   │   │   ├── fastqc_per_base_n_content_plot.png
│   │   │   ├── fastqc_per_base_sequence_quality_plot.png
│   │   │   ├── fastqc_per_sequence_gc_content_plot_Counts.png
│   │   │   ├── fastqc_per_sequence_gc_content_plot_Percentages.png
│   │   │   ├── fastqc_per_sequence_quality_scores_plot.png
│   │   │   ├── fastqc_sequence_counts_plot-cnt.png
│   │   │   ├── fastqc_sequence_counts_plot-pct.png
│   │   │   ├── fastqc_sequence_duplication_levels_plot.png
│   │   │   ├── fastqc_sequence_length_distribution_plot.png
│   │   │   ├── fastqc-status-check-heatmap.png
│   │   │   └── fastqc_top_overrepresented_sequences_table.png
│   │   └── svg
│   │       ├── fastqc_adapter_content_plot.svg
│   │       ├── fastqc_per_base_n_content_plot.svg
│   │       ├── fastqc_per_base_sequence_quality_plot.svg
│   │       ├── fastqc_per_sequence_gc_content_plot_Counts.svg
│   │       ├── fastqc_per_sequence_gc_content_plot_Percentages.svg
│   │       ├── fastqc_per_sequence_quality_scores_plot.svg
│   │       ├── fastqc_sequence_counts_plot-cnt.svg
│   │       ├── fastqc_sequence_counts_plot-pct.svg
│   │       ├── fastqc_sequence_duplication_levels_plot.svg
│   │       ├── fastqc_sequence_length_distribution_plot.svg
│   │       ├── fastqc-status-check-heatmap.svg
│   │       └── fastqc_top_overrepresented_sequences_table.svg
│   └── multiqc_report.html
[..truncated..] 
```

## Updating the meta map

Our final addition to your nf-core pipeline will be four lines of code that will change the `meta.id` item of the meta map. This change will give the input files of FASTQC_TRIMMED a different name (ID), which will give the output files of the module a different name as well. This change needs to be made so the results of both FastQC modules have unique names, ensuring one will not overwrite the other during the MultiQC step.

These four lines of code are:

```groovy
ch_trimmed_reads
.map { meta, reads -> [[id: "${meta.id}_trimmed", single_end: "${meta.single_end}"], reads]
}
.set { ch_trimmed_reads_fastqc }
```

The `map` operator operator transforms items in a channel, and the `set` operator assigns the data stream from a channel to a target variable name, in this case `ch_trimmed_reads_fastqc`. So, these four lines of code transform the items in the `ch_trimmed_reads` channel, specifically `meta.id`, and assign them to the variable `ch_trimmed_reads_fastqc`. The transformation is the addition of the string "_trimmed" to `meta.id`. All other items in the channel (`meta.single_end` and `reads`) remain the same.

This code block will go after the SEQTK_TRIM process in the workflow.

```groovy 
//genomeassembler-5.nf

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
    
    // update meta.id with '_trimmed'
    ch_trimmed_reads
    .map { meta, reads -> [[id: "${meta.id}_trimmed", single_end: "${meta.single_end}"], reads]
    }
    .set { ch_trimmed_reads_fastqc }

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
    ch_multiqc_files = ch_multiqc_files.mix(ch_read_qc)

    //
    // MODULE: fastqc trimmed
    //
    FASTQC_TRIMMED(ch_trimmed_reads_fastqc)
    ch_trimmed_read_qc = FASTQC_TRIMMED.out.zip.collect { it[1] }
    ch_multiqc_files = ch_multiqc_files.mix(ch_trimmed_read_qc)

[..truncated..] 

}
```

Copy the modified `genomeassembler-5.nf` script to the `workflows/` directory, renaming it to `genomeassembler.nf`, and run it by using the following command:

```bash
$ cp bin/genomeassembler-5.nf workflows/genomeassembler.nf
$ nextflow run main.nf --outdir results --profile demo -resume
```

```output
 N E X T F L O W   ~  version 25.10.4

Launching `main.nf` [cranky_euclid] DSL2 - revision: 27a6d188dd

Input/output options
  input                     : https://raw.githubusercontent.com/wslh-bio/spriggan/main/samplesheets/test_full.csv
  outdir                    : results

Institutional config options
  config_profile_name       : Demo test profile
  config_profile_description: Demo test dataset to check pipeline function

Generic options
  trace_report_suffix       : 2026-06-01_19-14-20

Core Nextflow options
  runName                   : cranky_euclid
  launchDir                 : /home/user/nfcore-pipeline/myorg-genomeassembler
  workDir                   : /home/user/nfcore-pipeline/myorg-genomeassembler/work
  projectDir                : /home/user/nfcore-pipeline/myorg-genomeassembler
  userName                  : user
  profile                   : demo
  configFiles               : /home/user/nfcore-pipeline/myorg-genomeassembler/nextflow.config

!! Only displaying parameters that differ from the pipeline defaults !!
------------------------------------------------------
executor >  local (4)
[ce/61ab1d] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:SEQTK_TRIM (Sample01)             [100%] 3 of 3, cached: 3 ✔
[10/4915f4] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:SHOVILL (Sample01)                [100%] 3 of 3, cached: 3 ✔
[e2/fb63c7] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:FASTQC (Sample01)                 [100%] 3 of 3, cached: 3 ✔
[9d/726149] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:FASTQC_TRIMMED (Sample02_trimmed) [100%] 3 of 3 ✔
[2d/a5fb18] process > MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:MULTIQC (genomeassembler)         [100%] 1 of 1 ✔
-[myorg/genomeassembler] Pipeline completed successfully-
```

```output
results
├── fastqc
│   ├── Sample01_1_fastqc.html
│   ├── Sample01_1_fastqc.zip
│   ├── Sample01_2_fastqc.html
│   ├── Sample01_2_fastqc.zip
│   ├── Sample01_trimmed_1_fastqc.html
│   ├── Sample01_trimmed_1_fastqc.zip
│   ├── Sample01_trimmed_2_fastqc.html
│   ├── Sample01_trimmed_2_fastqc.zip
│   ├── Sample02_1_fastqc.html
│   ├── Sample02_1_fastqc.zip
│   ├── Sample02_2_fastqc.html
│   ├── Sample02_2_fastqc.zip
│   ├── Sample02_trimmed_1_fastqc.html
│   ├── Sample02_trimmed_1_fastqc.zip
│   ├── Sample02_trimmed_2_fastqc.html
│   ├── Sample02_trimmed_2_fastqc.zip
│   ├── Sample03_1_fastqc.html
│   ├── Sample03_1_fastqc.zip
│   ├── Sample03_2_fastqc.html
│   ├── Sample03_2_fastqc.zip
│   ├── Sample03_trimmed_1_fastqc.html
│   ├── Sample03_trimmed_1_fastqc.zip
│   ├── Sample03_trimmed_2_fastqc.html
│   └── Sample03_trimmed_2_fastqc.zip
├── multiqc
│   ├── multiqc_data
│   │   ├── fastqc_adapter_content_plot.txt
│   │   ├── fastqc_per_base_n_content_plot.txt
│   │   ├── fastqc_per_base_sequence_quality_plot.txt
│   │   ├── fastqc_per_sequence_gc_content_plot_Counts.txt
│   │   ├── fastqc_per_sequence_gc_content_plot_Percentages.txt
│   │   ├── fastqc_per_sequence_quality_scores_plot.txt
│   │   ├── fastqc_sequence_counts_plot.txt
│   │   ├── fastqc_sequence_duplication_levels_plot.txt
│   │   ├── fastqc_sequence_length_distribution_plot.txt
│   │   ├── fastqc-status-check-heatmap.txt
│   │   ├── fastqc_top_overrepresented_sequences_table.txt
│   │   ├── llms-full.txt
│   │   ├── multiqc_citations.txt
│   │   ├── multiqc_data.json
│   │   ├── multiqc_fastqc.txt
│   │   ├── multiqc_general_stats.txt
│   │   ├── multiqc.log
│   │   ├── multiqc.parquet
│   │   ├── multiqc_software_versions.txt
│   │   └── multiqc_sources.txt
│   ├── multiqc_plots
│   │   ├── pdf
│   │   │   ├── fastqc_adapter_content_plot.pdf
│   │   │   ├── fastqc_per_base_n_content_plot.pdf
│   │   │   ├── fastqc_per_base_sequence_quality_plot.pdf
│   │   │   ├── fastqc_per_sequence_gc_content_plot_Counts.pdf
│   │   │   ├── fastqc_per_sequence_gc_content_plot_Percentages.pdf
│   │   │   ├── fastqc_per_sequence_quality_scores_plot.pdf
│   │   │   ├── fastqc_sequence_counts_plot-cnt.pdf
│   │   │   ├── fastqc_sequence_counts_plot-pct.pdf
│   │   │   ├── fastqc_sequence_duplication_levels_plot.pdf
│   │   │   ├── fastqc_sequence_length_distribution_plot.pdf
│   │   │   ├── fastqc-status-check-heatmap.pdf
│   │   │   └── fastqc_top_overrepresented_sequences_table.pdf
│   │   ├── png
│   │   │   ├── fastqc_adapter_content_plot.png
│   │   │   ├── fastqc_per_base_n_content_plot.png
│   │   │   ├── fastqc_per_base_sequence_quality_plot.png
│   │   │   ├── fastqc_per_sequence_gc_content_plot_Counts.png
│   │   │   ├── fastqc_per_sequence_gc_content_plot_Percentages.png
│   │   │   ├── fastqc_per_sequence_quality_scores_plot.png
│   │   │   ├── fastqc_sequence_counts_plot-cnt.png
│   │   │   ├── fastqc_sequence_counts_plot-pct.png
│   │   │   ├── fastqc_sequence_duplication_levels_plot.png
│   │   │   ├── fastqc_sequence_length_distribution_plot.png
│   │   │   ├── fastqc-status-check-heatmap.png
│   │   │   └── fastqc_top_overrepresented_sequences_table.png
│   │   └── svg
│   │       ├── fastqc_adapter_content_plot.svg
│   │       ├── fastqc_per_base_n_content_plot.svg
│   │       ├── fastqc_per_base_sequence_quality_plot.svg
│   │       ├── fastqc_per_sequence_gc_content_plot_Counts.svg
│   │       ├── fastqc_per_sequence_gc_content_plot_Percentages.svg
│   │       ├── fastqc_per_sequence_quality_scores_plot.svg
│   │       ├── fastqc_sequence_counts_plot-cnt.svg
│   │       ├── fastqc_sequence_counts_plot-pct.svg
│   │       ├── fastqc_sequence_duplication_levels_plot.svg
│   │       ├── fastqc_sequence_length_distribution_plot.svg
│   │       ├── fastqc-status-check-heatmap.svg
│   │       └── fastqc_top_overrepresented_sequences_table.svg
│   └── multiqc_report.html

[..truncated..]
```

:::::::::::::::::::::::::::::::::::::::: keypoints
- Aliases allow you to use the same module multiple times under different names
::::::::::::::::::::::::::::::::::::::::::::::::::
