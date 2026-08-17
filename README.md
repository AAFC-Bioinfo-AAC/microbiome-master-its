<!-- omit in toc -->
# MICROBIOME-MASTER ITS

[![FR](https://img.shields.io/badge/lang-FR-yellow.svg)](README_FR.md)
[![EN](https://img.shields.io/badge/lang-EN-blue.svg)](README.md)

---

<!-- omit in toc -->
## Table of Contents

- [About](#about)
- [Documentation](#documentation)
- [Citation](#citation)
- [Contributors](#contributors)
- [Security](#security)
- [License](#license)

---

## About

The **Microbiome-Master ITS** pipeline is a light-weight, custom built pipeline for routine bioinformatic processing of raw ITS gene region amplicons into **Amplicon Sequence Variants (ASVs)**. The pipeline is managed via [snakemake](https://snakemake.readthedocs.io/en/stable/) and uses a variety of standard microbiome-based data analysis workflows including [QIIME2](https://qiime2.org/), [dada2](https://benjjneb.github.io/dada2/) etc. The pipeline is specifically designed to process Illumina-based paired-end reads, however other input short-read seuqencing data can be used (e.g., Ion Torrent; contact maintainer *(see [CREDITS.md](CREDITS.md))* for more information).

Starting from a QIIME2-formatted mapping file (linking sequencing file names to sample IDs and metadata) and raw demultiplexed .fastq files (uncompressed or compressed), the pipeline will carry out both sequence cleanup (i.e., filtering low-quality bases, primer removal, chimera checking, etc.) and base visualization and statistical analyses (i.e., ordinations, taxa bar plots, rarefaction curves etc; most of these (.qza/.qzv files specifically) can be directly visualized using [qiime2-view](https://view.qiime2.org/)).

The pipeline is built using workflow modules that allow users to specify what kind of analysis they would like to run (i.e., routine workflow). The modularity of the pipeline allows easy integration of new workflows. Currently supported workflows include:

**QIIME2-DADA2 MODULE:**
- ASV table generation using qiime2 implemented version of dada2 and general analysis

**GRDI LEGACY MODULE:**
- OTU-based analysis pipeline now used for backwards compatibility. This module is archived for posterity *[NO LONGER SUPPORTED]*.

---

## Documentation

For technical details, including installation and usage instructions, please refer to the **[User Guide](/docs/user-guide.md)**.

---

## Citation

To cite this project, click the **`Cite this repository`** button on the right-hand sidebar.

---

## Contributors

*This project was developed by the **Microbial Ecology Group (AAFC-Harrow)**. For a list of individual contributions, see **[CREDITS.md](CREDITS.md)**.*

- The following files were adapted from the [Template for Government of Canada open source code repositories](https://github.com/canada-ca/template-gabarit): `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md` and `SECURITY.md`.
- Contributions are welcome! Please review the guidelines in [CONTRIBUTING.md](CONTRIBUTING.md) and ensure you adhere to our [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) to foster a respectful and inclusive environment.
- For a list of key resources used here, see [REFERENCES.md](REFERENCES.md).

---

## Security

⚠️ Do not post any security issues on the public repository! Please report them as described in [SECURITY.md](SECURITY.md).

---

## License

> See the [LICENSE](LICENSE) file for details. Visit [LicenseHub](https://licensehub.org) or [tl;drLegal](https://www.tldrlegal.com/) to view a plain-language summary of this license.

**Copyright ©** His Majesty the King in Right of Canada, as represented by the Minister of Agriculture and Agri-Food, 2026.

---
