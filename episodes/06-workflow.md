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

Put this codeblock into a Nextflow script named workflow_01.nf:

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

    //index process takes 1 input channel as a argument
    //assign process output to Nextflow variable fastqc_obj
    fastqc_obj = FASTQC(read_pairs_ch)

    //quant channel takes 1 input channel as an argument
    //We use the collect operator to gather multiple channel items into a single item
    MULTIQC(fastqc_obj.collect()).view()
}
```

```bash
nextflow run workflow_01.nf
```

```output
 N E X T F L O W   ~  version 26.04.4

Launching `workflow_01.nf` [cheeky_wiles] revision: 497e7a4004

executor >  local (10)
[89/e2def5] process > FASTQC (8) [100%] 9 of 9 ✔
[0f/0bb6c3] process > MULTIQC    [100%] 1 of 1 ✔
[/home/rstudio/lessons/amd-academy-nextflow/work/0f/0bb6c3c6a0aa4609619aa4480339f1/multiqc_data, /home/rstudio/lessons/amd-academy-nextflow/work/0f/0bb6c3c6a0aa4609619aa4480339f1/multiqc_report.html]
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

For example in the script below we name the output from the `FASTQC` process as `fastqc_results` using the `emit:` option. We can then reference the output as
`FASTQC.out.fastqc_results` in the workflow scope.

Put this codeblock into a Nextflow script named workflow_02.nf:

```groovy 
process INDEX {

    input:
    path transcriptome

    output:
    path 'index', emit: salmon_index

    script:
    """
    salmon index -t $transcriptome -i index
    """
}

process QUANT {

    input:
    each path(index)
    tuple( val(pair_id), path(reads) )

    output:
    path pair_id

    script:
    """
    salmon quant --threads $task.cpus --libType=U -i $index -1 ${reads[0]} -2 ${reads[1]} -o $pair_id
    """
}

workflow {
    transcriptome_ch = channel.fromPath( 'data/yeast/transcriptome/*.fa.gz' )
    read_pairs_ch = channel.fromFilePairs( 'data/yeast/reads/*_{1,2}.fq.gz' )
    INDEX( transcriptome_ch )
    QUANT( INDEX.out.salmon_index, read_pairs_ch ).view()
}
```

```bash
nextflow run workflow_02.nf
```

```output

 N E X T F L O W   ~  version 26.04.4

Launching `workflow_02.nf` [condescending_chandrasekhar] revision: b0ee782bf5

executor >  local (10)
[0a/5547af] process > INDEX (1) [100%] 1 of 1 ✔
[d6/912c73] process > QUANT (8) [100%] 9 of 9 ✔
/home/rstudio/lessons/amd-academy-nextflow/work/7c/a87dd3c8ae3e62232b9f3bbd4c1bb7/temp33_2
/home/rstudio/lessons/amd-academy-nextflow/work/5f/56abbb324ffa8f762e56fdf2147283/ref3
/home/rstudio/lessons/amd-academy-nextflow/work/7b/1aac0f170af3418fdc44a9aa378981/temp33_1
/home/rstudio/lessons/amd-academy-nextflow/work/4c/da7bf9ff9436f7f15b9d96195fd3e5/etoh60_1
/home/rstudio/lessons/amd-academy-nextflow/work/28/616a546d544176d5f27aff61d95c22/ref2
/home/rstudio/lessons/amd-academy-nextflow/work/57/10768e5d9a5833b83d363024bc6d29/temp33_3
/home/rstudio/lessons/amd-academy-nextflow/work/b3/29a0274dd65606e5896619ecb38f40/etoh60_2
/home/rstudio/lessons/amd-academy-nextflow/work/8c/1942d1382e6986ad57b95e84478b1b/etoh60_3
/home/rstudio/lessons/amd-academy-nextflow/work/d6/912c7357c2a82908c04f3df9834b45/ref1
```

### Accessing script parameters

A workflow component can access any variable and parameter defined in the outer scope:

For example:

```groovy 
//workflow_03.nf
[..truncated..]

params.reads = 'data/yeast/reads/*_{1,2}.fq.gz'

workflow {

  reads_ch_ = channel.fromFilePairs(params.reads)
  FASTQC(reads_ch_)
  MULTIQC(FASTQC.out.fastqc_results.collect()).view()
}
```

In this example `params.reads`, defined outside the workflow scope, can be accessed inside the `workflow` scope.

:::::::::::::::::::::::::::::::::::::::  challenge

## Workflow

Connect the output of the process `FASTQC` to `PARSEZIP` in the Nextflow script `workflow_exercise.nf`.

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


