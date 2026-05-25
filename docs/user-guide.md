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
  - Added FIGARO to assist with efficiently determining read quality-filtering parameters 🐘
  - Completed update of README.md file to reflect all new updates/features 🐘 🐔 
  - Minor bug fixes 🐘 🐔

---

## Overview

**Microbiome-Master ITS** is a custom, easy-to-use, modular pipeline for processing raw ITS amplicons into ASVs and generating base visualizations/statistical analyses using Snakemake, QIIME2, DADA2, etc.

### Default Workflow

![QIIME2-DADA2-dag](resources/images/dag.jpeg)

---

## Data

> 👉 *Provide information on input data formats, structure, and sources.*

- **Dataset 1**: FASTQ reads retrieved from NCBI on 2025-01-01.
- **Dataset 2**: Reference genome in FASTA format from Ensembl, downloaded on 2025-01-01.

To download the data, run: `curl -O https://example.com/path/to/dataset1.tar.gz`

---

## Installation

> 🚩 **Pre-requisites**
>  - Conda
>  - Python 3.9+
>  - Recommended OS: Linux
>  - QIIME2 (see below)
>  - FUNGuild (see below)

1. **Clone/copy this repository to your computer**
   - Navigate to the directory where you want the project to live and run:
      ```bash
      git clone https://github.com/AAFC-Bioinfo-AAC/microbiome-master-its.git
      ```
    > :triangular_flag_on_post: *Note! You can also use the "clone" button located on the top of this page.*

2. **Install conda, QIIME 2 (2024.5), and create the pipeline environment**
   - Once you have a working command line environment, install conda following the instructions **[here](https://www.anaconda.com/docs/getting-started/miniconda/install/overview)**.
   - Install QIIME 2 2024.5 following the official **[QIIME 2 installation guide](https://docs.qiime2.org/2024.5/install/)**.
   - Set conda channel priority:
     ```bash
      conda config --set channel_priority flexible
      ```
   - Create the main pipeline environment using the YAML file in `envs/`:
     ```bash
     conda env create -f  workflow/envs/microbiome-master-0.2.yml
     ```

3. **Download FUNGuild**
   - Clone repo from https://github.com/UMNFuN/FUNGuild
   - Ensure file paths of main scripts (`FUNGuild.py` and `Guilds_v1.1.py`) are recorded correctly in the `config.yaml` file

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
      - All paths can be relative or absolute.
      - 🚩 If not specified, default values will be used.
    - If using **FIGARO (recommended)** for read trimming:
        - Place the FIGARO file that comes with this repository wherever you like in your file structure.
        - Reference that path in `config.yaml`.
        > **Important!** Ensure that **raw uncompressed fastq** files are either directly placed in `data/raw` or are symlinked to this location.*
    
---

## Usage

1. **Activate the `microbiome-master-0.2` conda environment**
   - ```conda activate microbiome-master-0.2```

3. **Navigate to the repository folder**

4. **Run a dry-run of the workflow**
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

![Microbial Ecology Group](/resources/images/lablogo.png "Microbial Ecology Group Logo") 

![Agriculture and Agri-Food Canada](/resources/images/aafclogo.png "AAFC logo")

