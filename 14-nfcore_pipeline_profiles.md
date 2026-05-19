---
title: Testing nf-core pipelines with profiles
teaching: 30
exercises: 10
---

::::::::::::::::::::::::::::::::::::::: objectives

- Run a small demo nf-core pipeline using a test dataset.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How do I test if an nf-core pipeline works?
- How do I reference nf-core pipelines?

::::::::::::::::::::::::::::::::::::::::::::::::::

### Running nf-core pipelines with test data

The nf-core config profile `test` is special profile, which defines a minimal data set and configuration, that runs quickly and tests the workflow from beginning to end. Since the data is minimal, the output is often nonsense. Real world  example output are instead linked on the nf-core pipeline web page, where the workflow has been run with a full size data set:

```bash
nextflow run nf-core/<pipeline_name> -profile test
```

:::::::::::::::::::::::::::::::::::::::::  callout

### Software configuration profile

Note that you will typically still need to combine this with a software configuration profile for your system - e.g.
`-profile test,conda`.
Running with the test profile is a great way to confirm that you have Nextflow configured properly for your system before attempting to run with real data


::::::::::::::::::::::::::::::::::::::::::::::::::

### Using nf-core pipelines offline

Many of the techniques and resources described above require an active internet connection at run time - pipeline files, configuration profiles and software containers are all dynamically fetched when the pipeline is launched. This can be a problem for people using secure computing resources that do not have connections to the internet.

To help with this, the `nf-core download` command automates the fetching of required files for running nf-core pipelines offline.
The command can download a specific release of a pipeline with `-r`/`--release` .  
By default, the pipeline will download the pipeline code and the institutional nf-core/configs files.

If you specify the flag `--singularity`, it will also download any singularity image files that are required (this needs Singularity to be installed). All files are saved to a single directory, ready to be transferred to the cluster where the pipeline will be executed.

```bash
nf-core pipelines download nf-core/rnaseq -r 3.14.0
```

```output
                                          ,--./,-.
          ___     __   __   __   ___     /,-._.--~\ 
    |\ | |__  __ /  ` /  \ |__) |__         }  {
    | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                          `._,._,'

    nf-core/tools version 4.0.2 - https://nf-co.re


WARNING  Could not find GitHub authentication token. Some API requests may fail.                                                                  

In addition to the pipeline code, this tool can download software containers.
? Download software container images: (Use arrow keys)
 » none
   singularity
   docker
```

:::::::::::::::::::::::::::::::::::::::  challenge

### Exercise  Run a demo nf-core pipeline

Run the `nf-core/demo` pipeline release 1.0.0  with the provided test data using the profile `test` and parameter `--outdir` `results`.

```bash
$ nextflow run nf-core/demo -r 1.0.0 --outdir results -profile test
```

The `nf-core/demo` pipleine is a simple nf-core style bioinformatics pipeline for workshops and demonstrations that runs FASTQC and multiqc.

:::::::::::::::  solution

### Solution

```output
------------------------------------------------------
                                        ,--./,-.
        ___     __   __   __   ___     /,-._.--~'
  |\ | |__  __ /  ` /  \ |__) |__         }  {
  | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                        `._,._,'
  nf-core/demo v1.0.0-g705f18e
------------------------------------------------------
Core Nextflow options
  revision                  : 1.0.0
  runName                   : spontaneous_lamarr
  containerEngine           : docker
  launchDir                 : /home/shockeax/trainings/amd-academy-nextflow
  workDir                   : /home/shockeax/trainings/amd-academy-nextflow/work
  projectDir                : /home/shockeax/.nextflow/assets/nf-core/demo
  userName                  : shockeax
  profile                   : test,docker
  configFiles               : 

Input/output options
  input                     : https://raw.githubusercontent.com/nf-core/test-datasets/viralrecon/samplesheet/samplesheet_test_illumina_amplicon.csv
  outdir                    : out

Institutional config options
  config_profile_name       : Test profile
  config_profile_description: Minimal test dataset to check pipeline function

Max job request options
  max_cpus                  : 2
  max_memory                : 6.GB
  max_time                  : 6.h

!! Only displaying parameters that differ from the pipeline defaults !!
------------------------------------------------------
If you use nf-core/demo for your analysis please cite:

* The pipeline

* The nf-core framework
  https://doi.org/10.1038/s41587-020-0439-x

* Software dependencies
  https://github.com/nf-core/demo/blob/master/CITATIONS.md
------------------------------------------------------
executor >  local (7)
[73/a7c6df] NFCORE_DEMO:DEMO:FASTQC (SAMPLE1_PE)     [100%] 3 of 3 ✔
[0f/99ae5f] NFCORE_DEMO:DEMO:MULTIQC                 [100%] 1 of 1 ✔
-[nf-core/demo] Pipeline completed successfully-
Completed at: 19-May-2026 11:57:42
Duration    : 1m 9s
CPU hours   : (a few seconds)
Succeeded   : 7
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

### Troubleshooting

If you run into issues running your pipeline you can you the nf-core  website  to troubleshoot common mistakes and issues [https://nf-co.re/usage/troubleshooting](https://nf-co.re/usage/troubleshooting) .

#### Extra resources and getting help

If you still have an issue with running the pipeline then feel free to contact the nf-core community via the Slack channel .
The nf-core Slack organisation has channels dedicated for each pipeline, as well as specific topics (eg. `#help`, `#pipelines`, `#tools`, `#configs` and much more).
The nf-core Slack can be found at [https://nfcore.slack.com](https://nfcore.slack.com) (NB: no hyphen in nfcore!). To join you will need an invite, which you can get at [https://nf-co.re/join/slack](https://nf-co.re/join/slack).

You can also get help by opening an issue in the respective pipeline repository on GitHub asking for help.

If you have problems that are directly related to Nextflow and not our pipelines or the nf-core framework tools then check out the [Nextflow gitter channel](https://gitter.im/nextflow-io/nextflow) or the [google group](https://groups.google.com/forum/#!forum/nextflow).

### Referencing a Pipeline

#### Publications

If you use an nf-core pipeline in your work you should cite the main publication for the main nf-core paper, describing the community and framework,
as follows:

> **The nf-core framework for community-curated bioinformatics pipelines.**
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso \& Sven Nahnsen.
> Nat Biotechnol. 2020 Feb 13. doi: [10\.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x). ReadCube: [Full Access Link](https://rdcu.be/b1GjZ)

Many of the pipelines have a publication listed on the nf-core website that can be found [here](https://nf-co.re/publications).

#### DOIs

In addition, each release of an nf-core pipeline has a digital object identifiers (DOIs) for easy referencing in literature
The DOIs are generated by Zenodo from the pipeline's github repository.



:::::::::::::::::::::::::::::::::::::::: keypoints

- nf-core pipelines can be tested by using the test profile.

::::::::::::::::::::::::::::::::::::::::::::::::::