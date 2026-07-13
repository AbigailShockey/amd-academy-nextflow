---
title: Processes Part 2
teaching: 30
exercises: 10
---

::::::::::::::::::::::::::::::::::::::: objectives

- Define outputs to a process.
- Understand how to handle grouped input and output using the tuple qualifier.
- Understand how to use conditionals to control process execution.
- Use process directives to control execution of a process.
- Use the `publishDir` directive to save result files to a directory.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How do I get data, files, and values,  out of processes?
- How do I handle grouped input and output?
- How can I control when a process is executed?
- How do I control resources, such as number of CPUs and memory, available to processes?
- How do I save output/results from a process?

::::::::::::::::::::::::::::::::::::::::::::::::::

## Outputs

We have seen how to input data into a process; now we will see how to output files and values from a process.

The `output` declaration block allows us to define the channels used by the process to send out the files and values produced.

An output block is not required, but if it is present it can contain one or more output declarations.

The output block follows the syntax shown below:

```groovy 
output:
  <output qualifier> <output name>
  <output qualifier> <output name>
  ...
```

### Output values 

Like the input, the type of output data is defined using type qualifiers.

The `val` qualifier allows us to output a value defined in the script.

Because Nextflow processes can only communicate through channels, if we want to share a value output of one process as input to another process, we would need to define that value in the output declaration block as shown in the following example:

From the `scripts/process` directory, copy the `process_output_value.nf` script to the current directory and open it using the VS Code Explorer panel on the left. Then run the pipeline.

```bash
$ cp /home/user/scripts/process/process_output_value.nf .
```

```groovy 
params.fasta="${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz"

process COUNT_COV {
  input:
  val cov

  output:
  val cov

  script:
  """
  zgrep -c "cov=${cov}." $params.fasta > cov.txt
  """
}

workflow {
  cov_ch = channel.of(10..20)
  
  COUNT_COV(cov_ch)
  // use the view operator to display contents of the channel
  COUNT_COV.out.view()
}
```

```bash
$ nextflow run process_output_value.nf -process.debug
```

```output 
 N E X T F L O W   ~  version 26.04.4

Launching `process_output_value.nf` [high_faggin] revision: 9f487585ba

executor >  local (11)
[2b/e1a841] process > COUNT_COV (2)  [100%] 11 of 11 ✔
12
19
18
13
16
15
17
20
10
14
11
```

### Output files

If we want to capture a file instead of a value as output we can use the `path` qualifier that can capture one or more files produced by the process, over the specified channel.

From the `scripts/process` directory, copy the `process_output_file.nf` script to the current directory and open it using the VS Code Explorer panel on the left. Then run the pipeline.

```bash
$ cp /home/user/scripts/process/process_output_file.nf .
```

```groovy 
params.fasta="${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz"

process COUNT_COV {
  input:
  val cov

  output:
  path "contigs_cov_${cov}.txt"

  script:
  """
  zgrep -c "cov=${cov}." $params.fasta > contigs_cov_${cov}.txt
  """
}

workflow {
  cov_ch = channel.of(10..20)
  
  COUNT_COV(cov_ch)
  // use the view operator to display contents of the channel
  COUNT_COV.out.view()
}
```

In this example the process `COUNT_COV` creates a file named `contigs_cov_<cov>.txt` in the work directory containing the number of contigs with that coverage.

Since a file parameter using the same name, `contigs_cov_<cov>.txt`, is declared in the output block, when the task is completed that file is sent over the output channel.

A downstream `operator`, such as `.view` or a `process` declaring the same channel as input will be able to receive it.

Now run the pipeline.

```bash
$ nextflow run process_output_file.nf -process.debug
```


```output 
 N E X T F L O W   ~  version 26.04.4

Launching `process_output_file.nf` [gloomy_noyce] revision: dad85f58cb

executor >  local (11)
[f8/f9907c] process > COUNT_COV (2)  [100%] 11 of 11 ✔
/home/user/amd-academy-nextflow/work/fa/f6c534e8639dfc43cf285729a25a55/contigs_cov_10.txt
/home/user/amd-academy-nextflow/work/33/179ccfbbae1d01944b72b976f73e2a/contigs_cov_14.txt
/home/user/amd-academy-nextflow/work/be/4620c07783ab80acbf71a11dc8773c/contigs_cov_16.txt
/home/user/amd-academy-nextflow/work/a2/9c0730e91f86eaf11965a99ae622b1/contigs_cov_18.txt
/home/user/amd-academy-nextflow/work/f0/fa91cbc0469a807c4d7ac7ac0260d1/contigs_cov_19.txt
/home/user/amd-academy-nextflow/work/7e/8606989b63cb62e8eeb1b8ab54f1c3/contigs_cov_13.txt
/home/user/amd-academy-nextflow/work/d1/41cb1b97f959b0119c605030b795f8/contigs_cov_15.txt
/home/user/amd-academy-nextflow/work/d9/ffb1295327303a5d6981c8e3d72fe1/contigs_cov_20.txt
/home/user/amd-academy-nextflow/work/e2/c86ea2c219bfaafce94e57efe49204/contigs_cov_17.txt
/home/user/amd-academy-nextflow/work/20/cb2cf84d651c0bd0381a8aff88d6ec/contigs_cov_12.txt
/home/user/amd-academy-nextflow/work/f8/f9907cf4861acde8d2c6b94809c1d1/contigs_cov_11.txt
```

### Multiple output files

When an output file name contains a `*` or `?` metacharacter it is interpreted as a pattern match.
This allows us to capture multiple files into a list and output them as a one item channel.

For example, here we will capture the files `sequence_ids.txt` and  `sequence.txt` produced as results from SPLIT\_FASTA in the output channel.

From the `scripts/process` directory, copy the `process_output_multiple.nf` script to the current directory and open it using the VS Code Explorer panel on the left. Then run the pipeline.

```bash
$ cp /home/user/scripts/process/process_output_file.nf .
```

```groovy 
params.fasta="${projectDir}/data/bacteria/assemblies/Sample01.contigs.fa.gz"

process SPLIT_FASTA {
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
```

Now run the pipeline, this time without `-process.debug`.

```bash 
$ nextflow run process_output_multiple.nf
```

```output
 N E X T F L O W   ~  version 26.04.4

Launching `process_output_multiple.nf` [serene_legentil] revision: 099d5fe1df

executor >  local (1)
[72/5bce13] process > SPLIT_FASTA (1) [100%] 1 of 1 ✔
[/home/user/amd-academy-nextflow/work/72/5bce13f434d3de4f78501bb2a0d2a6/sequence.txt, /home/user/amd-academy-nextflow/work/72/5bce13f434d3de4f78501bb2a0d2a6/sequence_ids.txt]
```

**Note:** There are some caveats on glob pattern behaviour:

- Input files are not included in the list of possible matches.
- Glob pattern matches against both files and directories path.
- When a two stars pattern `**` is used to recurse through subdirectories, only file paths are matched i.e. directories are not included in the result list.

:::::::::::::::::::::::::::::::::::::::  challenge

## Output channels

Modify the nextflow script `process_exercise_output.nf` to include an output block that captures the different output file `${chr}_seqids.txt`.

```groovy 
process EXTRACT_IDS {
  input:
  path fasta
  each cov

  //add output block here to capture the file "contigs_cov_${cov}_seqids.txt"

  script:
  """
  zgrep -c "cov=${cov}." ${fasta} > contigs_cov_${cov}.txt
  """
}

workflow {
  fasta_ch = channel.fromPath('data/bacteria/assemblies/Sample01.contigs.fa.gz')
  cov_ch = channel.of(10..20)

  EXTRACT_IDS(fasta_ch, cov_ch)
  EXTRACT_IDS.out.view()
}
```

:::::::::::::::  solution

## Solution

```groovy 
process EXTRACT_IDS {
  input:
  path fasta
  each cov

  //add output block here to capture the file "contigs_cov_${cov}_seqids.txt"
  output:
  path "contigs_cov_${cov}.txt"

  script:
  """
  zgrep "cov=${cov}." ${fasta} > contigs_cov_${cov}.txt
  """
}

workflow {
  fasta_ch = channel.fromPath('data/bacteria/assemblies/Sample01.contigs.fa.gz')
  cov_ch = channel.of(10..20)

  EXTRACT_IDS(fasta_ch, cov_ch)
  EXTRACT_IDS.out.view()
}
```

```output
 N E X T F L O W   ~  version 26.04.4

Launching `process_exercise_output.nf` [prickly_nightingale] revision: bd3f39f7a0

executor >  local (11)
[2a/a8f9c8] process > EXTRACT_IDS (5) [100%] 11 of 11 ✔
/home/user/amd-academy-nextflow/work/f3/8be649e9072fe3037cba931418b226/contigs_cov_17.txt
/home/user/amd-academy-nextflow/work/39/c565b72bd126f6d5cc722a854f28b9/contigs_cov_16.txt
/home/user/amd-academy-nextflow/work/4e/26f5606cd343c8f828ce0db11f4be1/contigs_cov_19.txt
/home/user/amd-academy-nextflow/work/4a/eaf3f6fabd6c1643fc96950aa57cca/contigs_cov_11.txt
/home/user/amd-academy-nextflow/work/d2/2f2c17565a2576d07d676fca1c8dac/contigs_cov_12.txt
/home/user/amd-academy-nextflow/work/95/790ab22f4bd7c662847cbc24ae1b53/contigs_cov_15.txt
/home/user/amd-academy-nextflow/work/53/400f374f2691acebb90874c4fac11e/contigs_cov_18.txt
/home/user/amd-academy-nextflow/work/90/e5c7a838bef5f169272eb15c023dcb/contigs_cov_13.txt
/home/user/amd-academy-nextflow/work/39/0ceb5e90e40ec66ff0134220278bc1/contigs_cov_20.txt
/home/user/amd-academy-nextflow/work/d5/1414bb9558bbafab9981e0cee649ab/contigs_cov_10.txt
/home/user/amd-academy-nextflow/work/2a/a8f9c85c746c2e43090e1ed2ffc1f6/contigs_cov_14.txt
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

### Grouped inputs and outputs

So far we have seen how to declare multiple input and output channels, but each channel was handling only one value at time. However Nextflow can handle groups of values using the `tuple` qualifiers.

In tuples the first item is the grouping key and the second item is the list.

```
[group_key,[file1,file2,...]]
```

When using channel containing a tuple, such a one created with `.filesFromPairs` factory method, the corresponding input declaration must be declared with a `tuple` qualifier, followed by definition of each item in the tuple.

From the `scripts/process` directory, copy the `process_tuple_input.nf` script to the current directory and open it using the VS Code Explorer panel on the left. Then run the pipeline.

```bash
$ cp /home/user/scripts/process/process_tuple_input.nf .
```

```groovy 
process TUPLEINPUT{

    input:
    tuple val(sample_id), path(reads)

    script:
    """
    echo $sample_id
    echo $reads
    """
}

workflow {
    reads_ch = channel.fromFilePairs( 'data/yeast/reads/ref1_{1,2}.fq.gz' )
    TUPLEINPUT( reads_ch )
}
```

```bash
$ nextflow run process_tuple_input.nf  -process.debug
```

outputs

```output 

 N E X T F L O W   ~  version 26.04.4

Launching `process_tuple_input.nf` [tender_fourier] revision: 573e8ac965

executor >  local (1)
[52/43067e] process > TUPLEINPUT (1) [100%] 1 of 1 ✔
ref1
ref1_1.fq.gz ref1_2.fq.gz

```

In the same manner an output channel containing tuple of values can be declared using the `tuple` qualifier following by the definition of each tuple element in the tuple.

In the code snippet below the output channel would contain a tuple with the grouping key value as the Nextflow variable `sample_id` and a list containing the files matching the following pattern `"${sample_id}.fq.gz"`.

```groovy 
output:
  tuple val(sample_id), path("${sample_id}.fq.gz")
```

From the `scripts/process` directory, copy the `process_tuple_io.nf` script to the current directory and open it using the VS Code Explorer panel on the left. Then run the pipeline.

```bash
$ cp /home/user/scripts/process/process_tuple_io.nf .
```

```groovy 
process COMBINE_FQ {
  input:
  tuple val(sample_id), path(reads)

  output:
  tuple val(sample_id), path("${sample_id}.fq.gz")

  script:
  """
  cat $reads > ${sample_id}.fq.gz
  """
}

workflow {
  reads_ch = channel.fromFilePairs('data/yeast/reads/ref1_{1,2}.fq.gz')

  COMBINE_FQ(reads_ch)
  COMBINE_FQ.out.view()
}
```

```bash 
$ nextflow run process_tuple_io.nf
```

The output is now a tuple containing the sample id and the combined fastq files.

```output 

 N E X T F L O W   ~  version 26.04.4

Launching `process_tuple_io.nf` [loquacious_sinoussi] revision: f996b37474

executor >  local (1)
[d7/363b07] process > COMBINE_FQ (1) [100%] 1 of 1 ✔
[ref1, /home/user/amd-academy-nextflow/work/d7/363b07b508064d1c01a43d53ddfef6/ref1.fq.gz]

```

:::::::::::::::::::::::::::::::::::::::  challenge

## Composite inputs and outputs

Fill in the blank \_\_\_ input and output qualifiers for `process_exercise_tuple.nf`.
**Note:** the output for the COMBINE\_REPS process.

```groovy 
//process_exercise_tuple.nf


process COMBINE_REPS {
  input:
  tuple ___(sample_id), ___(reads)

  output:
  tuple ___(sample_id), ___("*.fq.gz")

  script:
  """
  cat *_1.fq.gz > ${sample_id}_R1.fq.gz
  cat *_2.fq.gz > ${sample_id}_R2.fq.gz
  """
}

workflow{
  reads_ch = channel.fromFilePairs('data/yeast/reads/ref{1,2,3}*.fq.gz',size:-1)

  COMBINE_REPS(reads_ch)
  COMBINE_REPS.out.view()
}
```

:::::::::::::::  solution

## Solution

```groovy 
process COMBINE_REPS {
  input:
  tuple val(sample_id), path(reads)

  output:
  tuple val(sample_id), path("*.fq.gz")

  script:
  """
  cat *_1.fq.gz > ${sample_id}_R1.fq.gz
  cat *_2.fq.gz > ${sample_id}_R2.fq.gz
  """
}

workflow{
  reads_ch = channel.fromFilePairs('data/yeast/reads/ref{1,2,3}*.fq.gz',size:-1)

  COMBINE_REPS(reads_ch)
  COMBINE_REPS.out.view()
}
```

```output

 N E X T F L O W   ~  version 26.04.4

Launching `process_exercise_tuple_answer.nf` [nostalgic_jepsen] revision: b61fdd3487

executor >  local (1)
[5f/9e3b67] process > COMBINE_REPS (1) [100%] 1 of 1 ✔
[ref, [/home/user/amd-academy-nextflow/work/5f/9e3b6706fcc36a8992ad0a55036f4e/ref_R1.fq.gz, /home/user/amd-academy-nextflow/work/5f/9e3b6706fcc36a8992ad0a55036f4e/ref_R2.fq.gz]]

```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Conditional execution of a process

The `when` declaration allows you to define a condition that must be verified in order to execute the process. This can be any expression that evaluates a boolean value; `true` or `false`.

It is useful to enable/disable the process execution depending on the state of various inputs and parameters.

In the example below the process `CONDITIONAL` will only execute when the value of the `chr` variable is less than or equal to 5:

From the `scripts/process` directory, copy the `process_when.nf` script to the current directory and open it using the VS Code Explorer panel on the left. Then run the pipeline.

```bash
$ cp /home/user/scripts/process/process_when.nf .
```

```groovy 
process CONDITIONAL {

    input:
    val chr

    when:
    chr <= 5

    script:
    """
    echo $chr
    """
}

workflow {
    chr_ch = channel.of( 1..22 )
    CONDITIONAL( chr_ch )
}
```

```bash
$ nextflow run process_when.nf -process.debug
```

```output 
 N E X T F L O W   ~  version 26.04.4

Launching `process_when.nf` [adoring_venter] revision: 33701a3284

executor >  local (5)
[35/4b0e70] process > CONDITIONAL (5) [100%] 5 of 5 ✔
1

2

3

4

5

```

## Directives

Directive declarations allow the definition of optional settings, like the number of `cpus` and amount of `memory`, that affect the execution of the current process without affecting the task itself.

They must be entered at the top of the process body, before any other declaration blocks (i.e. `input`, `output`, etc).

**Note:** You do not use `=` when assigning a value to a directive.

Directives are commonly used to define the amount of computing resources to be used or extra information for configuration or logging purpose.

From the `scripts/process` directory, copy the `process_directive.nf` script to the current directory and open it using the VS Code Explorer panel on the left. Then run the pipeline.

```bash
$ cp /home/user/scripts/process/process_directive.nf .
```

```groovy 
process PRINTCHR {

    tag "tagging with chr$chr"
    cpus 1

    input:
    val chr

    script:
    """
    echo processing chromosome: $chr
    echo number of cpus $task.cpus
    """
}

workflow {
    chr_ch = channel.of( 1..5 )
    PRINTCHR( chr_ch )
}
```

```bash
$ nextflow run process_directive.nf -process.debug
```

```output 
 N E X T F L O W   ~  version 26.04.4

Launching `process_directive.nf` [fabulous_knuth] revision: 0bfe040a6d

executor >  local (5)
[16/8910fd] process > PRINTCHR (tagging with chr3) [100%] 5 of 5 ✔
processing chromosome: 4
number of cpus 1

processing chromosome: 1
number of cpus 1

processing chromosome: 2
number of cpus 1

processing chromosome: 5
number of cpus 1

processing chromosome: 3
number of cpus 1
```

The above process uses the three directives, `tag`, `cpus` and `echo`.

The `tag` directive to allow you to give a custom tag to each process execution. This tag makes it easier to identify a particular task (executed instance of a process) in a log file or in the execution report.

The second directive `cpus`  allows you to define the number of CPUs required for each task.

The third directive `echo true` prints the stdout to the terminal.

We use the Nextflow `task.cpus` variable to capture the number of cpus assigned to a task. This is frequently used to specify the number of threads in a multi-threaded command in the script block.

Another commonly used directive is memory specification: `memory`.

A complete list of directives is available at this [link](https://www.nextflow.io/docs/latest/process.html#directives).

:::::::::::::::::::::::::::::::::::::::  challenge

## Adding directives

Many software tools allow users to configure the number of CPU threads used, optimizing performance for faster and more efficient data processing in high-throughput sequencing tasks.

In this exercise, we will use the bioinformatics tool [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) to assess the quality of high-throughput sequencing read data. FastQC generates an HTML report along with a directory containing detailed analysis results. We can specify the number of CPU threads for FastQC to use with the -t option, followed by the desired number of threads.

Modify the Nextflow script `process_exercise_directives.nf`

1. Add a `tag` directive logging the sample_id in the execution output.
2. Add a `cpus` directive to specify the number of cpus as 2.
3. Change the fastqc `-t` option value to `$task.cpus` in the script directive.

```groovy 
process FASTQC {
  //add tag directive
  //add cpu directive
 
  input:
  tuple val(sample_id), path(reads)
  
  output:
  tuple val(sample_id), path("fastqc_out")
  
  script:
  """
  mkdir fastqc_out
  fastqc $reads -o fastqc_out -t 1
  """
}

read_pairs_ch = Channel.fromFilePairs('data/yeast/reads/ref*_{1,2}.fq.gz')

workflow {
  FASTQC(read_pairs_ch)
  FASTQC.out.view()
}
```

:::::::::::::::  solution

## solution

```groovy 
process FASTQC {

    tag "$sample_id"
    cpus 2

    input:
    tuple val( sample_id ), path( reads )

    output:
    tuple val( sample_id ), path( "fastqc_out" )

    script:
    """
    mkdir fastqc_out
    fastqc $reads -o fastqc_out -t $task.cpus
    """
}


workflow {
    read_pairs_ch = channel.fromFilePairs( 'data/yeast/reads/ref*_{1,2}.fq.gz' )
    FASTQC( read_pairs_ch )
    FASTQC.out.view()
}
```

```bash
$ nextflow run process_exercise_directives_answers.nf
```

```output

 N E X T F L O W   ~  version 26.04.4

Launching `process_exercise_directives_answers.nf` [admiring_ekeblad] revision: 3e1c08367f

executor >  local (3)
[a4/cf32f1] process > FASTQC (ref2) [100%] 3 of 3 ✔
[ref3, /home/user/amd-academy-nextflow/work/36/fdd3c30bee58ab1567f1b96a536c76/fastqc_out]
[ref1, /home/user/amd-academy-nextflow/work/7d/d0971bc88de08fce6a1d8403aeeb70/fastqc_out]
[ref2, /home/user/amd-academy-nextflow/work/a4/cf32f15140b91a2b56be1a37e4e63b/fastqc_out]

```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Organising outputs

### PublishDir directive

Nextflow manages intermediate results from the pipeline's expected outputs independently.

Files created by a `process` are stored in a task specific working directory which is considered as temporary. Normally this is under the `work` directory, which can be deleted upon completion.

The files you want the workflow to return as results need to be defined in the `process` `output` block and then the output directory specified using the `directive` `publishDir`. More information [here](https://www.nextflow.io/docs/latest/process.html#publishdir).

**Note:** A common mistake is to specify an output directory in the `publishDir` directive while forgetting to specify the files you want to include in the `output` block.

```
publishDir <directory>, parameter: value, parameter2: value ...
```

From the `scripts/process` directory, copy the `process_publishDir.nf` script to the current directory and open it using the VS Code Explorer panel on the left.

```bash
$ cp /home/user/scripts/process/process_publishDir.nf .
```

For example if we want to capture the results of the `COMBINE_READS` process in a `results/merged_reads` output directory we
need to define the files in the `output` and  specify the location of the results directory in the `publishDir` directive:

```groovy 
process COMBINE_READS {
  publishDir "results/merged_reads"

  input:
  tuple val(sample_id), path(reads)

  output:
  path("${sample_id}.merged.fq.gz")

  script:
  """
  cat ${reads} > ${sample_id}.merged.fq.gz
  """
}

workflow {
  reads_ch = channel.fromFilePairs('data/yeast/reads/ref1_{1,2}.fq.gz')
  
  COMBINE_READS(reads_ch)
}
```

Now run the pipeline.

```bash 
$ nextflow run process_publishDir.nf
```

```output 

 N E X T F L O W   ~  version 26.04.4

Launching `process_publishDir.nf` [gigantic_lamport] revision: 5bf45650b3

executor >  local (1)
[5d/36e9f5] process > COMBINE_READS (1) [100%] 1 of 1 ✔
```

We can use the UNIX command `ls -l` to examine the contents of the results directory.

```bash 
$ ls -l results/merged_reads/ref1.merged.fq.gz
```

```output 
lrwxrwxrwx 1 user user 99 Jun 30 23:00 results/merged_reads/ref1.merged.fq.gz -> /home/user/amd-academy-nextflow/work/3d/88bbfd2b6b7a85ac81d73ffdecc97c/ref1.merged.fq.gz
```

In the above example, the `publishDir "results/merged_reads"`,  creates a symbolic link `->` to the output files specified by the process `merged_reads` to the directory path `results/merged_reads`.

A symbolic link, often referred to as a symlink, is a type of file that serves as a reference or pointer to another file or directory, allowing multiple access paths to the same resource without duplicating its actual data

::::::::::::::::::::::::::::::::::::::::  callout

## publishDir

The publishDir output is relative to the path the pipeline run has been launched. Hence, it is a good practice to use [implicit variables](https://www.nextflow.io/docs/latest/script.html?highlight=projectdir#script-implicit-variables) like `projectDir` to specify publishDir value.


::::::::::::::::::::::::::::::::::::::::::::::::::

### publishDir parameters

The `publishDir` directive can take optional parameters, for example the `mode` parameter can take the value `"copy"` to specify that you wish to copy the file to output directory rather than just a symbolic link to the files in the working directory. Since the working directory is generally deleted on completion of a pipeline, it is safest to use `mode: "copy"` for results files. The default mode (symlink) is helpful for checking intermediate files which are not needed in the long term.

```groovy 
publishDir "results/merged_reads", mode: "copy"
```

Full list [here](https://docs.seqera.io/nextflow/reference/process#publishdir).

### Manage semantic sub-directories

You can use more than one `publishDir` to keep different outputs in separate directories. To specify which files to put in which output directory use the parameter `pattern` with the a glob pattern that selects which files to publish from the overall set of output files.

From the `scripts/process` directory, copy the `process_publishDir.nf` script to the current directory and open it using the VS Code Explorer panel on the left.

```bash
$ cp /home/user/scripts/process/process_publishDir.nf .
```

```groovy 
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
```

In this we will create an output folder structure in the directory results, which contains a separate sub-directory for sequence id file, `pattern:"*_ids.txt"` ,  and a sequence directory, `results/sequence"` for the `sequence.txt` file. Remember, we need to specify the files we want to copy as outputs.

```bash
$ nextflow run process_publishDir_semantic.nf
```

```output

 N E X T F L O W   ~  version 26.04.4

Launching `process_publishDir_semantic.nf` [elegant_kay] revision: 902918802f

executor >  local (1)
[64/219b7c] process > SPLIT_FASTA (1) [100%] 1 of 1 ✔
[/home/user/amd-academy-nextflow/work/64/219b7c2bdaee1bf645440b085145df/sequence.txt, /home/user/amd-academy-nextflow/work/64/219b7c2bdaee1bf645440b085145df/sequence_ids.txt]

```

We can now use the `ls results/*` command to examine the results directory.

```bash 
$ ls results/*
```

```output
results/ids:
sequence_ids.txt

results/sequence:
sequence.txt
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Publishing results

Add a `publishDir` directive to the nextflow script `process_exercise_publishDir.nf` that copies the merged reads  to the results folder merged\_reps.

```groovy 
params.reads= "data/yeast/reads/ref{1,2,3}*{1,2}.fq.gz"

process MERGE_REPS {
 
 input:
 tuple val(sample_id), path(reads)
 
 output:
 path("*fq.gz")

 script:
 """
 cat *1.fq.gz > ${sample_id}.merged.R1.fq.gz
 cat *2.fq.gz > ${sample_id}.merged.R2.fq.gz
 """
}

workflow {
  reads_ch = channel.fromFilePairs(params.reads,checkIfExists:true,size:6)
  MERGE_REPS(reads_ch)
}
```

:::::::::::::::  solution

## Solution

```groovy 
params.reads= "data/yeast/reads/ref{1,2,3}*{1,2}.fq.gz"

process MERGE_REPS {
  publishDir "results/merged_reps"
  input:
  tuple val(sample_id), path(reads)
  output:
  path("*fq.gz")

  script:
  """
  cat *1.fq.gz > ${sample_id}.merged.R1.fq.gz
  cat *2.fq.gz > ${sample_id}.merged.R2.fq.gz
  """
}

workflow {
  reads_ch = channel.fromFilePairs(params.reads,checkIfExists:true,size:6)
  
  MERGE_REPS(reads_ch)
}
```

```bash 
$ nextflow run process_exercise_publishDir.nf
```

```output 

 N E X T F L O W   ~  version 26.04.4

Launching `process_exercise_publishDir_answer.nf` [dreamy_pike] revision: 597fabd501

executor >  local (1)
[e9/ce2104] process > MERGE_REPS (1) [100%] 1 of 1 ✔
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::  callout

## Nextflow Patterns

If you want to find out common structures of Nextflow processes, the [Nextflow Patterns page](https://nextflow-io.github.io/patterns/) collects some recurrent implementation patterns used in Nextflow applications.


::::::::::::::::::::::::::::::::::::::::::::::::::



:::::::::::::::::::::::::::::::::::::::: keypoints

- Outputs to a process are defined using the output blocks.
- You can group input and output data from a process using the tuple qualifier.
- The execution of a process can be controlled using the `when` declaration and conditional statements.
- Files produced within a process and defined as `output` can be saved to a directory using the `publishDir` directive.

::::::::::::::::::::::::::::::::::::::::::::::::::


