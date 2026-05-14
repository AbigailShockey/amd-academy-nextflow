---
title: Making your own nf-core pipeline
teaching: 20
exercises: 40
---

::::::::::::::::::::::::::::::::::::::: objectives

- How do I create a custom nf-core pipeline?
- How do I test a custom nf-core pipeline?
- What are nf-core modules?
- How do I add a module to an nf-core pipeline?

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- Create a custom nf-core pipeline using nf-core tools.
- Run a custom nf-core pipeline using a test profile.
- Explain the purpose and contents of nf-core modules.
- Add multiple modules to a custom nf-core pipeline.

::::::::::::::::::::::::::::::::::::::::::::::::::

## Creating your custom pipeline

To lower the difficulty barrier for nf-core pipeline development, nf-core provides a pipeline template that adheres to all nf-core guidelines, as well as a  command line tool (within nf-core tools) that allows users to create a custom pipeline using this nf-core base template. In this episode, we're going to create your own custom nf-core pipeline using this command line tool.

Let's start by creating a directory for your new pipeline.

```bash
mkdir my-pipeline
cd my-pipeline
```

Then we can use the nf-core tools `pipelines` command with the `create` option to start an interactive text user interface tool for setting up the pipeline.

```bash
nf-core pipelines create
```

After running the command you should see the following output and a **Welcome** screen for the interactive pipeline creation tool, also known as the "pipeline creation wizard." 

```output



                                          ,--./,-.
          ___     __   __   __   ___     /,-._.--~\ 
    |\ | |__  __ /  ` /  \ |__) |__         }  {
    | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                          `._,._,'

    nf-core/tools version 3.2.0 - https://nf-co.re


INFO     Launching interactive nf-core pipeline creation tool.              
```

The pipeline creation tool has a point-and-click interface   and will take you through the following pages during pipeline setup:

1. Welcome
2. Pipeline Type
3. Basic Details
4. Template Features
5. Final Details
6. Logging
7. Create GitHub Repository
8. HowTo create a GitHub repository

Follow the steps below to start setting up your pipeline:

1. On the **Welcome** page select **Let's go!**

![](fig/welcome-page.png 'welcome-page')

2.  On the **Pipeline Type** page select **Custom**  
3.  Select **Next**

![](fig/pipeline-type.png 'pipeline-type')

4.  On the **Basic Details** page, for **GitHub organization**  enter "myorganization"  
5.  For **Workflow name** enter "mypipeline"  
6.  For **A short description of your pipeline** enter "My first nf-core pipeline"  
7.  For **Name of the main author / authors** enter your name
8.  Select **Next**

![](fig/basic-details.png 'basic-details')

9.  In the **Template features** page, set "Toggle all features" to **off**, then **enable**:  
`Add configuration files`  
`Use multiqc`  
`Use nf-core components`  
`Use nf-schema`  
`Add documentation`  
`Add testing profiles`
10.  Select **Continue**

![](fig/template-features-1.png 'template-features-1')

![](fig/template-features-2.png 'template-features-2')

11.  On the **Final details** page select **Finish**

![](fig/final-details.png 'final-details')

12.  On the **Logging** page wait for the pipeline to be created, then select **Continue**

![](fig/logging.png 'logging')

13.  On the **Create GitHub repository** page select **Finish without creating a repo**

![](fig/create-github-repository.png 'create-github-repository')

14.  On the **HowTo create a GitHub repository** page Select **Close**

![](fig/howto-create-github-repository.png 'howto-create-github-repository')

## Testing your first pipeline

Once your pipeline has been set up, you can change to its directory and test it using the `nextflow run` command and the `test` profile.

```bash
cd myorganization-mypipeline
nextflow run . -profile docker,test --outdir results
```

If the pipeline ran successfully, you should see the following:

```output
 N E X T F L O W   ~  version 24.10.5

Launching `./main.nf` [berserk_mccarthy] DSL2 - revision: 883bd10359

Downloading plugin nf-schema@2.3.0
Input/output options
  input                     : https://raw.githubusercontent.com/nf-core/test-datasets/viralrecon/samplesheet/samplesheet_test_illumina_amplicon.csv
  outdir                    : results

Institutional config options
  config_profile_name       : Test profile
  config_profile_description: Minimal test dataset to check pipeline function

Generic options
  trace_report_suffix       : 2025-04-15_15-38-07

Core Nextflow options
  runName                   : berserk_mccarthy
  containerEngine           : docker
  launchDir                 : /home/username/my-pipeline/myorganization-mypipeline
  workDir                   : /home/username/my-pipeline/myorganization-mypipeline/work
  projectDir                : /home/username/my-pipeline/myorganization-mypipeline
  userName                  : username
  profile                   : docker,test
  configFiles               : /home/username/my-pipeline/myorganization-mypipeline/nextflow.config

!! Only displaying parameters that differ from the pipeline defaults !!
------------------------------------------------------
executor >  local (1)
[18/7dd931] process > MYORGANIZATION_MYPIPELINE:MYPIPELINE:MULTIQC [100%] 1 of 1 ✔
-[myorganization/mypipeline] Pipeline completed successfully-
```

The pipeline successfully completed one process, MULTIQC, the output of which can be found in the `results` directory.

## Adding modules to your pipeline

### What is a module?

An nf-core module is a Nextflow  "wrapper" around a command-line tool or script. A "wrapper" is a computer science term for a program or function that calls another program or function. In other words, a module contains a Nextflow script (and a few other files we'll discuss later) that is used to run the command-line tool or script contained within that module. Modules are used as individual processes within a pipeline.

It's important to note that nf-core modules contain either a single tool with one subcommand, or one subcommand of a tool with multiple subcommands. For example, the genome assembly tool shovill contains only one command, so there is only one shovill module. Conversely, the FASTA/FASTQ processing tool seqtk contains multiple subcommands, so there are multiple seqtk modules (one for each subcommand).

While you can develop a module for a tool independently, you can save a lot of time and effort by using [existing nf-core modules](https://nf-co.re/modules/), of which there are thousands. 

### Module contents

Each nf-core module contains files with strict [guidelines](https://nf-co.re/docs/guidelines/components/modules) for structure and content, and these guidelines expand the number of files from one Nextflow `.nf` script file to five mandatory files. 

The five mandatory files in an nf-core/module directory are:

```output
├── environment.yml
├── main.nf
├── meta.yml
└── tests/
    ├── main.nf.test
    └── main.nf.test.snap
```

These files can be split up into three main categories:

1. Execution:
-   `main.nf` is the main Nextflow script that defines the process executed by Nextflow
-   `environment.yml` is a Conda environment file that is loaded by the `main.nf`. It specifies the software dependencies for the module when a pipeline run is executed with `-profile conda`
2. Documentation:
-   `meta.yaml` documents the contents of `main.nf`, including things like input(s) and output(s)
3. Testing
-   `main.nf.test` describes a unit test for `main.nf`
-   `main.nf.test.snap` is a snapshot file that is generated by nf-test test. It is used to compare the output of one test run with another, ensuring reproducibility.

Currently, your pipeline consists of one step: It runs MultiQC. If we want to add a new step to that pipeline, we need to add a new module.

A collection of nf-core modules are stored in a [central community repository](https://github.com/nf-core/modules) that can be used by anyone.

There are two main ways you can find nf-core modules to add to your pipeline. You can manually search the modules page of the nf-core website, or you can use nf-core tools on the command line.

### Finding nf-core modules

#### Online

We're going to add a genome assembly step to your pipeline, so let's use the webpage for [shovill's nf-core module](https://nf-co.re/modules/shovill/) as an example.

Each nf-core module's webpage contains the following information:

 1. Description - A description of the module
 2. Input - A list and description of module's inputs
 3. Output - A list and description of the module's outputs

Other useful information on a module's webpage includes commands to install the module, and links to ask a question about the module on Slack or open an issue using GitHub. Both Slack and Github do require accounts.

#### Challenge 1

What are the names of the inputs and outputs of the [samtools stats module](https://nf-co.re/modules/samtools_stats/)?

The solution to this challenge can be found [here](/nf-core/challenge-solutions/creating-pipelines/challenge-1.md).

#### On the command line

To get a list of nf-core modules on the command line, we need to use the `modules` nf-core command with the `list remote` options:

```bash
nf-core modules list remote
```

This command lists all the modules available in nf-core's [GitHub repository](https://github.com/nf-core/modules.git). The output of this command is quite long, so only the first and last few entries are shown below, separated by a line of *:

```output



                                          ,--./,-.
          ___     __   __   __   ___     /,-._.--~\ 
    |\ | |__  __ /  ` /  \ |__) |__         }  {
    | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                          `._,._,'

    nf-core/tools version 3.2.0 - https://nf-co.re



INFO     Modules available from https://github.com/nf-core/modules.git (master):                                                                                                                   
                                                                                                                                                                                                   
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ Module Name                                           ┃
┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┩
│ abacas                                                │
│ abricate/run                                          │
│ abricate/summary                                      │
│ abritamr/run                                          │
│ adapterremoval                                        │
│ adapterremovalfixprefix                               │

**********************************************************
                                                                                                                                                                                                   
│ xeniumranger/rename                                   │
│ xeniumranger/resegment                                │
│ xz/compress                                           │
│ xz/decompress                                         │
│ yahs                                                  │
│ yak/count                                             │
│ yara/index                                            │
│ yara/mapper                                           │
│ zip                                                   │
└───────────────────────────────────────────────────────┘
```

### Installing an nf-core module

To install an nf-core module, we use the nf-core `modules` command with the `install` option. We're going to continue using the shovill assembler as our example. Before installing the shovill module, make sure you've changed directories into the pipeline's directory:

```bash
cd myorganization-myfirstworkflow
nf-core modules install shovill
```

Once the module has finished installing, we can use the `modules` nf-core command with the `list local` options to see what modules have been downloaded for the pipeline:

```bash
nf-core modules list local
```
Which produces the following output:

```output
                                          ,--./,-.
          ___     __   __   __   ___     /,-._.--~\ 
    |\ | |__  __ /  ` /  \ |__) |__         }  {
    | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                          `._,._,'

    nf-core/tools version 3.2.0 - https://nf-co.re


INFO     Repository type: pipeline                                                                                                                                                                 
INFO     Modules installed in '.':                                                                                                                                                                 
                                                                                                                                                                                                   
┏━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━┓
┃ Module Name ┃ Repository      ┃ Version SHA ┃ Message                                                                     ┃ Date       ┃
┡━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━┩
│ multiqc     │ nf-core/modules │ f0719ae     │ bump multiqc 1.26 to 1.27 (#7364)                                           │ 2025-01-27 │
│ shovill     │ nf-core/modules │ 05954da     │ Delete all tag.yml + relative path in antismash/antismashlite tests (#8116) │ 2025-03-26 │
└─────────────┴─────────────────┴─────────────┴─────────────────────────────────────────────────────────────────────────────┴────────────┘
```

As you can see, shovill is now listed as a module locally installed for our pipeline. If we view the contents of the modules/nf-core folder, a folder for the shovill module can now be found there:

```output
└── modules
    └── nf-core
          ├── multiqc/
          └── shovill/
```

Next, we're going to download the module for [seqtk trim](https://nf-co.re/modules/seqtk_trim). Trim is a subcommand of the tool seqtk, which trims adapters and low quality bases from sequencing reads. This is the program we will use to clean our reads prior to assembly.

```bash
nf-core modules install seqtk/trim
```

If we view the contents of the modules/nf-core folder, a folder for the seqtk trim module can now be found there:

```output
└── modules
    └── nf-core
          ├── multiqc/
          ├── seqtk
          │   └── trim/
          └── shovill/
```

### Adding an installed module to the workflow script

Installing a module does not automatically add it to your pipeline; it downloads the files the pipeline needs to run the module. Several lines of code need to be added to the `workflow` file for the module to be included.

First, in the `workflows/mypipeline.nf` workflow script, we need to add an `include` statement for the module. The `include` statement should contain the name of the module in curly brackets `{}` (which is also the name of the process that uses that module), followed by the `from` statement and the path to that module's `main.nf` file. Like so:

```groovy
include { MODULE                 } from 'path/to/nf-core/module/main'
```

Modules should be added to the `IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS` section of the workflow script `mypipeline.nf`. They can be added to that section in any order.

#### Adding seqtk trim to your pipeline

The first module we're going to add to your pipeline is seqtk trim:

```groovy
include { SEQTK_TRIM             } from '../modules/nf-core/seqtk/trim/main'
```

After we've added the `include` statement, we need to add the process `SEQK_TRIM()` to the workflow block. The process needs to be added within the curly brackets `{}` of the workflow block `MYPIPELINE`, which can be found in the `RUN MAIN WORKFLOW` section. We're going to add this module **before**  the `Collate and save software versions` module for reasons we'll discuss later. The process should be added according to the following format, which include the module's name:

```groovy
//
// MODULE: seqtk trim
//

SEQTK_TRIM()
```

Next we need to add seqtk trim's input to its process. As previously mentioned, you can find a module's input(s) (and output(s)) on its webpage. You can also use the nf-core `modules` command with the `info` option:

```bash
nf-core modules info seqtk/trim
```

Which produces the following output:

```output
╭─ Module: seqtk/trim  ─────────────────────────────────────────────────────────────────────────────╮
│ Location: modules/nf-core/seqtk/trim                                                              │
│ 🔧 Tools: seqtk                                                                                   │
│ 📖 Description: Trim low quality bases from FastQ files                                           │
╰───────────────────────────────────────────────────────────────────────────────────────────────────╯
               ╷                                                                       ╷
 📥 Inputs     │Description                                                            │     Pattern
╺━━━━━━━━━━━━━━┿━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┿━━━━━━━━━━━━╸
 input[0]      │                                                                       │
╶──────────────┼───────────────────────────────────────────────────────────────────────┼────────────╴
  meta  (map)  │Groovy Map containing sample information e.g. [ id:'test',             │
               │single_end:false ]                                                     │
╶──────────────┼───────────────────────────────────────────────────────────────────────┼────────────╴
  reads  (file)│List of input FastQ files                                              │*.{fastq.gz}
               ╵                                                                       ╵
                      ╷                                                                ╷
 📥 Outputs           │Description                                                     │     Pattern
╺━━━━━━━━━━━━━━━━━━━━━┿━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┿━━━━━━━━━━━━╸
 reads                │                                                                │
╶─────────────────────┼────────────────────────────────────────────────────────────────┼────────────╴
  meta  (map)         │Groovy Map containing sample information e.g. [ id:'test',      │
                      │single_end:false ]                                              │
╶─────────────────────┼────────────────────────────────────────────────────────────────┼────────────╴
  *.fastq.gz  (file)  │Filtered FastQ files                                            │*.{fastq.gz}
╶─────────────────────┼────────────────────────────────────────────────────────────────┼────────────╴
 versions             │                                                                │
╶─────────────────────┼────────────────────────────────────────────────────────────────┼────────────╴
  versions.yml  (file)│File containing software versions                               │versions.yml
                      ╵                                                                ╵
Use the following statement to include this module:

include { SEQTK_TRIM } from '../modules/nf-core/seqtk/trim/main'
```

You could also look in a module's `main.nf` script or its `meta.yml` file for its input(s) (and output(s)). This is seqtk trim's `main.nf` script:

```groovy
process SEQTK_TRIM {
    tag "$meta.id"
    label 'process_low'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/seqtk:1.4--he4a0461_1' :
        'biocontainers/seqtk:1.4--he4a0461_1' }"

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.fastq.gz"), emit: reads
    path "versions.yml"                , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args   = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    printf "%s\\n" $reads | while read f;
    do
        seqtk \\
            trimfq \\
            $args \\
            \$f \\
            | gzip --no-name > ${prefix}_\$(basename \$f)
    done

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqtk: \$(echo \$(seqtk 2>&1) | sed 's/^.*Version: //; s/ .*\$//')
    END_VERSIONS
    """
}
```

The seqtk trim process only requires one input channel, which should contain paired end FASTQ files and their sample (aka meta) information. This channel already exists in the `mypipeline.nf` workflow file as `ch_samplesheet`, so the seqtk trim module can be called using the FASTQs as input with the following lines of code:

```groovy
//
// MODULE: seqtk trim
//

SEQTK_TRIM(ch_samplesheet)
```

#### Challenge 2

What three lines of code would you need to:
1. Install the [FastQC module](https://nf-co.re/modules/fastqc/)?
2. Include the FastQC module in your workflow?
3. Call the FastQC module in your workflow using `reads_ch` as input?

The solution to this challenge can be found [here](/nf-core/challenge-solutions/creating-pipelines/challenge-2.md).

#### Testing your custom pipeline with a custom test profile

To test this addition to the pipeline, we're going to create a custom test profile called `demo`: We're going to copy the `test.config` file in the `conf` directory and rename it `demo.config`:

```bash
cd conf/
cp test.config demo.config
```

Then, in the `demo.config` file, we're going to make the following changes:

```groovy
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Nextflow config file for running demo tests
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Defines input files and everything required to run a demo pipeline test.

    Use as follows:
        nextflow run main.nf -profile demo,<docker/singularity> --outdir <OUTDIR>

----------------------------------------------------------------------------------------
*/

params {
    config_profile_name        = 'Demo test profile'
    config_profile_description = 'Demo test dataset to check pipeline function'

    // Input data for demo test
    input = 'https://raw.githubusercontent.com/wslh-bio/spriggan/main/samplesheets/test_full.csv'

}
```

This profile uses a different publicly available input than the `test` profile, because the original `test` profile uses paired and single end reads as input, while the assembly step we're going to add requires paired (but not single) end reads as input.

The config file for the `demo` profile, `demo.config`, should be saved in the `conf/` folder with the other config files. To finish adding this profile to the pipeline, we need to put the following line of code within the curly brackets `{}` of the `profile` block in the `nextflow.config` file:

```groovy
demo      { includeConfig 'conf/demo.config'      }
```

Once this is done, we can test our changes to the pipeline with the demo profile:

```bash
nextflow run . -profile docker,demo --outdir demo_results
```

If the pipeline finishes successfully, you should see something like the following:

```output
 N E X T F L O W   ~  version 24.10.5

Launching `main.nf` [dreamy_meninsky] DSL2 - revision: 883bd10359

Input/output options
  input                     : https://raw.githubusercontent.com/wslh-bio/spriggan/main/samplesheets/test_full.csv
  outdir                    : demo_outdir

Institutional config options
  config_profile_name       : Full test profile
  config_profile_description: Full test dataset to check pipeline function

Generic options
  trace_report_suffix       : 2025-04-30_13-53-50

Core Nextflow options
  runName                   : dreamy_meninsky
  containerEngine           : docker
  launchDir                 : /home/username/my-pipeline/myorganization-mypipeline
  workDir                   : /home/username/my-pipeline/myorganization-mypipeline/work
  projectDir                : /home/username/my-pipeline/myorganization-mypipeline
  userName                  : username
  profile                   : demo,docker
  configFiles               : /home/username/my-pipeline/myorganization-mypipeline/nextflow.config

!! Only displaying parameters that differ from the pipeline defaults !!
------------------------------------------------------
executor >  local (4)
[66/2d7219] process > MYORGANIZATION_MYPIPELINE:MYPIPELINE:SEQTK_TRIM (Sample02) [100%] 3 of 3 ✔
[7f/776766] process > MYORGANIZATION_MYPIPELINE:MYPIPELINE:MULTIQC               [100%] 1 of 1 ✔
-[myorganization/mypipeline] Pipeline completed successfully-
```

This time the pipeline ran two processes, `MULTIQC` and the newly added `SEQTK_TRIM`, the results of which can be found in the `demo_results` directory.

#### Adding shovill to your pipeline

Before we add the shovill module to your pipeline, we're going to make a small change to its `main.nf` script. By default, the shovill module does not name its output files according to sample id (also known as meta id), so we're going to make a few changes to the `main.nf` script to change this particular behavior. This will give our output files unique names and prevent them from being overwritten while the pipeline runs.

First we're going to change the output block from:

```groovy
output:
tuple val(meta), path("contigs.fa")                         , emit: contigs
tuple val(meta), path("shovill.corrections")                , emit: corrections
tuple val(meta), path("shovill.log")                        , emit: log
tuple val(meta), path("{skesa,spades,megahit,velvet}.fasta"), emit: raw_contigs
tuple val(meta), path("contigs.{fastg,gfa,LastGraph}")      , optional:true, emit: gfa
path "versions.yml"                                         , emit: versions
```

to:

```groovy
output:
tuple val(meta), path("${meta.id}.contigs.fa")                          , emit: contigs
tuple val(meta), path("${meta.id}.shovill.corrections")                 , emit: corrections
tuple val(meta), path("${meta.id}.shovill.log")                         , emit: log
tuple val(meta), path("${meta.id}.{skesa,spades,megahit,velvet}.fasta") , emit: raw_contigs
tuple val(meta), path("${meta.id}.contigs.{fastg,gfa,LastGraph}")       , optional:true, emit: gfa
path "versions.yml"                                                     , emit: versions
```

This adds the sample id (aka meta id) to every output file, making them unique.

Then we're going to add the following lines of code to the `script` block **after** the `shovill` command:

```groovy
mv contigs.fa ${meta.id}.contigs.fa
mv contigs.gfa ${meta.id}.contigs.gfa
mv shovill.corrections ${meta.id}.shovill.corrections
mv shovill.log ${meta.id}.shovill.log
mv spades.fasta ${meta.id}.spades.fasta 
```

This renames each of shovill's output files so they include the sample name (aka meta id).

Now that we've made those changes, we can add the process to assemble our reads with shovill. Just as we did with seqtk trim, we need to add an `include` statement for shovill to the `IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS` section of the workflow script:

```groovy
include { SHOVILL } from '../modules/nf-core/shovill/main'
```

Then we need to add the `SHOVILL` process within the curly brackets `{}` of the workflow block `MYPIPELINE` found in the `RUN MAIN WORKFLOW` section:

```groovy
//
// MODULE: shovill
//

SHOVILL()
```

Shovill only requires one input, paired FASTQ reads, and the outputs of seqtk trim are:
1. Filtered FASTQ files with the `*.{fastq.gz}` extension, emitted as `reads`
2. A file containing software versions, `versions.yml`, emitted as `versions`

**Note**: As a reminder, The `emit` option defines a name for the output channel of a process. This name can then be used to access the channel from the process output.

In order to pass the trimmed reads from seqtk trim to shovill, we can reference them in the workflow script like so:

```groovy
//
// MODULE: shovill
//

SHOVILL(SEQTK_TRIM.out.reads)
```

Alternatively, we can store the trimmed reads as a variable, which helps improve the readability of the workflow:

```groovy
ch_trimmed_reads = SEQTK_TRIM.out.reads

//
// MODULE: shovill
//

SHOVILL(ch_trimmed_reads)
```

Once this is done, we can test our changes to the pipeline with the demo profile again:

```bash
nextflow run . -profile docker,demo --outdir demo_results
```

If the pipeline finishes successfully, you should see something like the following:

```output
 N E X T F L O W   ~  version 24.10.5

Launching `main.nf` [irreverent_snyder] DSL2 - revision: 883bd10359

Input/output options
  input                     : https://raw.githubusercontent.com/wslh-bio/spriggan/main/samplesheets/test_full.csv
  outdir                    : demo_outdir

Institutional config options
  config_profile_name       : Demo test profile
  config_profile_description: Demo test dataset to check pipeline function

Generic options
  trace_report_suffix       : 2025-05-01_14-05-38

Core Nextflow options
  runName                   : irreverent_snyder
  containerEngine           : docker
  launchDir                 : /home/username/my-pipeline/myorganization-mypipeline
  workDir                   : /home/username/my-pipeline/myorganization-mypipeline/work
  projectDir                : /home/username/my-pipeline/myorganization-mypipeline
  userName                  : username
  profile                   : demo,docker
  configFiles               : /home/username/my-pipeline/myorganization-mypipeline/nextflow.config

!! Only displaying parameters that differ from the pipeline defaults !!
------------------------------------------------------
executor >  local (4)
[0a/91e1cc] process > MYORGANIZATION_MYPIPELINE:MYPIPELINE:SEQTK_TRIM (Sample01) [100%] 3 of 3, cached: 3 ✔
[98/103469] process > MYORGANIZATION_MYPIPELINE:MYPIPELINE:SHOVILL (Sample03)    [100%] 3 of 3 ✔
[6f/1d874a] process > MYORGANIZATION_MYPIPELINE:MYPIPELINE:MULTIQC               [100%] 1 of 1 ✔
-[myorganization/mypipeline] Pipeline completed successfully-
```

This time the pipeline ran three processes, `MULTIQC`, `SEQTK_TRIM`, and the newly added `SHOVILL`, the results of which can be found in the `demo_results` directory.

#### Collating and saving software versions

The final step in adding new modules to your pipeline is to add the module versions to the `ch_versions` channel. This ensures they will be logged in the `mypipeline_software_mqc_versions.yml` and the `multiqc.html` output files. To add the module versions to the `ch_versions` channel, you need to use the nextflow operators `.mix()` and `.first()`. The `.mix()` operator emits the items from >2 source channels into a single output channel, and the `.first()` emits the first item in a channel. Using these operators allows us to add one `version.yml` file from each process into the `ch_versions` channel.

In the seqtk trim module block, **after** the `SEQTK_TRIM` process, add:

```groovy
ch_versions = ch_versions.mix(SEQTK_TRIM.out.versions.first())
```

And in the shovill module block, **after** the `SHOVILL` process, add:

```groovy
ch_versions = ch_versions.mix(SHOVILL.out.versions.first())
```

These lines of code add the `versions.yml` file output by each module to the `ch_versions` channel.

This is why we put the seqtk trim and shovill modules **before**  the `Collate and save software versions` module; each `versions.yml` file needed to be added to the `ch_versions` channel before the software versions were collated and saved by the pipeline.

If your finished pipeline executed successfully, the `demo_outdir` output directory, should have the following files and structure:

```output
demo_outdir
├── multiqc
│ 	├── multiqc_data/
│ 	└── multiqc_report.html
├── pipeline_info
│ 	├── execution_report_*.html
│ 	├── execution_timeline_*.html
│ 	├── execution_trace_*.txt
│ 	├── mypipeline_software_mqc_versions.yml
│ 	├── params_*.json
│ 	└── pipeline_dag_*.html
├── seqtk
│ 	├── Sample01_Sample01_R1.fastq.gz
│ 	├── Sample01_Sample01_R2.fastq.gz
│ 	├── Sample02_Sample02_R1.fastq.gz
│ 	├── Sample02_Sample02_R2.fastq.gz
│ 	├── Sample03_Sample03_R1.fastq.gz
│ 	└── Sample03_Sample03_R2.fastq.gz
└── shovill
	├── Sample01.contigs.fa
	├── Sample01.contigs.gfa
	├── Sample01.shovill.corrections
	├── Sample01.shovill.log
	├── Sample01.spades.fasta
	├── Sample02.contigs.fa
	├── Sample02.contigs.gfa
	├── Sample02.shovill.corrections
	├── Sample02.shovill.log
	├── Sample02.spades.fasta
	├── Sample03.contigs.fa
	├── Sample03.contigs.gfa
	├── Sample03.shovill.corrections
	├── Sample03.shovill.log
	└── Sample03.spades.fasta    
```

:::::::::::::::::::::::::::::::::::::::: keypoints
- You can create a custom pipeline according to the nf-core framework using the `nf-core pipelines create` command.
- An nf-core module is a Nextflow  "wrapper" around a command-line tool or script, which is a used as a process in an nf-core workflow.
- Modules can be installed using `nf-core modules install`
- Modules can be added to your custom pipeline by adding an `include` statement and the module process to the pipeline's workflow script.
::::::::::::::::::::::::::::::::::::::::::::::::::
