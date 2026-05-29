---
title: Deploying nf-core pipelines
teaching: 30
exercises: 10
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

 nf-core/tools version 2.14.1 - https://nf-co.re



 Usage: nf-core [OPTIONS] COMMAND [ARGS]...

 nf-core/tools provides a set of helper tools for use with nf-core Nextflow pipelines.
 It is designed for both end-users running pipelines and also developers creating new pipelines.

╭─ Options ────────────────────────────────────────────────────────────────────────────────────────╮
│ --version                        Show the version and exit.                                      │
│ --verbose        -v              Print verbose output to the console.                            │
│ --hide-progress                  Don't show progress bars.                                       │
│ --log-file       -l  <filename>  Save a verbose log to a file.                                   │
│ --help           -h              Show this message and exit.                                     │
╰──────────────────────────────────────────────────────────────────────────────────────────────────╯
╭─ Commands for users ─────────────────────────────────────────────────────────────────────────────╮
│ list                  List available nf-core pipelines with local info.                          │
│ launch                Launch a pipeline using a web GUI or command line prompts.                 │
│ create-params-file    Build a parameter file for a pipeline.                                     │
│ download              Download a pipeline, nf-core/configs and pipeline singularity images.      │
│ licences              List software licences for a given workflow (DSL1 only).                   │
│ tui                   Open Textual TUI.                                                          │
╰──────────────────────────────────────────────────────────────────────────────────────────────────╯
╭─ Commands for developers ────────────────────────────────────────────────────────────────────────╮
│ create            Create a new pipeline using the nf-core template.                              │
│ lint              Check pipeline code against nf-core guidelines.                                │
│ modules           Commands to manage Nextflow DSL2 modules (tool wrappers).                      │
│ subworkflows      Commands to manage Nextflow DSL2 subworkflows (tool wrappers).                 │
│ schema            Suite of tools for developers to manage pipeline schema.                       │
│ create-logo       Generate a logo with the nf-core logo template.                                │
│ bump-version      Update nf-core pipeline version number.                                        │
│ sync              Sync a pipeline TEMPLATE branch with the nf-core template.                     │
╰──────────────────────────────────────────────────────────────────────────────────────────────────╯
```

### Listing available nf-core pipelines

The simplest sub-command is `nf-core pipelines list`, which lists all available nf-core pipelines in the nf-core Github repository.

The output shows the latest version number and when that was released.
If the pipeline has been pulled locally using Nextflow, it tells you when that was and whether you have the latest version.

Run the command below.

```bash
nf-core pipelines list
```

An example of the output from the command is as follows:

```output


                                          ,--./,-.
          ___     __   __   __   ___     /,-._.--~\
    |\ | |__  __ /  ` /  \ |__) |__         }  {
    | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                          `._,._,'

    nf-core/tools version 2.14.1 - https://nf-co.re


┏━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━┳━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┓
┃ Pipeline Name             ┃ Stars ┃ Latest Release ┃      Released ┃ Last Pulled ┃ Have latest release? ┃
┡━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━╇━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━┩
│ mcmicro                   │     4 │            dev │    2 days ago │           - │ -                    │
│ fastquorum                │    13 │          1.0.0 │  2 months ago │           - │ -                    │
│ rnaseq                    │   821 │         3.14.0 │  6 months ago │           - │ -                    │
│ crisprseq                 │    22 │          2.2.0 │  1 months ago │           - │ -                    │
│ funcscan                  │    62 │          1.1.6 │   2 weeks ago │           - │ -                    │
│ pairgenomealign           │     0 │            dev │    3 days ago │           - │ -                    │
│ multiplesequencealign     │    11 │            dev │    3 days ago │           - │ -                    │
│ denovotranscript          │     0 │            dev │    3 days ago │           - │ -                    │
│ demo                      │     1 │          1.0.0 │  1 months ago │           - │ -                    │
│ demultiplex               │    37 │          1.4.1 │  5 months ago │           - │ -                    │
[..truncated..]
```

#### Filtering available nf-core pipelines

If you supply additional keywords after the `pipelines list` sub-command, the listed pipeline will be filtered.
**Note:** that this searches more than just the displayed output, including keywords and description text.

Here we filter on the keywords **genome** and **assembly**.

```bash
nf-core pipelines list genome assembly
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
│ mag             │   296 │          5.4.2 │  2 months ago │           - │ -                    │
│ bacass          │    87 │          2.6.0 │   2 weeks ago │           - │ -                    │
│ genomeqc        │    20 │            dev │   2 weeks ago │           - │ -                    │
│ funcscan        │   109 │          3.0.0 │  8 months ago │           - │ -                    │
│ genomeassembler │    33 │          1.1.0 │ 10 months ago │           - │ -                    │
│ genomeskim      │     4 │            dev │   4 years ago │           - │ -                    │
│ genomeannotator │    37 │            dev │   4 years ago │           - │ -                    │
└─────────────────┴───────┴────────────────┴───────────────┴─────────────┴──────────────────────┘
```

#### Sorting available nf-core pipelines

You can sort the results by adding the option `--sort` followed by a keyword.
For example, latest release (`--sort release`), when you last pulled a local copy (`--sort pulled`), alphabetically (`--sort name`), or number of GitHub stars (`--sort stars`).

```bash
nf-core pipelines list genome assembly --sort stars
```

```output
          ___     __   __   __   ___     /,-._.--~\ 
    |\ | |__  __ /  ` /  \ |__) |__         }  {
    | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                          `._,._,'

    nf-core/tools version 4.0.2 - https://nf-co.re


┏━━━━━━━━━━━━━━━━━┳━━━━━━━┳━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┓
┃ Pipeline Name   ┃ Stars ┃ Latest Release ┃      Released ┃ Last Pulled ┃ Have latest release? ┃
┡━━━━━━━━━━━━━━━━━╇━━━━━━━╇━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━┩
│ mag             │   296 │          5.4.2 │  2 months ago │           - │ -                    │
│ funcscan        │   109 │          3.0.0 │  8 months ago │           - │ -                    │
│ bacass          │    87 │          2.6.0 │   2 weeks ago │           - │ -                    │
│ genomeannotator │    37 │            dev │   4 years ago │           - │ -                    │
│ genomeassembler │    33 │          1.1.0 │ 10 months ago │           - │ -                    │
│ genomeqc        │    20 │            dev │   2 weeks ago │           - │ -                    │
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

In the example below we are pulling the viralrecon pipeline version 2.6.0

```bash
nextflow pull nf-core/viralrecon -revision 2.6.0
```

We can check the pipeline has been pulled using the `nf-core list` command.

```bash
nf-core pipelines list virus -s pulled
```

We can see from the output we have the latest release.

```output
                                          ,--./,-.
          ___     __   __   __   ___     /,-._.--~\ 
    |\ | |__  __ /  ` /  \ |__) |__         }  {
    | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                          `._,._,'

    nf-core/tools version 4.0.2 - https://nf-co.re


┏━━━━━━━━━━━━━━━━━━┳━━━━━━━┳━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┓
┃ Pipeline Name    ┃ Stars ┃ Latest Release ┃     Released ┃    Last Pulled ┃ Have latest release? ┃
┡━━━━━━━━━━━━━━━━━━╇━━━━━━━╇━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━┩
│ viralrecon       │   163 │          2.6.0 │ 7 months ago │ 16 seconds ago │ No (v2.6.0)          │
│ metatdenovo      │    34 │          1.3.0 │ 9 months ago │              - │ -                    │
│ viralintegration │    18 │          0.1.1 │  3 years ago │              - │ -                    │
│ viralmetagenome  │    36 │          1.1.1 │ 2 months ago │              - │ -                    │
└──────────────────┴───────┴────────────────┴──────────────┴────────────────┴──────────────────────┘
```

:::::::::::::::::::::::::::::::::::::::::  callout

### Development Releases

If not specified, Nextflow will fetch the default git branch. For pipelines with a stable release this the default branch is `master` - this branch contains code from the latest release. For pipelines in early development that don't have any releases, the default branch is `dev`.


::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

### Exercise: Fetch the latest viralrecon pipeline

1. Use the `nextflow pull` command to download the latest `nf-core/viralrecon` pipeline

2. Use the `nf-core pipelines list` command to see if you have the latest version of the pipeline

:::::::::::::::  solution

### Solution

Use the `nextflow pull` command to download the latest `nf-core/viralrecon` pipeline

```bash
$ nextflow pull nf-core/viralrecon
```

Use the `nf-core list` command to see if you have the latest version of the pipeline

```bash
$ nf-core pipelines list virus --sort pulled
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Usage instructions and documentation

You can find general documentation and instructions for Nextflow and nf-core on the [nf-core website](https://nf-co.re/) .
Pipeline-specific documentation is bundled with each pipeline in the /docs folder. This can be read either locally, on GitHub, or on the nf-core website.

Each pipeline has its own webpage at [https://nf-co.re/](https://nf-co.re/)\<pipeline\_name> e.g. [nf-co.re/rnaseq](https://nf-co.re/rnaseq/usage)

In addition to this documentation, each pipeline comes with basic command line reference. This can be seen by running the pipeline with the parameter `--help` , for example:

```bash
nextflow run -r 3.0.0 nf-core/viralrecon --help
```

:::::::::::::::::::::::::::::::::::::::: keypoints

- nf-core is a community-led project to develop a set of best-practice pipelines built using the Nextflow workflow management system.
- The nf-core tool (`nf-core`) is a suite of helper tools that aims to help people run and develop nf-core pipelines.
- nf-core pipelines can be found using `nf-core pipelines list`, or by checking the nf-core website.
- An nf-core workflow is run using `nextflow run nf-core/<pipeline>` syntax.

::::::::::::::::::::::::::::::::::::::::::::::::::


