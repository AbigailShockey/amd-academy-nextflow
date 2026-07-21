---
title: Getting started with nf-core
teaching: 30
exercises: 15
---

::::::::::::::::::::::::::::::::::::::: objectives

- Understand what nf-core is and how it relates to Nextflow.
- List and explain the six main benefits of using nf-core.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- What is nf-core?
- Why should I use the nf-core framework?

::::::::::::::::::::::::::::::::::::::::::::::::::

### What is nf-core?

nf-core is a community-led project to develop a set of best-practice pipelines built using Nextflow workflow management system.
Pipelines are governed by a set of guidelines, enforced by community code reviews and automatic code testing.

![A diagram showcasing the key aspects of nf-core, a community effort to provide best-practice analysis pipelines. The diagram is divided into three sections: Deploy, Participate, and Develop. The Deploy section includes features like Stable pipelines, Centralized configs, List and update pipelines, and Download for offline use. The Participate section highlights Documentation, Slack workspace, Twitter updates, and Hackathons. The Develop section emphasizes the Starter template, Code guidelines, CI code linting and tests, and Helper tools.](fig/nf-core.png 'nf-core')


### The core features and key benefits of nf-core

There are six core features of nf-core that are beneficial to bioinformaticians and other computational biologist, whether they be in a government, private sector, or academic setting:

1. **Community**: One major advantage of the nf-core framework is its community, which develops best practices, pipelines, and tools. All code is hosted openly on GitHub, and members actively participate in code reviews and discussions via GitHub and Slack. Both developers and users can participate in improving pipelines. This community-driven approach overcomes the traditional barriers between research groups, allowing for shared expertise and collaborative development.
2. **Guidelines**: The nf-core community has established a set of guidelines that outline the requirements and recommendations for pipeline development. This ensures consistency and adherence to best practices across all workflows. These guidelines require all pipelines to provide thorough documentation, including usage examples and results descriptions. Additionally, test data sets must be included to enable automated continuous-integration testing. This ensures pipeline functionality is maintained with every change.
3. **Portability**: All nf-core pipelines allow for execution across local machines and cloud platforms. This surmounts the challenge of creating reproducible analyses across different systems. The nf-core framework enforces consistent implementation practices through templates, guidelines, and lint tests that ensure all pipelines fully utilize Nextflow's portability features. Additionally, nf-core requires all pipelines to bundle dependencies in Docker containers, providing static runtime environments. This minimizes issues related to hardware differences, operating systems, and software versions.
4. **Reproducibility**: Once stable, ​nf-core​ pipelines are given tagged releases on GitHub. Each version is given a number using semantic versioning, and nf-core​ pipelines support the collection of analysis metadata such as pipeline version, software versions, and command and parameter configuration.
5. **Standardization**: To help developers get started with new pipelines, nf-core provides a standardized pipeline template that adheres to all nf-core guidelines, as well as command line tools for pipeline creation. This lowers barriers to development and provides consistent structure across all pipelines, making them easier to learn, use, and develop.
7. **Research Impact**: The nf-core framework increases reliability and reproducibility of scientific analyses, and it accelerates scientific discoveries through ready-to-use, validated workflows.

:::::::::::::::::::::::::::::::::::::::: keypoints

- nf-core is a community-led project to develop a set of best-practice pipelines built using the Nextflow workflow management system.
- nf-core is portable, reproducible, and standardized, making it an ideal framework for workflow design

::::::::::::::::::::::::::::::::::::::::::::::::::