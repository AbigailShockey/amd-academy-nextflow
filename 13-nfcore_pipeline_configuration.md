---
title: nf-core pipeline configuraton
teaching: 30
exercises: 10
---

::::::::::::::::::::::::::::::::::::::: objectives

- Understand how to configuration nf-core pipelines.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How do I configure nf-core pipelines to use my data?

::::::::::::::::::::::::::::::::::::::::::::::::::

### nf-core config files

nf-core pipelines make use of Nextflow's configuration files to specify how the pipelines runs, define custom parameters and what software management system to use e.g. docker, singularity or conda.

Nextflow can load pipeline configurations from multiple locations.  nf-core pipelines load configuration in the following order:

![A diagram explaining the structure and hierarchy of nextflow.config files. The diagram shows that the default 'base' config is always loaded. It also includes core profiles, such as docker, conda, and test, and server profiles from nf-core/config. Additionally, it highlights that your local config files, located in $HOME/.nextflow/config or specified with -c custom.config, are also considered.](fig/nfcore_config.png 'config')

1. Pipeline: Default 'base' config

- Always loaded. Contains pipeline-specific parameters and "sensible defaults" for things like computational requirements
- Does not specify any method for software packaging. If nothing else is specified, Nextflow will expect all software to be available on the command line.

2. Core config profiles

- All nf-core pipelines come with some generic config profiles. The most commonly used ones are for software packaging: docker, singularity and conda
- Other core profiles are debug and two test profiles. There two test profile, a small test profile (nf-core/test-datasets) for quick test and a full test profile which provides the path to full sized data from public repositories.

3. Server profiles

- At run time, nf-core pipelines fetch configuration profiles from the [configs remote repository](https://github.com/nf-core/configs). The profiles here are specific to clusters at different institutions.
- Because this is loaded at run time, anyone can add a profile here for their system and it will be immediately available for all nf-core pipelines.

4. Local config files given to Nextflow with the `-c` flag

```bash
nextflow run nf-core/viralrecon -r 3.0.0 -c mylocal.config
```

5. Command line configuration: pipeline parameters can be passed on the command line using the `--<parameter>` syntax.

```bash
nextflow run nf-core/viralrecon -r 3.0.0 --email "my@email.com"`
```

#### Config Profiles

nf-core makes use of Nextflow configuration `profiles` to make it easy to apply a group of options on the command line.

Configuration files can contain the definition of one or more profiles. A profile is a set of configuration attributes that can be activated/chosen when launching a pipeline execution by using the `-profile` command line option. Common profiles are `conda`, `singularity` and `docker` that specify which software manager to use.

Multiple profiles are comma-separated. When there are differing configuration settings provided by different profiles, the right-most profile takes priority.

```bash
nextflow run nf-core/viralrecon -r 3.0.0 -profile test,conda
nextflow run nf-core/viralrecon -r 3.0.0 -profile <institutional_config_profile>, test, conda
```

**Note** The order in which config profiles are specified matters. Their priority increases from left to right.


:::::::::::::::::::::::::::::::::::::::: keypoints

- nf-core pipelines can be reconfigured by using custom config files and/or adding command line parameters.

::::::::::::::::::::::::::::::::::::::::::::::::::
