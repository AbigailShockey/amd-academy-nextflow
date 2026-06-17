---
title: Making your own nf-core pipeline
teaching: 9
exercises: 18
---

::::::::::::::::::::::::::::::::::::::: objectives

- Create a custom nf-core pipeline using nf-core tools.
- Run a custom nf-core pipeline using a test profile.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How do I create a custom nf-core pipeline?
- How do I test a custom nf-core pipeline?

::::::::::::::::::::::::::::::::::::::::::::::::::

## Creating your custom pipeline

To lower the difficulty barrier for nf-core pipeline development, nf-core provides a pipeline template that adheres to all nf-core guidelines, as well as a  command line tool (within nf-core tools) that allows users to create a custom pipeline using this nf-core base template. In this episode, we're going to create your own custom nf-core pipeline using this command line tool.

Let's start by creating a directory for your new pipeline.

```bash
mkdir nfcore-pipeline
cd nfcore-pipeline
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

4.  On the **Basic Details** page, for **GitHub organization**  enter "myorg"  
5.  For **Workflow name** enter "genomeassembler"  
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
cd myorg-genomeassembler
nextflow run . -profile test --outdir results
```

If the pipeline ran successfully, you should see the following:

```output
Nextflow 26.04.1 is available - Please consider updating your version to it

 N E X T F L O W   ~  version 25.10.4

Launching `./main.nf` [angry_visvesvaraya] DSL2 - revision: 27a6d188dd

Input/output options
  input                     : https://raw.githubusercontent.com/nf-core/test-datasets/viralrecon/samplesheet/samplesheet_test_illumina_amplicon.csv
  outdir                    : results

Institutional config options
  config_profile_name       : Test profile
  config_profile_description: Minimal test dataset to check pipeline function

Generic options
  trace_report_suffix       : 2026-05-15_15-06-31

Core Nextflow options
  runName                   : angry_visvesvaraya
  launchDir                 : /home/user/training/myorg-genomeassembler
  workDir                   : /home/user/training/myorg-genomeassembler/work
  projectDir                : /home/user/training/myorg-genomeassembler
  userName                  : user
  profile                   : test
  configFiles               : /home/user/training/myorg-genomeassembler/nextflow.config

!! Only displaying parameters that differ from the pipeline defaults !!
------------------------------------------------------
executor >  local (1)
[b6/042941] MYORG_GENOMEASSEMBLER:GENOMEASSEMBLER:MULTIQC (genomeassembler) [100%] 1 of 1 ✔
-[myorg/genomeassembler] Pipeline completed successfully-
```

The pipeline successfully completed one process, MULTIQC, the output of which can be found in the `results` directory.

:::::::::::::::::::::::::::::::::::::::: keypoints
- You can create a custom pipeline according to the nf-core framework using the `nf-core pipelines create` command.
::::::::::::::::::::::::::::::::::::::::::::::::::
