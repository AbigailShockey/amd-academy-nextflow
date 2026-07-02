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

Put this codeblock into a Nextflow script named process_output_value.nf:

```groovy 
params.transcriptome="${projectDir}/data/yeast/transcriptome/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz"

process COUNT_CHR_SEQS {
  input:
  val chr

  output:
  val chr

  script:
  """
  zgrep -c '^>Y'$chr $params.transcriptome
  """
}

workflow {

  chr_ch = channel.of('A'..'P')

  COUNT_CHR_SEQS(chr_ch)
  // use the view operator to display contents of the channel
  COUNT_CHR_SEQS.out.view()
}
```

```bash
$ nextflow run process_output_value.nf -process.debug
```

```output 

 N E X T F L O W   ~  version 26.04.4

Launching `process_output_value.nf` [lonely_wing] revision: b4296b8514

executor >  local (16)
[0f/52f20f] process > COUNT_CHR_SEQS (16) [100%] 16 of 16 ✔
B
D
A
C
G
E
F
H
K
I
J
M
L
N
O
P


```

### Output files

If we want to capture a file instead of a value as output we can use the
`path` qualifier that can capture one or more files produced by the process, over the specified channel.

Put this codeblock into a Nextflow script named process_output_file.nf:

```groovy 
params.transcriptome="${projectDir}/data/yeast/transcriptome/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz"

process COUNT_CHR_SEQS {
  input:
  val chr

  output:
  path "${chr}_seq_count.txt"

  script:
  """
  zgrep -c '^>Y'$chr $params.transcriptome > ${chr}_seq_count.txt
  """
}

workflow {
  chr_ch = channel.of('A'..'P')
  COUNT_CHR_SEQS(chr_ch)
  // use the view operator to display contents of the channel
  COUNT_CHR_SEQS.out.view()
}
```

```bash
$ nextflow run process_output_file.nf -process.debug
```


```output 

 N E X T F L O W   ~  version 26.04.4

Launching `process_output_file.nf` [maniac_kare] revision: f1b64d6957

executor >  local (16)
[de/360d6c] process > COUNT_CHR_SEQS (15) [100%] 16 of 16 ✔
/home/rstudio/lessons/amd-academy-nextflow/work/7c/8c923395b18eb437967a1dd66cf581/A_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/e9/48fbf0b839fa4af4200053ceb280df/D_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/10/9ba939f2d755e982bf04f63ba83d64/C_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/ad/be9477a0483de424e0b3dcf28a9a8f/B_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/6d/b060098c6fcf16825027e876925cd5/H_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/71/e22a672887045cb91731f9975ce1aa/F_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/05/5219625165b53772c6f5bc0a92486c/E_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/e2/87a9c2784a3d95ba6be5e0933127af/G_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/de/6e42b59a62df6075488f04a0481749/J_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/07/08365a09f460ed90191e39ba691739/K_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/84/d08d9891add8be7d2debb61aac06b0/I_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/c3/97da6d66fe9fd05b77b0460e15e669/L_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/aa/38a477159216bc2c87a529028ee9f9/M_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/44/901992e9c24861c1d79a474f108862/N_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/19/e7c8f814861dca4b19df377d9051ea/P_seq_count.txt
/home/rstudio/lessons/amd-academy-nextflow/work/de/360d6c80091ca132aee5adff4fe412/O_seq_count.txt
```

In the above example the process `COUNT_CHR_SEQS` creates a file named `<chr>_seq_count.txt` in the work directory containing the number of transcripts within that chromosome.

Since a file parameter using the same name, `<chr>_seq_count.txt`, is declared in the output block, when the task is completed that file is sent over the output channel.

A downstream `operator`, such as `.view` or a `process` declaring the same channel as input will be able to receive it.

### Multiple output files

When an output file name contains a `*` or `?` metacharacter it is interpreted as a pattern match.
This allows us to capture multiple files into a list and output them as a one item channel.

For example, here we will capture the files `sequence_ids.txt` and  `sequence.txt` produced as results from SPLIT\_FASTA in the output channel.

Put this codeblock into a Nextflow script named process_output_multiple.nf:

```groovy 
params.transcriptome="${projectDir}/data/yeast/transcriptome/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz"

process SPLIT_FASTA {
  input:
  path transcriptome

  output:
  path "*"

  script:
  """
  zgrep  '^>' $transcriptome > sequence_ids.txt
  zgrep -v '^>' $transcriptome > sequence.txt
  """
}

workflow {
  transcriptome_ch = channel.fromPath(params.transcriptome)
  
  SPLIT_FASTA(transcriptome_ch)
  // use the view operator to display contents of the channel
  SPLIT_FASTA.out.view()
}
```

```bash 
$ nextflow run process_output_multiple.nf
```

```output

 N E X T F L O W   ~  version 26.04.4

Launching `process_output_multiple.nf` [hopeful_torvalds] revision: 96f880fc78

executor >  local (1)
[5a/ff9ff1] process > SPLIT_FASTA (1) [100%] 1 of 1 ✔
[/home/rstudio/lessons/amd-academy-nextflow/work/5a/ff9ff1dce8a9edd0a7e5debc0eb0d6/sequence.txt, /home/rstudio/lessons/amd-academy-nextflow/work/5a/ff9ff1dce8a9edd0a7e5debc0eb0d6/sequence_ids.txt]


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
  path transcriptome
  each chr

  //add output block here to capture the file "${chr}_seqids.txt"

  script:
  """
  zgrep '^>Y'$chr $transcriptome > ${chr}_seqids.txt
  """
}

workflow {
  transcriptome_ch = channel.fromPath('data/yeast/transcriptome/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz')
  chr_ch = channel.of('A'..'P')

  EXTRACT_IDS(transcriptome_ch, chr_ch)
  EXTRACT_IDS.out.view()
}
```

:::::::::::::::  solution

## Solution

```groovy 
process EXTRACT_IDS {
  input:
  path transcriptome
  each chr

  //add output block here to capture the file "${chr}_seqids.txt"
  output:
  path "${chr}_seqids.txt"

  script:
  """
  zgrep '^>Y'$chr $transcriptome > ${chr}_seqids.txt
  """
}

workflow {
  transcriptome_ch = channel.fromPath('data/yeast/transcriptome/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz')
  chr_ch = channel.of('A'..'P')
  
  EXTRACT_IDS(transcriptome_ch, chr_ch)
  EXTRACT_IDS.out.view()
}
```

```output

 N E X T F L O W   ~  version 26.04.4

Launching `process_exercise_output_answer.nf` [compassionate_tuckerman] revision: 27bbe6283d

executor >  local (16)
[31/5ef214] process > EXTRACT_IDS (16) [100%] 16 of 16 ✔
/home/rstudio/lessons/amd-academy-nextflow/work/8a/14a9d14aa56579bf82a645c2cc36b0/B_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/9a/30bc1ca905bf6377674b8ad960eb4d/D_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/e2/35c156da6ae6ef86d8cd4f6a6df082/A_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/3e/ff4ef6fbd0fe959d4d91e84c224fde/C_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/d5/2b81b1d282ada273cefe765cc4915c/E_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/62/bb065bd8790cc59cbcc2f350581c17/I_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/08/0525016716767cd69a5b2a100b3f97/F_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/12/4e7d6380957c6adf44c8346db750ee/H_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/83/5eb9aa575c6d3a771f6ab01a1d444e/G_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/f1/8d7dae11b125867edafc5534de00d9/K_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/95/c55c3b31acbb8d33b51f29fb842144/J_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/10/dddf9a35137eb0194a21fe3c1f2d65/L_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/18/4fe1d4a0d2926dbfbf89ed745e869c/M_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/d7/eee14e01746ef4514722841b4299d1/O_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/11/c37e15b5970ffbb066e627913c00ca/N_seqids.txt
/home/rstudio/lessons/amd-academy-nextflow/work/31/5ef2147270ac915a5f6f3e4ba7098b/P_seqids.txt
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

Put this codeblock into a Nextflow script named process_tuple_input.nf:

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
nextflow run process_tuple_input.nf  -process.debug
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

Put this codeblock into a Nextflow script named process_tuple_io.nf:

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
nextflow run process_tuple_io.nf
```

The output is now a tuple containing the sample id and the combined fastq files.

```output 

 N E X T F L O W   ~  version 26.04.4

Launching `process_tuple_io.nf` [loquacious_sinoussi] revision: f996b37474

executor >  local (1)
[d7/363b07] process > COMBINE_FQ (1) [100%] 1 of 1 ✔
[ref1, /home/rstudio/lessons/amd-academy-nextflow/work/d7/363b07b508064d1c01a43d53ddfef6/ref1.fq.gz]

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
[ref, [/home/rstudio/lessons/amd-academy-nextflow/work/5f/9e3b6706fcc36a8992ad0a55036f4e/ref_R1.fq.gz, /home/rstudio/lessons/amd-academy-nextflow/work/5f/9e3b6706fcc36a8992ad0a55036f4e/ref_R2.fq.gz]]

```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Conditional execution of a process

The `when` declaration allows you to define a condition that must be verified in order to execute the process. This can be any expression that evaluates a boolean value; `true` or `false`.

It is useful to enable/disable the process execution depending on the state of various inputs and parameters.

In the example below the process `CONDITIONAL` will only execute when the value of the `chr` variable is less than or equal to 5:

Put this codeblock into a Nextflow script named process_when.nf:

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
nextflow run process_when.nf -process.debug
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

Put this codeblock into a Nextflow script named process_directive.nf:

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
    chr_ch = channel.of( 1..22, 'X', 'Y' )
    PRINTCHR( chr_ch )
}
```

```bash
nextflow run process_directive.nf -process.debug
```

```output 
 N E X T F L O W   ~  version 26.04.4

Launching `process_directive.nf` [elated_nightingale] revision: 54635450a2

executor >  local (13)
[96/6d7991] process > PRINTCHR (tagging with chr9) [ 41%] 10 of 24
processing chromosome: 2
number of cpus 1

processing chromosome: 4
number of cpus 1

processing chromosome: 3
number of cpus 1

processing chromosome: 1
number of cpus 1
executor >  local (20)
[00/e71d43] process > PRINTCHR (tagging with chr17) [ 70%] 17 of 24
processing chromosome: 2
number of cpus 1

processing chromosome: 4
number of cpus 1

processing chromosome: 3
number of cpus 1

processing chromosome: 1
number of cpus 1

processing chromosome: 5
number of cpus 1

processing chromosome: 6
number of cpus 1

processing chromosome: 7
number of cpus 1

processing chromosome: 8
number of cpus 1

processing chromosome: 11
number of cpus 1

processing chromosome: 9
number of cpus 1

processing chromosome: 10
number of cpus 1
executor >  local (24)
[b1/0c0fe4] process > PRINTCHR (tagging with chrY)  [100%] 24 of 24 ✔
processing chromosome: 2
number of cpus 1

processing chromosome: 4
number of cpus 1

processing chromosome: 3
number of cpus 1

processing chromosome: 1
number of cpus 1

processing chromosome: 5
number of cpus 1

processing chromosome: 6
number of cpus 1

processing chromosome: 7
number of cpus 1

processing chromosome: 8
number of cpus 1

processing chromosome: 11
number of cpus 1

processing chromosome: 9
number of cpus 1

processing chromosome: 10
number of cpus 1

processing chromosome: 12
number of cpus 1

processing chromosome: 13
number of cpus 1

processing chromosome: 22
number of cpus 1

processing chromosome: X
number of cpus 1

processing chromosome: 15
number of cpus 1

processing chromosome: 14
number of cpus 1

processing chromosome: 16
number of cpus 1
executor >  local (24)
[b1/0c0fe4] process > PRINTCHR (tagging with chrY)  [100%] 24 of 24 ✔
processing chromosome: 2
number of cpus 1

processing chromosome: 4
number of cpus 1

processing chromosome: 3
number of cpus 1

processing chromosome: 1
number of cpus 1

processing chromosome: 5
number of cpus 1

processing chromosome: 6
number of cpus 1

processing chromosome: 7
number of cpus 1

processing chromosome: 8
number of cpus 1

processing chromosome: 11
number of cpus 1

processing chromosome: 9
number of cpus 1

processing chromosome: 10
number of cpus 1

processing chromosome: 12
number of cpus 1

processing chromosome: 13
number of cpus 1

processing chromosome: 22
number of cpus 1

processing chromosome: X
number of cpus 1

processing chromosome: 15
number of cpus 1

processing chromosome: 14
number of cpus 1

processing chromosome: 16
number of cpus 1

processing chromosome: 18
number of cpus 1

processing chromosome: 17
number of cpus 1

processing chromosome: 20
number of cpus 1

processing chromosome: 19
number of cpus 1

processing chromosome: 21
number of cpus 1

processing chromosome: Y
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
nextflow run process_exercise_directives_answers.nf
```

```output

 N E X T F L O W   ~  version 26.04.4

Launching `process_exercise_directives_answers.nf` [admiring_ekeblad] revision: 3e1c08367f

executor >  local (3)
[a4/cf32f1] process > FASTQC (ref2) [100%] 3 of 3 ✔
[ref3, /home/rstudio/lessons/amd-academy-nextflow/work/36/fdd3c30bee58ab1567f1b96a536c76/fastqc_out]
[ref1, /home/rstudio/lessons/amd-academy-nextflow/work/7d/d0971bc88de08fce6a1d8403aeeb70/fastqc_out]
[ref2, /home/rstudio/lessons/amd-academy-nextflow/work/a4/cf32f15140b91a2b56be1a37e4e63b/fastqc_out]

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
ls -l results/merged_reads/ref1.merged.fq.gz
```

```output 
lrwxrwxrwx 1 rstudio rstudio 99 Jun 30 23:00 results/merged_reads/ref1.merged.fq.gz -> /home/rstudio/lessons/amd-academy-nextflow/work/3d/88bbfd2b6b7a85ac81d73ffdecc97c/ref1.merged.fq.gz
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

In the example below we will create an output folder structure in the directory results, which contains a separate sub-directory for sequence id file, `pattern:"*_ids.txt"` ,  and a sequence directory, `results/sequence"` for the `sequence.txt` file. Remember, we need to specify the files we want to copy as outputs.

```groovy 
params.transcriptome="${projectDir}/data/yeast/transcriptome/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz"

process SPLIT_FASTA {
  publishDir "results/ids", pattern: "*_ids.txt", mode: "copy"
  publishDir "results/sequence", pattern: "sequence.txt", mode: "copy"


  input:
  path transcriptome

  output:
  path "*"

  script:
  """
  zgrep  '^>' $transcriptome > sequence_ids.txt
  zgrep -v '^>' $transcriptome > sequence.txt
  """
}

workflow {
  transcriptome_ch = channel.fromPath(params.transcriptome)
  
  SPLIT_FASTA(transcriptome_ch)
  // use the view operator to display contents of the channel
  SPLIT_FASTA.out.view()
}
```

```bash
$ nextflow run process_publishDir_semantic.nf
```

```output

 N E X T F L O W   ~  version 26.04.4

Launching `process_publishDir_semantic.nf` [elegant_kay] revision: 902918802f

executor >  local (1)
[64/219b7c] process > SPLIT_FASTA (1) [100%] 1 of 1 ✔
[/home/rstudio/lessons/amd-academy-nextflow/work/64/219b7c2bdaee1bf645440b085145df/sequence.txt, /home/rstudio/lessons/amd-academy-nextflow/work/64/219b7c2bdaee1bf645440b085145df/sequence_ids.txt]

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


