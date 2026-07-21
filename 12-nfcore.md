---
title: Deploying nf-core pipelines
teaching: 30
exercises: 15
---

::::::::::::::::::::::::::::::::::::::: objectives

- Understand what nf-core is and how it relates to Nextflow.
- Use the nf-core helper tool to find nf-core pipelines.
- Understand how to configuration nf-core pipelines.
- Run a small demo nf-core pipeline using a test dataset.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- Where can I find best-practice Nextflow bioinformatic pipelines?
- How do I run nf-core pipelines?
- How do I configure nf-core pipelines to use my data?
- How do I reference nf-core pipelines?

::::::::::::::::::::::::::::::::::::::::::::::::::

### What is nf-core?

nf-core is a community-led project to develop a set of best-practice pipelines built using Nextflow workflow management system.
Pipelines are governed by a set of guidelines, enforced by community code reviews and automatic code testing.

![A diagram showcasing the key aspects of nf-core, a community effort to provide best-practice analysis pipelines. The diagram is divided into three sections: Deploy, Participate, and Develop. The Deploy section includes features like Stable pipelines, Centralized configs, List and update pipelines, and Download for offline use. The Participate section highlights Documentation, Slack workspace, Twitter updates, and Hackathons. The Develop section emphasizes the Starter template, Code guidelines, CI code linting and tests, and Helper tools.](fig/nf-core.png 'nf-core')

In this episode we will covering finding, deploying and configuring nf-core pipelines.

### What are nf-core pipelines?

nf-core pipelines are an organised collection of Nextflow scripts,  other non-nextflow scripts (written in any language), configuration files, software specifications, and documentation hosted on [GitHub](https://github.com/nf-core). There is generally a single pipeline for a given data and analysis type e.g. There is a single pipeline for bulk RNA-Seq. All nf-core pipelines are distributed under the, permissive free software, [MIT licences](https://en.wikipedia.org/wiki/MIT_License).

### What is nf-core tools?

nf-core provides a suite of helper tools aim to help people run and develop pipelines.
The [nf-core tools](https://nf-co.re/tools) package is written in Python and can run from the command line or imported and used within other packages.

#### nf-core tools sub-commands

You can use the `--help` option to see the range of nf-core tools sub-commands.
In this episode we will be covering the `list`, `launch` and `download` sub-commands which
aid in the finding and deployment of the nf-core pipelines.

```bash
nf-core --help
```

```output


                                          ,--./,-.
          ___     __   __   __   ___     /,-._.--~\ 
    |\ | |__  __ /  ` /  \ |__) |__         }  {
    | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                          `._,._,'

    nf-core/tools version 4.0.2 - https://nf-co.re


 Usage: nf-core [OPTIONS] COMMAND [ARGS]...                           
                                                                      
 nf-core/tools provides a set of helper tools for use with nf-core    
 Nextflow pipelines.                                                  
 It is designed for both end-users running pipelines and also         
 developers creating new pipelines.                                   
                                                                      
 ═ Commands ═════════════════════════════════════════════════════════ 
 interface                              Launch the nf-core interface  
 modules        m,module                Commands to manage Nextflow   
                                        DSL2 modules (tool wrappers). 
 pipelines      p,pipeline              Commands to manage nf-core    
                                        pipelines.                    
 subworkflows   s,swf,subworkflow       Commands to manage Nextflow   
                                        DSL2 subworkflows (tool       
                                        wrappers).                    
 test-datasets  t,td,tds,test-datasets  Commands to manage nf-core    
                                        test datasets.                
                                                                      
 ═ Options ══════════════════════════════════════════════════════════ 
 --version            Show the version and exit.                      
 --verbose        -v  Print verbose output to the console.            
 --hide-progress      Don't show progress bars.                       
 --log-file       -l  Save a verbose log to a file. [<filename>]      
 --help           -h  Show this message and exit. 
```

### Listing available nf-core pipelines

The simplest sub-command is `nf-core pipelines list`, which lists all available nf-core pipelines in the nf-core Github repository.

The output shows the latest version number and when that was released.
If the pipeline has been pulled locally using Nextflow, it tells you when that was and whether you have the latest version.

Run the command below.

```bash
$ nf-core pipelines list
```

An example of the output from the command is as follows:

```output
                                          ,--./,-.
          ___     __   __   __   ___     /,-._.--~\ 
    |\ | |__  __ /  ` /  \ |__) |__         }  {
    | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                          `._,._,'

    nf-core/tools version 4.0.2 - https://nf-co.re


┏━━━━━━━━━━━┳━━━━━━━┳━━━━━━━━━━━┳━━━━━━━━━━━┳━━━━━━━━━━━┳━━━━━━━━━━━━┓
┃           ┃       ┃           ┃           ┃           ┃ Have       ┃
┃ Pipeline  ┃       ┃    Latest ┃           ┃      Last ┃ latest     ┃
┃ Name      ┃ Stars ┃   Release ┃  Released ┃    Pulled ┃ release?   ┃
┡━━━━━━━━━━━╇━━━━━━━╇━━━━━━━━━━━╇━━━━━━━━━━━╇━━━━━━━━━━━╇━━━━━━━━━━━━┩
│ variantb… │    50 │     1.5.0 │  3 months │         - │ -          │
│           │       │           │       ago │           │            │
│ deepmuts… │     5 │       dev │  11 hours │         - │ -          │
│           │       │           │       ago │           │            │
│ mhcquant  │    49 │     3.2.0 │  2 months │         - │ -          │
│           │       │           │       ago │           │            │
│ proteinf… │   108 │     2.0.0 │  4 months │         - │ -          │
│           │       │           │       ago │           │            │
│ methylseq │   197 │     4.2.0 │  7 months │         - │ -          │
│           │       │           │       ago │           │            │
│ rnastruc… │     1 │       dev │ yesterday │         - │ -          │
│ datasync  │    10 │       dev │    2 days │         - │ -          │
│           │       │           │       ago │           │            │
│ raredise… │   122 │     3.1.2 │   2 weeks │         - │ -          │
│           │       │           │       ago │           │            │
│ rnasplice │    68 │     1.0.4 │   2 years │         - │ -          │
│           │       │           │       ago │           │            │
│ sarek     │   583 │     3.9.0 │   3 weeks │         - │ -          │
[..truncated..]
```

#### Filtering available nf-core pipelines

If you supply additional keywords after the `pipelines list` sub-command, the listed pipeline will be filtered.
**Note:** that this searches more than just the displayed output, including keywords and description text.

Here we filter on the keywords **genome** and **assembly**.

```bash
$ nf-core pipelines list genome assembly
```

```output
                                          ,--./,-.
          ___     __   __   __   ___     /,-._.--~\ 
    |\ | |__  __ /  ` /  \ |__) |__         }  {
    | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                          `._,._,'

    nf-core/tools version 4.0.2 - https://nf-co.re


┏━━━━━━━━━━━━━━━━━┳━━━━━━━┳━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┓
┃ Pipeline Name   ┃ Stars ┃ Latest Release ┃      Released ┃ Last Pulled ┃ Have latest release? ┃
┡━━━━━━━━━━━━━━━━━╇━━━━━━━╇━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━┩
│ mag             │   308 │          5.4.2 │  4 months ago │           - │ -                    │
│ bacass          │    91 │          2.6.0 │  3 months ago │           - │ -                    │
│ genomeqc        │    24 │            dev │   1 weeks ago │           - │ -                    │
│ genomeassembler │    33 │          1.1.0 │ 12 months ago │           - │ -                    │
│ funcscan        │   117 │          4.0.0 │   3 weeks ago │           - │ -                    │
│ genomeskim      │     4 │            dev │   4 years ago │           - │ -                    │
│ genomeannotator │    38 │            dev │   4 years ago │           - │ -                    │
└─────────────────┴───────┴────────────────┴───────────────┴─────────────┴──────────────────────┘
```

#### Sorting available nf-core pipelines

You can sort the results by adding the option `--sort` followed by a keyword.
For example, latest release (`--sort release`), when you last pulled a local copy (`--sort pulled`), alphabetically (`--sort name`), or number of GitHub stars (`--sort stars`).

```bash
$ nf-core pipelines list genome assembly --sort stars
```

```output
                                          ,--./,-.
          ___     __   __   __   ___     /,-._.--~\ 
    |\ | |__  __ /  ` /  \ |__) |__         }  {
    | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                          `._,._,'

    nf-core/tools version 4.0.2 - https://nf-co.re


┏━━━━━━━━━━━━━━━━━┳━━━━━━━┳━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┓
┃ Pipeline Name   ┃ Stars ┃ Latest Release ┃      Released ┃ Last Pulled ┃ Have latest release? ┃
┡━━━━━━━━━━━━━━━━━╇━━━━━━━╇━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━┩
│ mag             │   308 │          5.4.2 │  4 months ago │           - │ -                    │
│ funcscan        │   117 │          4.0.0 │   3 weeks ago │           - │ -                    │
│ bacass          │    91 │          2.6.0 │  3 months ago │           - │ -                    │
│ genomeannotator │    38 │            dev │   4 years ago │           - │ -                    │
│ genomeassembler │    33 │          1.1.0 │ 12 months ago │           - │ -                    │
│ genomeqc        │    24 │            dev │   1 weeks ago │           - │ -                    │
│ genomeskim      │     4 │            dev │   4 years ago │           - │ -                    │
└─────────────────┴───────┴────────────────┴───────────────┴─────────────┴──────────────────────┘
```

:::::::::::::::::::::::::::::::::::::::::  callout

### Archived pipelines

Archived pipelines are not returned by default. To include them, use the `--show_archived` flag.


::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

### Exercise: listing nf-core pipelines

1. Use the `--help` flag to print the list command usage.
2. Sort all pipelines by popularity (stars) and find out which is the most popular?.
3. Filter pipelines for those that work with DNA and find out how many there are?

:::::::::::::::  solution

### Solution

1. Use the `--help` flag to print the list command usage.

```bash
$ nf-core pipelines list --help
```

2. Sort all pipelines by popularity (stars).


```bash
$ nf-core pipelines list --sort stars
```

The rnaseq pipeline is the most popular.

3. Filter pipelines for those that work with DNA.

```bash
$ nf-core pipelines list dna
```

There are 11 pipelines that work with DNA.

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

### Running nf-core pipelines

#### Software requirements for nf-core pipelines

nf-core pipeline software dependencies are specified using either Docker, Singularity or Conda. It is Nextflow that handles the downloading of containers and creation of conda environments. In theory it is possible to run the pipelines with software installed by other methods (e.g. environment modules, or manual installation), but this is not recommended.

#### Fetching pipeline code

Unless you are actively developing pipeline code, you should use Nextflow's [built-in functionality](https://www.nextflow.io/docs/latest/sharing.html) to fetch nf-core pipelines. You can use the following command to pull the latest version of a remote workflow from the nf-core github site.;

```bash
$ nextflow pull nf-core/<PIPELINE>
```

**Note** Nextflow will also automatically fetch the pipeline code when use `nextflow run nf-core/<PIPELINE>` command.


For the best reproducibility, it is good to explicitly reference the pipeline version number that you wish to use with the `-revision`/`-r` flag.

In the example below we are pulling the viralrecon pipeline version 3.0.0. Viralrecon is not yet upated to strict config parsing, a change implemented in v26 of Nextflow (the version installed in the working environment) that we will not discuss as part of this training. We need to export the `NXF_SYNTAX_PARSER` param equal to `v1` to run viralrecon without an error.

```bash
$ export NXF_SYNTAX_PARSER=v1
$ nextflow pull nf-core/viralrecon -revision 3.0.0
```

```output
Checking nf-core/viralrecon:3.0.0 ...
 downloaded from https://github.com/nf-core/viralrecon.git - revision: 395079f1d2 [3.0.0]
```

## Usage instructions and documentation

You can find general documentation and instructions for Nextflow and nf-core on the [nf-core website](https://nf-co.re/) .
Pipeline-specific documentation is bundled with each pipeline in the /docs folder. This can be read either locally, on GitHub, or on the nf-core website.

Each pipeline has its own webpage at [https://nf-co.re/](https://nf-co.re/)\<pipeline\_name> e.g. [nf-co.re/rnaseq](https://nf-co.re/rnaseq/usage)

In addition to this documentation, each pipeline comes with basic command line reference. This can be seen by running the pipeline with the parameter `--help` , for example:

```bash
nextflow run -r 3.0.0 nf-core/viralrecon --help -profile test
```

**Note:** For some pipelines the `--help` option is sufficient, but viralrecon requires its required parameters be fulfilled in order for the `--help` option to work. This is why we used a special profile called `test`. We will talk about test profiles in the next episode.

:::::::::::::::::::::::::::::::::::::::: keypoints

- nf-core is a community-led project to develop a set of best-practice pipelines built using the Nextflow workflow management system.
- The nf-core tool (`nf-core`) is a suite of helper tools that aims to help people run and develop nf-core pipelines.
- nf-core pipelines can be found using `nf-core pipelines list`, or by checking the nf-core website.
- An nf-core workflow is run using `nextflow run nf-core/<pipeline>` syntax.

::::::::::::::::::::::::::::::::::::::::::::::::::