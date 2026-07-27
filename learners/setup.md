---
title: Setup
permalink: /setup/
---

# Setup

## Training directory

Each learner should setup a training folder e.g. `amd-academy-nextflow`

```bash
mkdir amd-academy-nextflow
cd amd-academy-nextflow
```

There are three items that you need to download:

1. The training software.
2. The training dataset.
3. The workshop scripts.

## Training software

A list of software with version required for this training is listed below:

|Software|Version|
|--------|-------|
|Nextflow|26.04.4|
|nf-core/tools|4.0.2|
|seqtk|1.4|
|shovill|1.1.0|
|fastqc|0.12.1|
|multiqc|1.34|
|python|>=3.8|

### conda

The simplest way to install the software for this course is using conda.

To install conda see [here](https://carpentries-incubator.github.io/introduction-to-conda-for-data-scientists/setup/).

An environment file is provided here [environment.yml](https://raw.githubusercontent.com/AbigailShockey/amd-academy-nextflow/refs/heads/main/episodes/data/environment.yml)

```bash
# You can use either wget or curl to download content from the web via the command line.
# wget
wget https://raw.githubusercontent.com/AbigailShockey/amd-academy-nextflow/refs/heads/main/episodes/data/environment.yml

# curl 
curl -L -o environment.yml https://raw.githubusercontent.com/AbigailShockey/amd-academy-nextflow/refs/heads/main/episodes/data/environment.yml
```

To create the training environment run:

```bash
conda env create -n amd-academy-nextflow -f environment.yml
```

Then activate the environment by running

```bash
conda activate amd-academy-nextflow
```

## Training scripts

To aid in the delivery of the lesson, the scripts mentioned in each episode, can be found in the respective episode folders in the [lesson GitHub repository](https://github.com/AbigailShockey/amd-academy-nextflow/tree/main/episodes/files/scripts) or the [supplemental files GitHub repository](https://github.com/AbigailShockey/amd-academy-nf-files/tree/main/scripts).

### Data

The data for the workshop can be retrieved from the `data` folder of the [supplemental files GitHub repository](https://github.com/AbigailShockey/amd-academy-nf-files/tree/main/data).

## Visual Studio Code editor setup

Any text editor can be used to write Nextflow scripts. A recommended  code editor is [Visual Studio Code](https://code.visualstudio.com/).

Go to [Visual Studio Code](https://code.visualstudio.com/) and you should see a download button. The button or buttons should be specific to your platform and the download package should be  installable.


### Nextflow language support in Visual Studio Code

You can add Nextflow language support in Visual Studio Code by clicking the [install](https://marketplace.visualstudio.com/items?itemName=nextflow.nextflow) button on the Nextflow language extension.


## Nextflow install without conda

Nextflow can be used on any POSIX-compatible system (Linux, macOS, etc), and on Windows through WSL. It requires Bash 3.2 (or later) and Java 11 (or later, up to 22) to be installed

## Nextflow installation

Install the latest version of Nextflow copy \& pasting the following snippet in a terminal window:

```bash
# Make sure that Java v11 or later is installed:
java -version

# Install Nextflow
curl -s https://get.nextflow.io | bash
```

## Add Nextflow binary to your user's PATH:

```bash
mv nextflow ~/bin/
# OR system-wide installation:
# sudo mv nextflow /usr/local/bin
```

Check the correct installation running the following command:

```bash
nextflow info
```

## nf-core/tools installation without conda

### Pip

```bash
pip install nf-core
```
