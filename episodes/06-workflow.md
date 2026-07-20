---
title: Workflow
teaching: 20
exercises: 20
---

::::::::::::::::::::::::::::::::::::::: objectives

- Create a Nextflow workflow joining multiple processes.
- Understand how to to connect processes via their inputs and outputs within a workflow.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How do I connect channels and processes to create a workflow?
- How do I invoke a process inside a workflow?

::::::::::::::::::::::::::::::::::::::::::::::::::

## Workflow

Our previous episodes have shown us how to parameterise workflows using `params`, move data around a workflow using `channels` and define individual tasks using `processes`. In this episode we will cover how connect multiple processes to create a workflow.

## Workflow definition

We can connect processes to create our pipeline inside a `workflow` scope.
The  workflow scope starts with the keyword `workflow`, followed by an optional name and finally the workflow body delimited by curly brackets `{}`.

::::::::::::::::::::::::::::::::::::::::  callout

## Implicit workflow

In contrast to processes, the workflow definition in Nextflow does not require a name. In Nextflow, if you don't give a name to a workflow, it's considered the main/implicit starting point of your workflow program.

A named workflow is a `subworkflow` that can be invoked from other workflows, subworkflows are not covered in this lesson, more information can be found in the official documentation [here](https://www.nextflow.io/docs/latest/workflow.html).

::::::::::::::::::::::::::::::::::::::::::::::::::

### Invoking processes with a workflow

As seen previously, a `process` is invoked as a function in the `workflow` scope, passing the expected input channels as arguments as it if were.

```
 <process_name>(<input_ch1>,<input_ch2>,...)
```

To combined multiple processes invoke them in the order they would appear in a workflow. When invoking a process with multiple inputs, provide them in the same order in which they are declared in the `input` block of the process.

From the scripts directory, copy the `workflow_01.nf` script to the current directory and open it using the VS Code Explorer panel on the left. Then run the pipeline.

```bash
$ cp scripts/workflow/workflow_01.nf .
```

```groovy 
process FASTQC {
    input:
      tuple(val(sample_id), path(reads))
    output:
      path "fastqc_${sample_id}_logs"
    script:
      """
      mkdir fastqc_${sample_id}_logs
      fastqc -o fastqc_${sample_id}_logs -f fastq -q ${reads}
      """
}

process MULTIQC {
    publishDir "results/mqc"
    input:
      path transcriptome
    output:
      path "*"
    script:
      """
      multiqc .
      """
}

workflow {
    read_pairs_ch = channel.fromFilePairs('data/yeast/reads/*_{1,2}.fq.gz',checkIfExists: true)

    //assign process output to Nextflow variable fastqc_obj
    fastqc_obj = FASTQC(read_pairs_ch)

    //We use the collect operator to gather multiple channel items into a single item
    MULTIQC(fastqc_obj.collect()).view()
}
```

```bash
$ nextflow run workflow_01.nf
```

```output
 N E X T F L O W   ~  version 26.04.4

Launching `workflow_01.nf` [jolly_picasso] revision: 14c6ded2ee

executor >  local (10)
[63/276dcc] FASTQC (3) | 9 of 9 ✔
[c1/6a8ab9] MULTIQC    | 1 of 1 ✔
[/home/workspace/amd-academy-nextflow/work/c1/6a8ab9a0fb4348f0a54323d0f0a5e9/multiqc_data, /home/workspace/amd-academy-nextflow/work/c1/6a8ab9a0fb4348f0a54323d0f0a5e9/multiqc_report.html]
```

### Process outputs

In the previous example we assigned the process output to a Nextflow variable `fastqc_obj`.

A process output can also be accessed directly using the `out` attribute for the respective `process object`.

For example:

```groovy 
[..truncated..]

workflow {
  read_pairs_ch = channel.fromFilePairs('data/yeast/reads/*_{1,2}.fq.gz',checkIfExists: true)

  FASTQC(read_pairs_ch)

  // process output  accessed using the `out` attribute of the process object
  MULTIQC(FASTQC.out.collect()).view()
  MULTIQC.out.view()

}
```

When a process defines two or more output channels, each of them can be accessed using the list element operator e.g. `out[0]`, `out[1]`, or using named outputs.

### Process named output

It can be useful to name the output of a process, especially if there are multiple outputs.

The process `output` definition allows the use of the `emit:` option to define a named identifier that can be used to reference the channel in the external scope.

For example in the script below we name the output from the `TRIM` process as `trimmed_reads` using the `emit:` option. We can then reference the output as
`TRIM.out.trimmed_reads` in the workflow scope.

From the scripts directory, copy the `workflow_02.nf` script to the current directory and open it using the VS Code Explorer panel on the left. Then run the pipeline.

```bash
$ cp scripts/workflow/workflow_02.nf .
```

```groovy 
process TRIM {

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path('*trimmed*'), emit: trimmed_reads

    script:
    """
    seqtk trimfq ${reads[0]} > ${sample_id}_trimmed_R1.fastq
    seqtk trimfq ${reads[1]} > ${sample_id}_trimmed_R2.fastq
    gzip *.fastq
    """
}

process FASTQC {

    cpus 1

    input:
    tuple val(sample_id), path(reads)

    output:
    path("fastqc_${sample_id}_logs")

    script:
    """
    mkdir fastqc_${sample_id}_logs
    fastqc -o fastqc_${sample_id}_logs -f fastq -q ${reads} -t ${task.cpus}
    """
}
workflow {
  read_pairs_ch = channel.fromFilePairs( 'data/bacteria/reads/Sample01_R{1,2}.fastq.gz',checkIfExists: true)

  TRIM(read_pairs_ch)
  fastqc_ch=FASTQC(TRIM.out.trimmed_reads)
}
```

```bash
$ nextflow run workflow_02.nf
```

```output
 N E X T F L O W   ~  version 26.04.4

Launching `workflow_02.nf` [small_raman] revision: 505f269b8f

executor >  local (2)
[01/9e51cc] process > TRIM (1)   [100%] 1 of 1 ✔
[65/8feb93] process > FASTQC (1) [100%] 1 of 1 ✔
```

### Accessing script parameters

A workflow component can access any variable and parameter defined in the outer scope.

From the scripts directory, copy the `workflow_03.nf` script to the current directory and open it using the VS Code Explorer panel on the left.

```bash
$ cp scripts/workflow/workflow_03.nf .
```

```groovy 
[..truncated..]

//reads defined outside workflow scope
params.reads = 'data/yeast/reads/*_{1,2}.fq.gz'

workflow {

    read_pairs_ch = channel.fromFilePairs(params.reads)

    //assign process output to Nextflow variable fastqc_obj
    fastqc_obj = FASTQC(read_pairs_ch)

    //We use the collect operator to gather multiple channel items into a single item
    MULTIQC(fastqc_obj.collect()).view()
}
```

In this example `params.reads`, defined outside the workflow scope, can be accessed inside the `workflow` scope.

:::::::::::::::::::::::::::::::::::::::  challenge

## Workflow


From the `scripts/workflow` directory, copy the `workflow_exercise.nf` script to the current directory and connect the output of the process `FASTQC` to `PARSEZIP`.

**Note:** You will need to pass the `read_pairs_ch` as an argument to FASTQC and you will need to use the `collect` operator to gather the items in the FASTQC channel output to a single List item.

```groovy 
params.reads = 'data/yeast/reads/*_{1,2}.fq.gz'

process FASTQC {
 input:
 tuple val(sample_id), path(reads)

 output:
 path "fastqc_${sample_id}_logs/*.zip"

 script:
 """
 mkdir fastqc_${sample_id}_logs
 fastqc -o fastqc_${sample_id}_logs  ${reads}
 """
}

process PARSEZIP {
 publishDir "results/fqpass", mode:"copy"
 input:
 path fastqc_logs

 output:
 path 'pass_basic.txt'

 script:
 """
 for zip in *.zip; do zipgrep 'Basic Statistics' \$zip|grep 'summary.txt'; done > pass_basic.txt
 """
}

workflow {
  read_pairs_ch = channel.fromFilePairs(params.reads,checkIfExists: true)
//connect process FASTQC and PARSEZIP
// remember to use the collect operator on the FASTQC output
}
```

:::::::::::::::  solution

## Solution

```groovy 
params.reads = 'data/yeast/reads/*_{1,2}.fq.gz'

process FASTQC {
    input:
    tuple val(sample_id), path(reads)

    output:
    path "fastqc_${sample_id}_logs/*.zip"

    script:
    //flagstat simple stats on bam file
    """
    mkdir fastqc_${sample_id}_logs
    fastqc -o fastqc_${sample_id}_logs -f fastq -q ${reads} -t ${task.cpus}
    """
}

process PARSEZIP {

    publishDir "results/fqpass", mode:"copy"

    input:
    path flagstats

    output:
    path 'pass_basic.txt'

    script:
    """
    for zip in *.zip; do
        zipgrep 'Basic Statistics' \$zip \\
        | grep 'summary.txt'
    done > pass_basic.txt
    """
}

workflow {
    read_pairs_ch = channel.fromFilePairs( params.reads, checkIfExists: true )
    PARSEZIP( FASTQC( read_pairs_ch ).collect() )
}
```

```bash 
$ nextflow run workflow_exercise.nf
```

```output

 N E X T F L O W   ~  version 26.04.4

Launching `workflow_exercise_answer.nf` [cheeky_liskov] revision: 9f90e3ccf8

executor >  local (10)
[b4/45ff59] process > FASTQC (9) [100%] 9 of 9 ✔
[09/033786] process > PARSEZIP   [100%] 1 of 1 ✔
```

```bash 
$ wc -l  results/fqpass/pass_basic.txt
```

```output 
18 results/fqpass/pass_basic.txt
```

The file `results/fqpass/pass_basic.txt` should have 18 lines.
If you only have two lines it might mean that you did not use `collect()` operator on the FASTC output channel.



:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::



:::::::::::::::::::::::::::::::::::::::: keypoints

- A Nextflow workflow is defined by invoking `processes` inside the `workflow` scope.
- A process is invoked like a function inside the `workflow` scope passing any required input parameters as arguments. e.g. `FASTQC(reads_ch)`.
- Process outputs can be accessed using the `out` attribute for the respective `process` object or assigning the output to a Nextflow variable. 
- Multiple outputs from a single process can be accessed using the list syntax `[]` and it's index or by referencing the a named process output .

::::::::::::::::::::::::::::::::::::::::::::::::::


