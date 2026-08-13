<!-- omit in toc -->
# MICROBIOME-MASTER ITS - USER GUIDE

---

<!-- omit in toc -->
## Table of Contents

- [Changelog](#changelog)
- [Overview](#overview)
- [Data](#data)
- [Installation](#installation)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Output](#output)

---

## Changelog

**v.1.0.2 [Dec 12/25]**
  - Fixed microbiome-master default conda .yaml file 🐘
  - Completed update of README.md file to reflect all new updates/features 🐘 🐔 
  - Minor bug fixes 🐘 🐔

---

## Overview

**Microbiome-Master ITS** is a custom, easy-to-use, modular pipeline for processing raw ITS amplicons into ASVs and generating base visualizations/statistical analyses using Snakemake, QIIME2, DADA2, etc.

### Default Workflow

![MODULE-QIIME2-DADA2-dag](/resources/images/dag.jpeg "Dafault Workflow Overview") 

---

## Data

To run the workflow, you simply need **1) metadata mapping file** (linking sequencing files to sample-ids and contextual data) and **2) your raw fastq forward and reverse reads**

> This repository also includes test data (from: [Benalcazar et al. 2024](https://pubmed.ncbi.nlm.nih.gov/38734653/)) that can be used for initial testing and/or troubleshooting found **data/raw/**
> - To extract test data run: `tar -xvf data/raw/sample_data.tar.gz -C data/raw/`

---

## Installation

> 🚩 **Pre-requisites**
>  - Conda
>  - Python 3.9+
>  - Recommended OS: Linux / Windows WSL
>  - QIIME2 (2024.5)
>  - ITSxpress (see below)
>  - FUNGuild (see below)

1. **Clone/copy this repository to your computer**
   - Navigate to the directory where you want the project to live and run:
      ```bash
      git clone https://github.com/AAFC-Bioinfo-AAC/microbiome-master-its.git
      ```
    > :triangular_flag_on_post: *Note! You can also use the "clone" button located on the top of this page.*

2. **Install conda, QIIME 2 (2024.5), and create the pipeline environment**
   - Once you have a working command line environment, install conda following the instructions **[here](https://www.anaconda.com/docs/getting-started/miniconda/install/overview)**.
   - Install **QIIME 2 2024.5** following the official **[QIIME 2 installation guide](https://docs.qiime2.org/2024.5/install/)**.
     - 🚩 *Note* this workflow was tested on the QIIME2 2024.5 release but will probably work with newer versions. New QIIME2 versions will be tested soon!
      
3. **Install ITSxpress-qiime2 within the QIIME2 conda environment following the installation steps [here](https://github.com/arivers/itsxpressqiime2)**
   - Once ITSxpress-qiime2 is installed including all relevant dependencies, check that it's working properly by running (in the qiime2 environment):
       - `qiime dev refresh-cache`
       - `qiime itsxpress`
   - There should be no errors detected when running the above commands
   - deactivate the qiime2 environment and proceed to the next step

4. **Install Microbiome-Master working conda environment**
   - Set conda channel priority:
     ```bash
      conda config --set channel_priority flexible
      ```
   - Create the main pipeline environment using the YAML file in `envs/`:
     ```bash
     conda env create -f  workflow/envs/microbiome-master-0.2.yml
     ```

5. **Download [FUNGuild](https://github.com/UMNFuN/FUNGuild.git)**
   - Run `git clone https://github.com/UMNFuN/FUNGuild.git workflow/scripts/FUNGuild`
     - 🚩 *Note* FUNGuild can be downloaded anywhere, just ensure the file paths of main scripts (`FUNGuild.py` and `Guilds_v1.1.py`) are recorded correctly in the `config.yaml` file

---

## Setup Instructions

1. **Create a metadata mapping file**
    - Update the QIIME2 formatted `data/mapping/metadata_mapping.txt` file and ensure sequence file prefixes correspond to the correct sample IDs.
    - For information on how to format mapping (manifest) see **[here](https://use.qiime2.org/en/2026.4/references/metadata/)**.
    - Include as much metadata, including physicochemistry data, as possible.
      - 🚩 *Important!* This file must be in **tab-separated format**.
      - 🚩 Often there are invalid characters or spaces in data entries that will cause certain scripts to break. **Check the mapping file carefully to avoid headaches :cry:**

2. **Update `config.yaml` file**
    - Update this file with the relevant information and preferences for your analysis.
      - The DADA2 trimming and denoising parameters should be optimized for your amplicon. This may require trying different combinations of parameters **(Do NOT rely on the default values)**
        - Good strategy (especially for large datasets) is to try various parameters on a smaller subset of your data to assess read loss/retention
            > **Tip!** check `data/process/qiime-dada2-module/denoising_stats/dada2_report.html` for a quick assessment of the dada2 output after completion of the step in the workflow
    - Other notes:
      - All paths can be relative or absolute.
      - If not specified, default values will be used
      - **Important!** Ensure that **raw uncompressed or compressed fastq** files are either directly placed in `data/raw` or are symlinked to this location*

---

## Usage

1. **Activate the `microbiome-master-0.2` conda environment**
   - ```conda activate microbiome-master-0.2```

3. **Navigate to the repository folder**

4. Optional: **Run a dry-run of the workflow**
   - ```snakemake --snakefile microbiome-master-its.smk --use-conda --cores <desired-cores> --dry-run```
   - *Replace `<desired-cores>` with the number of CPU cores you want Snakemake to use.*

5. **Run workflow**
   - ```snakemake --snakefile microbiome-master-its.smk --use-conda --cores <desired-cores> |& tee -a log.txt```
   
*Notes:*
- Ensure adequate disk space for temporary and output files.

---

## Output

Intermediate files include:
- `data/process/<module-name>/`: All associated intermediate files generated within the selected modul

Output files include:

- `results/<module-name>/`: All visualizations and relevant result files including feature tables.

---

![Microbial Ecology Group](/resources/images/lablogo.png "MELOGO") 

![Agriculture and Agri-Food Canada](/resources/images/aafclogo.png "AAFC logo")

