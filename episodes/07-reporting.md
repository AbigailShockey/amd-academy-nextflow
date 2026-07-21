---
title: Reporting
teaching: 20
exercises: 5
---

::::::::::::::::::::::::::::::::::::::: objectives

- View Nextflow pipeline run logs.
- Use `nextflow log` to view more information about a specific run.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How do I get information about my pipeline run?
- How can I see what commands I ran?

::::::::::::::::::::::::::::::::::::::::::::::::::

## Nextflow log

Once a script has run, Nextflow stores a log of all the workflows executed in the current folder.
Similar to an electronic lab book, this means you have a record of all processing steps and commands run.

You can print Nextflow's execution history and log information using the `nextflow log` command.

```bash
$ nextflow log
```

```output 
TIMESTAMP          	DURATION	RUN NAME               	STATUS	REVISION ID	SESSION ID                          	COMMAND
```

This will print a summary of the executions log and runtime information for all pipelines run. By default, included in the summary, are the date and time it ran, how long it ran for, the run name, run status, a revision ID, the session id and the command run on the command line.

:::::::::::::::::::::::::::::::::::::::  challenge

## Show Execution Log

Listing the execution logs of previous invocations of all pipelines in a directory.

```bash
$ nextflow log
```

:::::::::::::::  solution

## Solution

The output will look similar to this:

```output 
TIMESTAMP          	DURATION	RUN NAME       	STATUS	REVISION ID	SESSION ID                          	COMMAND
2021-03-19 13:45:53	6.5s    	fervent_babbage	OK    	c54a707593 	15487395-443a-4835-9198-229f6ad7a7fd	nextflow run wc.nf
2021-03-19 13:46:53	6.6s    	soggy_miescher 	OK    	c54a707593 	58da0ccf-63f9-42e4-ba4b-1c349348ece5	nextflow run wc.nf --samples 'data/yeast/reads/*.fq.gz'
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Pipeline execution report

If we want to get more information about an individual run we can add the run name or session ID to the `log` command.

For example:

```bash 
$ nextflow log sharp_mahavira
```

```bash 
/home/workspace/amd-academy-nextflow/work/23/a8b488c02a46e763be40b6044c3c2a
/home/workspace/amd-academy-nextflow/work/d8/4cd0032e5fc524f71f2b5a00bec1e0
```

This will list the work directory for each process.

::::::::::::::::::::::::::::::::::::::::  callout

## Task ID

The task ID is a a 32 hexadecimal digit,e.g. `a8b488c02a46e763be40b6044c3c2a`.
A task's unique ID is generated as a 128-bit hash number obtained from a composition of the task's:

- Inputs values
- Input files
- Command line string
- Container ID
- Conda environment
- Environment modules
- Any executed scripts in the bin directory
  

::::::::::::::::::::::::::::::::::::::::::::::::::

## Fields

If we want to print more metadata we can use the `log` command and the option `-f` (fields) followed by a comma delimited list of fields.
This can be composed to track the provenance of a workflow result.

For example:

```bash 
$ nextflow log sharp_mahavira -f 'process,exit,hash,duration'
```

Will output the process name, exit status, hash and duration of the process for the `sharp_mahavira` run to the terminal.

```output
TRIM    0       23/a8b488       40.2s
FASTQC  0       d8/4cd003       9.2s
```

The complete list of available fields can be retrieved with the command:

```bash 
$ nextflow log -l
```

```output 
attempt
complete
container
cpus
disk
duration
env
error_action
exit
hash
inv_ctxt
log
memory
module
name
native_id
pcpu
peak_rss
peak_vmem
pmem
process
queue
rchar
read_bytes
realtime
rss
scratch
script
start
status
stderr
stdout
submit
syscr
syscw
tag
task_id
time
vmem
vol_ctxt
wchar
workdir
write_bytes
```

### Script

If we want a log of all the commands executed in the pipeline we can use the `script`
field. It is important to note that the resultant output can not be used to run the pipeline steps.

### Filtering

The output from the `log` command can be very long. We can subset the output using the option `-F` (filter) specifying  the filtering criteria.  This will print only those tasks matching a pattern using the syntax `=~/<pattern>/`.

For example to filter for process with the name `FASTQC` we would run:

```bash 
$ nextflow log sharp_mahavira -F 'process =~ /FASTQC/'
```

```output 
/home/workspace/amd-academy-nextflow/work/d8/4cd0032e5fc524f71f2b5a00bec1e0
```

This can be useful to locate specific tasks work directories.

:::::::::::::::::::::::::::::::::::::::  challenge

## View run log

Use the Nextflow `log` command specifying a `run name` and the fields.
name, hash, process and status

::::::::::::::  solution

Example solution using run name `elegant_descartes`.

```bash 
$ nextflow log elegant_descartes -f name,hash,process,status
```

:::::::::::::::::::::::::

## Filter pipeline run log

Use the `-F` option and a regular expression to filter the for a specific process e.g. multiqc.

::::::::::::::  solution

```bash 
$ nextflow log elegant_descartes -f name,hash,process,status -F 'process =~ /multiqc/'
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: keypoints

- Nextflow can produce a custom execution report with run information using the `log` command.
- You can generate a report using the `-t` option specifying a template file.

::::::::::::::::::::::::::::::::::::::::::::::::::